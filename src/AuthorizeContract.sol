// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TBill.sol";
import {ConfirmedOwner} from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/v1_0_0/libraries/FunctionsRequest.sol";
import {OracleLib} from "./lib/OracleLib.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/v1_3_0/FunctionsClient.sol";

contract AuthorizeContract is Ownable {
    using Strings for uint256;
    using OracleLib for AggregatorV3Interface;
    using FunctionsRequest for FunctionsRequest.Request;


    address private s_functionsRouter;
    string private s_mintSource;
    string private s_redeemSource;

    // Check to get the donID for your supported network https://docs.chain.link/chainlink-functions/supported-networks
    bytes32 private s_donID;
    uint256  private s_portfolioBalance;
    uint64 private s_secretVersion;
    uint8 private s_secretSlot;

//s_requestIdToRequest mapping(bytes32 => )

    TBill private tBillContract;
    ERC20 USDC_Contract = ERC20(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48));

    constructor(
        address owner,
        string memory _mintSource,
        string memory _redeemSource,
        address _functionsRouter,
        uint64 _secretVersion,
        uint8 _secretSlot)
    Ownable(owner)
    FunctionsClient(functionsRouter)
    {
        s_functionsRouter = _functionsRouter;
        s_mintSource = _mintSource;
        s_redeemSource = _redeemSource;
        s_secretVersion = _secretVersion;
        tBillContract = TBill(address(this));
    }

    function AuthorizeMint(uint256 amount) external onlyOwner returns (bytes32 requestId){
// require() check the vault usd value
        if (_getCollateralRatioAdjustedTotalBalance(amountOfTokensToMint) > s_portfolioBalance) {
            revert dTSLA__NotEnoughCollateral();
        }
        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(s_mintSource); // Initialize the request with JS code
        req.addDONHostedSecrets(s_secretSlot, s_secretVersion);
       // todo request send, id mapping
        tBillContract.mint(address(this), amount);
        return requestId;
    }

    function buy(uint256 amount) external {
// require() check the vault usd value
        require(amount % 1 == 0, "Invalid Amount");
        USDC_Contract.transferFrom(msg.sender, address(this), amount);
        tBillContract.transferFrom(msg.sender, address(this), amount);
    }

    function sell(uint256 amount) external {
// require() check the vault usd value
        require(amount % 1 == 0, "Invalid Amount");
        USDC_Contract.transfer(msg.sender, amount);
        tBillContract.transfer(msg.sender, amount);
    }

}
