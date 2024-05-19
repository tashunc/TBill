// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./TBill.sol";

contract AuthorizeContract is Ownable {
    TBill private tBillContract;

    constructor(address _tBillContract, address owner)
    Ownable(owner)
    {
        tBillContract = _tBillContract;
    }


}
