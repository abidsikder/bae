"""
Calculates the gcd of the two provided numbers.

usage: python3 gcd.py <value1> <value2>
"""

import subprocess, sys
from math import gcd

# Parse arguments
if len(sys.argv) != 3:
    raise Exception("usage: python3 gcd.py <value1> <value2>")

a = int(sys.argv[1])
b = int(sys.argv[2])

divisor = gcd(a, b)
subprocess.run(["cast", "abi-encode", "f(uint256)", str(divisor)])
