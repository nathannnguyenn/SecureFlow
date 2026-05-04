[![SecureFlow CI Pipeline](https://github.com/nathannnguyenn/SecureFlow/actions/workflows/ci.yml/badge.svg)](https://github.com/nathannnguyenn/SecureFlow/actions/workflows/ci.yml)

# SecureFlow: Hardened Distributed Network Forensics & Anomaly Detector

## 1. Architecture & Overview
SecureFlow is a containerized Intrusion Detection System (IDS). It is divided into two distinct subnets:
* **Subnet A (Isolated Sensor Network):** Runs a C-based static packet analyzer and a Python mTLS transmitter. This network has no outbound internet access (`internal: true`) to prevent malware propagation.
* **Subnet B (Management Network):** Runs a Python Log Aggregator that receives alerts over mTLS, cryptographically hashes them, and writes them to a shared volume.

## 2. Runbook
**Initial Setup & Run:**
To build, deploy, and demonstrate the vertical slice, run:
```bash
make up
make demo
```

## 3. Demo Video
**Demo Video:**
https://youtu.be/55k-wm9wS5Q

## 4. Contribution Log & Code Ownership

**Team Members:** Dominic Isaia & Nathan Nguyen

### Contribution Log
* **Dominic:** Engineered the automated `Makefile` extraction pipeline, resolved WSL2/Docker volume synchronization bugs, implemented the `os.makedirs` override for reliable JSON log generation, and authored the final system evaluation report.
* **Nathan:** Configured the GitHub Actions CI/CD pipeline, developed the initial C-sniffer logic, generated the mTLS certificates, and wrote the Python client.

### Code Ownership Map (Directory-Level)
* `.github/workflows/` ➔ Nathan (CI/CD Pipeline)
* `src/sensor/` ➔ Dominic (C-based Sniffer & Python mTLS Transmitter)
* `src/aggregator/` ➔ Nathan (Python Log Aggregator & Hashing Logic)
* `Makefile` & `docker-compose.yml` ➔ Dominic (Build Automation & Infrastructure)
* `certs/` & `generate_certs.sh` ➔ Dominic (Cryptographic Foundations)