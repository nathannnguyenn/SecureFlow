import pytest
import hashlib
import sys
import os

# Adjust path to import aggregator logic
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'src', 'aggregator')))
from server import hash_log

def test_happy_path_hashing():
    log_entry = '{"alert": "NULL Scan Detected", "src_ip": "192.168.1.5"}'
    expected_hash = hashlib.sha256(log_entry.encode()).hexdigest()
    assert hash_log(log_entry) == expected_hash

def test_negative_empty_log():
    empty_hash = hashlib.sha256(b"").hexdigest()
    assert hash_log("") == empty_hash

def test_edge_case_malformed_json():
    malformed_log = "{alert: NULL Scan"
    assert len(hash_log(malformed_log)) == 64