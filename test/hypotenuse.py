import subprocess, sys
from decimal import Decimal
from math import sqrt

# Parse arguments
if len(sys.argv) != 3:
    raise Exception("usage: python3 hypotenuse.py <value1> <value2>")

raw_x= Decimal(sys.argv[1])
raw_y= Decimal(sys.argv[2])
x = raw_x / (10 ** 18)
y = raw_y / (10 ** 18)

# Convert back to an integer scaled by 1e18, then ABI encode the result
raw_result = sqrt(x*x + y*y)
result = int(raw_result *10 ** 18)

subprocess.run(["cast", "abi-encode", "f(uint256)", str(result)])
