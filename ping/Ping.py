import socket
import time
import sys
from ping3 import ping

def _ping_v4(address: str) -> int:
    try:
        ping_time = ping(address)
        if ping_time is not None:
            return ping_time * 1000
        else:
            return -1
    except Exception as e:
        # print(f"Error: {e}")
        return -1

def _ping_v6(address: str, timeout: int = 5) -> int:
    try:
        # Create a raw socket for IPv6
        with socket.socket(socket.AF_INET6, socket.SOCK_RAW, socket.IPPROTO_ICMPV6) as sock:
            sock.settimeout(timeout)
            start_time = time.time()
            # Create ICMPv6 Echo Request
            icmpv6 = b'\x80\x00\x00\x00\x00\x00\x00\x00'  # Type: 128 (Echo Request), Code: 0
            sock.sendto(icmpv6, (address, 0))
            response, _ = sock.recvfrom(1024)
            end_time = time.time()
            return (end_time - start_time) * 1000
    except socket.error as e:
        # print(f"Socket error: {e}")
        return -1

def Ping(address: str, timeout: int = 5) -> int:
    if ':' in address:
        return _ping_v6(address, timeout)
    else:
        return _ping_v4(address)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python ping.py <host>")
        sys.exit(1)

    address = sys.argv[1]
    rtt = Ping(address)
    if rtt != -1:
        print(int(rtt))
    else:
        print(-1)
