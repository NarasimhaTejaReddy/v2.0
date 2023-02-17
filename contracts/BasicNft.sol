// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import 'hardhat/console.sol';
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BasicNft is ERC721 {
    address private owner;
    uint256 public tokenId;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        owner = msg.sender;
        tokenId = 1;
    }

    function mintNFTtoken() public {        
        require(msg.sender == owner, "Only owner can mint");
        _safeMint(msg.sender, tokenId);
        tokenId++;
    }

    function totalSupply() public view returns (uint256) {
        return tokenId - 1;
    }
}