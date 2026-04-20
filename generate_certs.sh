#!/bin/bash
echo "Generating mTLS Certificates for SecureFlow..."
mkdir -p src/sensor/certs src/aggregator/certs

# 1. Generate the Certificate Authority (CA)
openssl req -x509 -newkey rsa:4096 -keyout ca.key -out ca.crt -days 365 -nodes -subj "/CN=SecureFlowCA"

# 2. Generate and sign the Aggregator (Server) Certificate
openssl req -newkey rsa:4096 -keyout server.key -out server.csr -nodes -subj "/CN=aggregator"
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365

# 3. Generate and sign the Sensor (Client) Certificate
openssl req -newkey rsa:4096 -keyout client.key -out client.csr -nodes -subj "/CN=sensor"
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 365

# Distribute certs to the respective containers
cp ca.crt server.crt server.key src/aggregator/certs/
cp ca.crt client.crt client.key src/sensor/certs/

# Clean up local root directory
rm *.crt *.key *.csr *.srl
echo "Certificates generated and distributed!"