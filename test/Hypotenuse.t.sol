pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Hypotenuse as H} from "src/Hypotenuse.sol";
import {UD60x18, mul, sqrt, convert} from "@prb/math/UD60x18.sol";

contract HypotenuseTest is Test {
    UD60x18 THREE = convert(3);
    UD60x18 FOUR = convert(4);
    UD60x18 FIVE = convert(5);

    function test_Hypot345() public {
        UD60x18 actual = H.hypot(THREE, FOUR);
        UD60x18 expected = FIVE;
        UD60x18 diff = expected - actual;
        uint256 diff_nat = convert(diff);
        assertEq(diff_nat, 0);
    }

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

    // 1e14 = 0.01% relative error tolerance
    uint256 constant TOL = 1e14;
    function testFuzz_Hypot(uint256 _x, uint256 _y) public {
        // We need to limit to a minimum to make sure we are not getting errors due to large errors compare to the small magnitude of numbers
        // We also limit the max to avoid issues in the PRB Math library
        uint256 INPUT_MAX = 100000000000000000000;
        uint256 INPUT_MIN = 10000000000;
        _x = bound(_x, INPUT_MIN, INPUT_MAX);
        _y = bound(_y, INPUT_MIN, INPUT_MAX);

        string[] memory inputs = new string[](4);
        inputs[0] = "python3";
        inputs[1] = "test/hypotenuse.py";
        inputs[2] = uintToString(_x);
        inputs[3] = uintToString(_y);

        bytes memory ret = vm.ffi(inputs);
        (uint256 output) = abi.decode(ret, (uint256));
        uint256 actual = convert(H.hypot(convert(_x),convert(_y)));
        assertApproxEqRel(actual, output, TOL);
    }
}