// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import necessary modules from OpenZeppelin contracts
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v5.0/contracts/access/AccessControl.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.1.0/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v5.0/contracts/utils/Context.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v5.0/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v5.0/contracts/access/Ownable.sol";

// Define the EFSToken contract, inheriting from AccessControl
  contract EFSToken is Context, IERC20, AccessControl {
    using SafeMath for uint256;

    // Define constants for the MINTER_ROLE and BURNER_ROLE
    event SpenderAdded(address indexed account);
    event SpenderRemoved(address indexed account);
   
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    // Constructor to grant the DEFAULT_ADMIN_ROLE to the deploying address
    constructor(string memory name, string memory symbol) {
      _name = name;
      _symbol = symbol;
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

    function tokenName() public view returns (string memory) {
        return _name;
    }

    function tokenSymbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return 18; // Assuming 18 decimals, you can modify this if needed
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual  returns (bool) {
      _transfer(_msgSender(), recipient, amount);
      return true;
    }

    function allowance(address owner, address spender) public view virtual  returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual  returns (bool) {
      _approve(_msgSender(), spender, amount);
      return true;
    }

      function transferFrom(address sender, address recipient, uint256 amount) public virtual  returns (bool) {
        _transfer(sender, recipient, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

      function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

         function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

        function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }

  }