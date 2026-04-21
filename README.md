[![SecureFlow CI Pipeline](https://github.com/nathannnguyenn/SecureFlow/actions/workflows/ci.yml/badge.svg)](https://github.com/nathannnguyenn/SecureFlow/actions/workflows/ci.yml)


\# SecureFlow: Hardened Distributed Network Forensics \& Anomaly Detector



\## Architecture \& Overview

SecureFlow is a containerized Intrusion Detection System (IDS). It is divided into two distinct subnets:

\* \*\*Subnet A (Isolated Sensor Network):\*\* Runs a C-based static packet analyzer and a Python mTLS transmitter. This network has no outbound internet access (`internal: true`) to prevent malware propagation.

\* \*\*Subnet B (Management Network):\*\* Runs a Python Log Aggregator that receives alerts over mTLS, cryptographically hashes them, and writes them to a shared volume.



\## Runbook

To build, deploy, and demonstrate the vertical slice, simply run:

```bash

./generate\_certs.sh

make up \&\& make demo

