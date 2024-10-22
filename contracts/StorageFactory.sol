// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./SimpleStorage.sol";

contract StorageFactory{
    SimpleStorage[] public simpleStorageArray;

    function createSimplestorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function storageFactoryStore (uint256 _simpleStorageIndex, uint256 _simpleStorageNumber)  public {
        //ABI - Application Binary Interface
        //Address
        simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber);
    }

    function storageFactoryGet(uint256 _simpleStorageIndex) public view returns(uint256){        
        return simpleStorageArray[_simpleStorageIndex].retrieve();
    }
}