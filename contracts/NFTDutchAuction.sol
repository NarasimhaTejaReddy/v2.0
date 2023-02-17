// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import 'hardhat/console.sol';
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


contract NFTDutchAuction {
    IERC721 public erc721TokenAddress;
    uint256 public nftTokenId;
    uint256 public reservePrice;
    uint256 public numBlocksAuctionOpen;
    uint256 public offerPriceDecrement;
    uint256 public startsAt;
    uint256 public initialPrice;
    uint256 public currentPrice;
    uint256 public auctionEndBlock;
    uint256 public winBid;
    address payable public owner;
    address public winner;
    bool public auctionEnded;

    constructor(address _erc721TokenAddress, uint256 _nftTokenId, uint256 _reservePrice, uint256 _numBlocksAuctionOpen, uint256 _offerPriceDecrement) payable{
        erc721TokenAddress = IERC721(_erc721TokenAddress);
        nftTokenId = _nftTokenId;
        reservePrice = _reservePrice;
        numBlocksAuctionOpen = _numBlocksAuctionOpen;
        offerPriceDecrement = _offerPriceDecrement;
        initialPrice = reservePrice + numBlocksAuctionOpen*offerPriceDecrement;
        startsAt = block.number;
        auctionEndBlock = block.number + numBlocksAuctionOpen;
        currentPrice = initialPrice;
        owner = payable(erc721TokenAddress.ownerOf(_nftTokenId));
 

        auctionEnded = false;
  

    }

    function bid() external payable returns (address) {

        require(auctionEnded == false, "Auction has ended");
        require(block.number < auctionEndBlock, "Auction has ended");
        updatePrice();
        require(msg.value >= currentPrice, "Bid is lower than current price");
        require(winner == address(0), "Auction has already been won");
        winner = msg.sender;
        owner.transfer(msg.value);
        erc721TokenAddress.transferFrom(owner, winner, nftTokenId);
        auctionEnded = true;
        winBid = msg.value;
        return winner;
        
    }


    function updatePrice() internal {
        if (block.number >= auctionEndBlock) {
            auctionEnded = true;
            return;
        }
        currentPrice = initialPrice - (offerPriceDecrement * (block.number - startsAt));
    }
}
