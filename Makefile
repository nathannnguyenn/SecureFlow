.PHONY: up demo test down

up:
	@echo "Applying Master Reset: Fixing Docker credentials..."
	-mv ~/.docker/config.json ~/.docker/config.json.backup 2>/dev/null || true
	@echo "Wiping corrupted certificates and regenerating..."
	# Use Docker to clean old certs (bypassing sudo) and generate new ones to avoid CRLF errors
	docker run --rm -v "$${PWD}:/app" -w /app ubuntu bash -c "rm -rf src/sensor/certs/* src/aggregator/certs/* && apt-get update && apt-get install -y openssl dos2unix && dos2unix generate_certs.sh && bash generate_certs.sh"
	docker-compose up -d --build

demo:
	@echo "Running Vertical Slice: Injecting synthetic anomaly..."
	mkdir -p artifacts/release
	docker exec secureflow-sensor-1 nmap -sN -p 80 -Pn -n aggregator
	@echo "Waiting 5 seconds for mTLS handshake and log generation..."
	sleep 5
	@echo "Extracting JSON metric..."
	docker cp secureflow-aggregator-1:/logs/detection_metrics.json ./artifacts/release/detection_metrics.json
	@echo "Compiling execution logs..."
	# Generating the standard .log file with key processing steps
	echo "=== AGGREGATOR KEY PROCESSING STEPS ===" > ./artifacts/release/system_execution.log
	docker logs secureflow-aggregator-1 >> ./artifacts/release/system_execution.log 2>&1
	echo "" >> ./artifacts/release/system_execution.log
	echo "=== SENSOR KEY PROCESSING STEPS ===" >> ./artifacts/release/system_execution.log
	docker logs secureflow-sensor-1 >> ./artifacts/release/system_execution.log 2>&1
	@echo "Demo complete. Grading artifacts automatically generated in artifacts/release/"
	
test:
	pytest tests/ --cov=src/ --cov-report=term-missing

down:
	docker-compose down -v
	
clean: down
	@echo "Cleaning up generated artifacts and temporary files..."
	rm -rf artifacts/
	# Use Docker to wipe certs without WSL permission denied errors
	docker run --rm -v "$${PWD}:/app" -w /app ubuntu bash -c "rm -rf src/sensor/certs/* src/aggregator/certs/*"
	# Remove Python and Pytest cache directories
	rm -rf .pytest_cache .coverage
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@echo "Clean complete."