// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

library Factorial {
    /**
     * @notice Calculates factorial for an unsigned integer.
     * @param x Any normal unsigned integer. This number must be 57 or smaller due to uint256's representation limits.
     * You can verify using Julia that 57! is the biggest factorial computable for a uint256.
     * `factorial(big(57)) < big(2)^256 - 1` will be true
     * `factorial(big(58)) < big(2)^256 - 1` will be false
     *
     * @return The factorial.
     */
    function factorial(uint256 x) internal pure returns (uint256) {
        uint256 DOMAIN_MAX = 57;
        uint256 DOMAIN_MIN = 0;
        require(x >= DOMAIN_MIN && x <= DOMAIN_MAX);

        uint256 z = 1;
        uint256 fact = 1;
        while (z <= x) {
            fact = fact * z;
            z = z + 1;
        }
        return fact;
    }
}
