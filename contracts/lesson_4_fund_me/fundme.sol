// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract fundMe {
    uint256 public minUSD = 50;

    function fund() public payable {
        require(msg.value > 1e18, "Did not send enough");
    }

    function getPrice() public {
        //ABI
        //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
    }

    function getConversionRate() public {}

    function withdraw() private {}
}
