import subprocess, sys
from math import factorial

# Parse arguments
if len(sys.argv) != 2:
    raise Exception("usage: python3 factorial.py <value1>")

x = int(sys.argv[1])
result = factorial(x)

subprocess.run(["cast", "abi-encode", "f(uint256)", str(result)])
