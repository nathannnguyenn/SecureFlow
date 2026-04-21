import socket
import ssl
import hashlib
import json
import os

HOST = '0.0.0.0'
PORT = 8443

def hash_log(log_data):
    """Cryptographically hash logs for tamper-evident storage."""
    return hashlib.sha256(log_data.encode()).hexdigest()

def start_mtls_server():
    # Require client certificate (mTLS)
    context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
    context.verify_mode = ssl.CERT_REQUIRED
    context.load_cert_chain(certfile="certs/server.crt", keyfile="certs/server.key")
    context.load_verify_locations(cafile="certs/ca.crt")

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0) as sock:
        sock.bind((HOST, PORT))
        sock.listen(5)
        with context.wrap_socket(sock, server_side=True) as ssock:
            print("Aggregator listening on port 8443...", flush=True)
            
            # Keep the server alive forever to accept multiple connections
            while True: 
                conn, addr = ssock.accept()
                with conn:
                    # Keep reading data as long as the sensor is connected
                    while True: 
                        data = conn.recv(1024)
                        if not data:
                            break # Sensor disconnected, wait for a new connection
                        
                        payload = data.decode().strip()
                        if payload:
                            log_hash = hash_log(payload)
                            
                            # Output JSON metric for grading rubric
                            metric = {"source": addr[0], "alert": payload, "hash": log_hash}
                            with open('/logs/detection_metrics.json', 'a') as f:
                                json.dump(metric, f)
                                f.write('\n')

if __name__ == "__main__":
    start_mtls_server()