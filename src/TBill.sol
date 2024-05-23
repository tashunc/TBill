// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract TBill is ERC20, ERC20Pausable, Ownable, ERC20Permit {
    constructor(address initialOwner)
    ERC20("TBill", "TBILL")
    Ownable(initialOwner)
    ERC20Permit("TBill")
    {}

    function pause() internal onlyOwner {
        _pause();
    }

    function unpause() internal onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) internal onlyOwner whenNotPaused{
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) onlyOwner {
        _burn(from, amount);
        if (_paused == true) {
            _unpause();
        }
    }


    function _update(address from, address to, uint256 value)
    internal
    override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }
}