FROM python:3.10-slim

WORKDIR /app

# Copy the Python server and certificates
COPY server.py .
COPY certs/ ./certs/

# Create the logs directory for the shared volume
RUN mkdir -p /logs

# Run the Python server
CMD ["python3", "server.py"]