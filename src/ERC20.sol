// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

error NullAddress();
error InsufficientAllowance(uint256 allowance, uint256 balance);
error InsufficientBalance(uint256 balance, uint256 transferAmount);
contract ERC20 is IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private constant _totalSupply = 1_000_000_000 * 1e6 wei;

    string private constant _name = "TEST ERC20";
    string private constant _symbol = "ERC20";

    uint256 private constant _decimals = 6;

    address private _owner;

    constructor() {
        _owner = msg.sender;
        _balances[msg.sender] = _totalSupply / 2;
        _balances[address(this)] = _totalSupply / 2;
        emit Transfer(address(0), msg.sender, _totalSupply / 2);
        emit Transfer(address(0), address(this), _totalSupply / 2);
    }

    function getOwner() public view returns (address) {
        return _owner;
    }

    function decimals() external pure returns (uint256) {
        return _decimals;
    }

    function symbol() external pure returns (string memory) {
        return _symbol;
    }

    function name() external pure returns (string memory) {
        return _name;
    }

    function totalSupply() external pure returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender)
        external
        view
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        uint256 currentAllowance = _allowances[sender][msg.sender];
        if (currentAllowance < amount) {
            revert InsufficientAllowance(currentAllowance, amount);
        }
        _transfer(sender, recipient, amount);
        unchecked {
            _allowances[sender][msg.sender] = currentAllowance - amount;
        }
        return true;
    }

    function transfer(address recipient, uint256 amount)
        external
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        if (sender == address(0) || recipient == address(0)) {
            revert NullAddress();
        }

        uint256 balance = _balances[sender];
        if (balance < amount) {
            revert InsufficientBalance(balance, amount);
        }

        unchecked {
            _balances[sender] = balance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function withdraw(uint256 amount) external {
        assert(msg.sender == _owner);
        _transfer(address(this), _owner, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        if (owner == address(0) || spender == address(0)) {
            revert NullAddress();
        }
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function sendToMutiUser(address[] memory input, uint256 amount) external {
        if (_balances[msg.sender] < input.length * amount) {
            revert InsufficientBalance(_balances[msg.sender], input.length * amount);
        }
        
        for (uint256 i = 0; i < input.length; i++) {
            _transfer(msg.sender, input[i], amount);
        }
    }

    function claim() external {
        _transfer(address(this), msg.sender, 500_000 * 1e6);
    }
}