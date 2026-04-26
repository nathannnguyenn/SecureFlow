\\# Section D: Evaluation in Progress







\\## 1. Collected Datasets



For this initial evaluation phase, synthetic datasets were generated using active network scanning. 



\\\* \\\*\\\*Tool:\\\*\\\* `Nmap` (Network Mapper)



\\\* \\\*\\\*Target:\\\*\\\* SecureFlow Aggregator Node (172.20.0.2)



\\\* \\\*\\\*Artifacts:\\\*\\\* The resulting telemetry has been captured and exported as an initial JSON dataset (`artifacts/release/detection\\\_metrics.json`). Future evaluations in Week 16 will incorporate `.pcap` files capturing sustained synthetic attacks.







\\## 2. Initial Evaluation Table



Below is a preliminary table evaluating the C-sniffer's accuracy against different synthetic traffic types injected during the vertical slice testing.







| Attack Type | Tool Used | Expected Result | Actual Result | Status |



| :--- | :--- | :--- | :--- | :--- |



| Standard TCP Handshake | `curl` | Ignore | Ignored | PASS |



| NULL Scan (Flags 0x00) | `nmap -sN` | Alert Triggered | Alert Triggered | PASS |



| Xmas Scan (FIN/PSH/URG)| `nmap -sX` | Alert Triggered | Alert Triggered | PASS |







\\## 3. Draft Results \\\& Observations



\\\*\\\*What we are observing so far:\\\*\\\*



The isolated sensor network architecture successfully prevents unauthorized outbound connections while maintaining internal mTLS telemetry. The static C-based packet analyzer (utilizing `libpcap`) is highly efficient at reading raw Ethernet frames and immediately flagging malformed TCP packets (like NULL and Xmas scans). 







However, because the sniffer is highly specialized, it currently lacks the statefulness required to detect volumetric attacks like SYN floods. The Python aggregator successfully hashes incoming logs via SHA-256, proving that our tamper-evident invariants hold under initial testing conditions. Moving toward Week 16, testing will shift toward capturing full `.pcap` traces of these events to measure the exact latency between the sensor detection and the aggregator's disk-write execution.





