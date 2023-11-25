// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {GCD as G} from "src/GCD.sol";

contract GCDTest is Test {
    // copied from DSTestPlus.sol
    // Convert uint to string, from https://github.com/mzhu25/sol2string/blob/13f566f7dc61c820c24a673da72d0114183a17c8/contracts/LibUintToString.sol
    uint256 private constant MAX_UINT256_STRING_LENGTH = 78;
    uint8 private constant ASCII_DIGIT_OFFSET = 48;
    function uintToString(uint256 n) internal pure returns (string memory nstr) {
        if (n == 0) return "0";

        // Overallocate memory
        nstr = new string(MAX_UINT256_STRING_LENGTH);
        uint256 k = MAX_UINT256_STRING_LENGTH;
        // Populate string from right to left (lsb to msb).
        while (n != 0) {
            assembly {
                let char := add(ASCII_DIGIT_OFFSET, mod(n, 10))
                mstore(add(nstr, k), char)
                k := sub(k, 1)
                n := div(n, 10)
            }
        }
        assembly {
            nstr := add(nstr, k) // shift pointer over to actual start of string
            mstore(nstr, sub(MAX_UINT256_STRING_LENGTH, k)) // store actual string length
        }
        return nstr;
    }

    function test_GCD1() public {
        uint256 actual = G.gcd(270, 192);
        uint256 expected= 6;
        assertEq(actual, expected);
    }

    function test_GCD2() public {
        uint256 actual = G.gcd(24123, 2130);
        uint256 expected = 3;
        assertEq(actual, expected);
    }

    function test_GCD3() public {
        uint256 actual = G.gcd(6658353797990, 8331168180698);
        uint256 expected = 2;
        assertEq(actual, expected);
    }

    function testFuzz_GCD(uint256 a, uint256 b) public {
        a = bound(a, 0, 1000);
        b = bound(b, 0, 1000);

        string[] memory inputs = new string[](4);
        inputs[0] = "python3";
        inputs[1] = "test/gcd.py";
        inputs[2] = uintToString(a);
        inputs[3] = uintToString(b);

        bytes memory ret = vm.ffi(inputs);
        (uint256 output) = abi.decode(ret, (uint256));
        assertEq(output, G.gcd(a, b));
    }
}
