// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.19;

import {UD60x18, mul, sqrt} from "@prb/math/UD60x18.sol";

library Hypotenuse {
    /**
     * @notice Calculates the hypotenuse of two right triangle side lengths. We leave it to the caller to verify that there is no overflow before the operation will happen.
     * @param x An 18 decimal fixed point unsigned number.
     * @param y An 18 decimal fixed point unsigned number.
     *
     * @return The hypotenuse length, as an 18 decimal fixed point unsigned number.
     */
    function hypot(UD60x18 x, UD60x18 y) internal pure returns (UD60x18) {
        return sqrt(mul(x,x) + mul(y,y));
    }
}
