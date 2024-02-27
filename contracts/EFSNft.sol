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

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    mapping(uint256 => uint256) private tokens;

    function getIds(uint256 token) public view returns (uint256){
        return tokens[token];
    }


    function mint(address to, uint256 tokenId, string memory tokenURI) public payable {
        require(msg.sender != owner, "You cannot mint your own item.");
        require(msg.value >= PRICE, "Not enough paid");
        owner.transfer(msg.value);
         _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        tokens[tokenId] = tokenId;
    }

    mapping(uint256 => string) private _tokenURIs;

    function _setTokenURI(uint256 tokenId, string memory uri) private {
        _tokenURIs[tokenId] = uri;
    }
}