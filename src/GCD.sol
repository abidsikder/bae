// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

library GCD {
    /**
     * @notice Greatest common divisor function, unsigned integers with no fixed decimal points
     * @param a Any normal integer, there are no decimal points
     * @param b Any normal integer, there are no decimal points
     *
     * @return The greatest common divisor, no decimal points
     */
    function gcd(uint256 a, uint256 b) internal pure returns(uint256) {
        uint256 temp;
        // Guarantee a >= b to avoid two entire different loop bodies
        if (b > a) {
            temp = a;
            a = b;
            b = temp;
        }
        while (a > 0 && b > 0) {
            while (a >= b) {
                a -= b;
            }
            temp = a;
            a = b;
            b = temp;
        }
        return a == 0 ? b : a;
    }
}
