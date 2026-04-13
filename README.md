SecureFlow: Hardened Network Forensics
SecureFlow is a reproducible, containerized network anomaly detector. It parses PCAPs and live socket traffic, securely transmitting alerts via mTLS to a centralized, tamper-evident logging server.

Setup & Execution
Clone this repository.
Run make bootstrap to initialize directories and generate development certificates.
Run make up to build and start the sensor and aggregator nodes.
Run make demo to execute the vertical slice and view the output.
Run make clean to spin down the environment and remove generated artifacts.

Project Structure
/sensor - C/Python packet capture and analysis logic.
/aggregator - mTLS server and secure log storage.
/data - Volume mounts for input PCAPs and output logs.
/artifacts/release - Security evidence, generated CSVs, and charts.