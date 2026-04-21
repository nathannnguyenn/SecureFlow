.PHONY: up demo test down

up:
	# Use Docker to generate certs to avoid Windows line-ending errors on a fresh clone
	docker run --rm -v "$${PWD}:/app" -w /app ubuntu bash -c "apt-get update && apt-get install -y openssl dos2unix && dos2unix generate_certs.sh && bash generate_certs.sh"
	docker-compose up -d --build

demo:
	@echo "Running Vertical Slice: Injecting synthetic anomaly..."
	docker exec secureflow-sensor-1 nmap -sN -p 80 -Pn -n aggregator
	@echo "Demo complete. Check artifacts/release/detection_metrics.json for logs and JSON."
	
test:
	pytest tests/ --cov=src/ --cov-report=term-missing

down:
	docker-compose down -v