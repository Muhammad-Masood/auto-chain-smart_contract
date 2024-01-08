// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AutoChain is ERC20 {
    constructor() ERC20("AutoChain", "AC") {
        _mint(msg.sender, 1000 * 10 ** 18);
    }
}
