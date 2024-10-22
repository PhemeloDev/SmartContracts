// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract SimpleStorage {
    //solidity types : typesboolean, uint , int, string, address, bytes

    //0xd9145CCE52D386f254917e481eB44e9943F39138

    uint256 public favoriteNumber;   

    mapping(string => uint256)public nametoFavNumber;
    mapping(uint256 => string)public favNumbertoName;

    struct People{
        uint256 favoriteNumber;
        string name;
    }

    People[] public people;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
        favoriteNumber += 1;
        addSomeMore(favoriteNumber);
    }

    function addSomeMore(uint256 value) public{
        favoriteNumber+= value;
    }

    function retrieve() public view returns (uint256){
        return favoriteNumber;
    }

    function addPerson(uint256 _favoriteNumber, string memory _name) public {
        people.push(People({favoriteNumber: _favoriteNumber, name: _name}));
        nametoFavNumber[_name] = _favoriteNumber;
        favNumbertoName[_favoriteNumber] = _name;
    }
}