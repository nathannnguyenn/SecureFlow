.PHONY: bootstrap up demo clean test

bootstrap:
    @echo "Bootstrapping project environment..."
    mkdir -p data/pcaps data/logs artifacts/release certs
    @echo "Generating development certificates for mTLS..."
    openssl req -newkey rsa:2048 -nodes -keyout certs/dev.key -x509 -days 365 -out certs/dev.crt -subj "/CN=SecureFlow"

up:
    docker-compose up --build -d

demo:
    @echo "Running end-to-end demo..."
    docker-compose exec sensor python3 run_analysis.py
    @echo "Check artifacts/release/ for CSV metrics and tamper-evident logs."

clean:
    docker-compose down -v
    rm -rf certs/* data/logs/* artifacts/release/*

test:
    @echo "Running minimal alpha and robust beta tests..."