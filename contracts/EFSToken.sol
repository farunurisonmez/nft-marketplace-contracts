// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import necessary modules from OpenZeppelin contracts
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v5.0/contracts/access/AccessControl.sol";

// Define the EFSToken contract, inheriting from AccessControl
  contract EFSToken is AccessControl {
    
    // Define constants for the MINTER_ROLE and BURNER_ROLE
    event SpenderAdded(address indexed account);
    event SpenderRemoved(address indexed account);
    
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    // Constructor to grant the DEFAULT_ADMIN_ROLE to the deploying address
    constructor() {
        grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // Modifier to restrict functions to onlySpender
    modifier onlySpender(){
      require(isSpender(msg.sender));
      _;
    }

    // Function to check if an address is a spender
    function isSpender(address account) public view returns (bool){
        return hasRole(MINTER_ROLE, account);
    }

    // Internal function to add a spender and grant the BURNER_ROLE
    function _addSpender(address account) internal {
        grantRole(BURNER_ROLE, account);
        emit SpenderAdded(account);
    }
  }
