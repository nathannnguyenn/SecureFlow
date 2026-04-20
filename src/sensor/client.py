import subprocess
import socket
import ssl
import sys

AGGREGATOR_HOST = 'aggregator'
AGGREGATOR_PORT = 8443

def send_alert(alert_json, ssock):
    ssock.sendall(alert_json.encode())
    print(f"Securely transmitted: {alert_json.strip()}")

def start_sensor(target):
    context = ssl.create_default_context(ssl.Purpose.SERVER_AUTH)
    context.load_verify_locations("certs/ca.crt")
    context.load_cert_chain(certfile="certs/client.crt", keyfile="certs/client.key")

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        with context.wrap_socket(sock, server_hostname="aggregator") as ssock:
            print("Connected to Aggregator via mTLS.")
            
            process = subprocess.Popen(
                ['./sniffer', target],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )

            for line in process.stdout:
                if "alert" in line:
                    send_alert(line, ssock)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 client.py <interface|file.pcap>")
        sys.exit(1)
    
    target_interface_or_file = sys.argv[1]
    start_sensor(target_interface_or_file)