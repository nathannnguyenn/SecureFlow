FROM python:3.10-slim

# Install dependencies for C compilation and packet sniffing
RUN apt-get update && apt-get install -y \
    libpcap-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the code and certs into the container
COPY . .

# Compile the C sniffer
RUN gcc -o sniffer sniffer.c -lpcap

# Run the Python client
CMD python3 client.py any