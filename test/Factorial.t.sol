pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Factorial as F} from "src/Factorial.sol";

contract FactorialTest is Test {
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

    function test_Factorial3() public {
        uint actual = F.factorial(3);
        uint expected = 6;
        assertEq(actual, expected);
    }

    function test_Factorial0() public {
        uint actual = F.factorial(0);
        uint expected = 1;
        assertEq(actual, expected);
    }

    function test_Factorial1() public {
        uint actual = F.factorial(1);
        uint expected = 1;
        assertEq(actual, expected);
    }

    function test_Factorial5() public {
        uint actual = F.factorial(5);
        uint expected = 120;
        assertEq(actual, expected);
    }

    function testFuzz_Factorial(uint256 x) public {
        x = bound(x, 0, 57);

        string[] memory inputs = new string[](3);
        inputs[0] = "python3";
        inputs[1] = "test/factorial.py";
        inputs[2] = uintToString(x);

        bytes memory ret = vm.ffi(inputs);
        (uint256 output) = abi.decode(ret, (uint256));
        assertEq(output, F.factorial(x));
    }
}