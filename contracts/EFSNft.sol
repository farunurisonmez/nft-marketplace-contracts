// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v5.0/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v5.0/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v5.0/contracts/utils/Context.sol";

contract EFSNft is Context, ERC721Enumerable  {
    string private _baseTokenURI;
    uint256 public MAX_SUPPLY;
    uint256 public PRICE;
    address payable owner;
    
    constructor(string memory name, string memory symbol, string memory baseTokenURI) ERC721(name, symbol) {
    owner = payable(msg.sender);
    MAX_SUPPLY = 20000;
    PRICE = 100000000000000000;
    _baseTokenURI = baseTokenURI; // Store the base token URI
    }
}