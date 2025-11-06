
// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

pragma solidity ^0.8.20;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC20/IERC20.sol)

pragma solidity >=0.4.16;

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
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
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
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
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: @openzeppelin/contracts/interfaces/IERC20.sol


// OpenZeppelin Contracts (last updated v5.4.0) (interfaces/IERC20.sol)

pragma solidity >=0.4.16;


// File: @openzeppelin/contracts/utils/introspection/IERC165.sol


// OpenZeppelin Contracts (last updated v5.4.0) (utils/introspection/IERC165.sol)

pragma solidity >=0.4.16;

/**
 * @dev Interface of the ERC-165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[ERC].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[ERC section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/interfaces/IERC165.sol


// OpenZeppelin Contracts (last updated v5.4.0) (interfaces/IERC165.sol)

pragma solidity >=0.4.16;


// File: @openzeppelin/contracts/interfaces/IERC1363.sol


// OpenZeppelin Contracts (last updated v5.4.0) (interfaces/IERC1363.sol)

pragma solidity >=0.6.2;



/**
 * @title IERC1363
 * @dev Interface of the ERC-1363 standard as defined in the https://eips.ethereum.org/EIPS/eip-1363[ERC-1363].
 *
 * Defines an extension interface for ERC-20 tokens that supports executing code on a recipient contract
 * after `transfer` or `transferFrom`, or code on a spender contract after `approve`, in a single transaction.
 */
interface IERC1363 is IERC20, IERC165 {
    /*
     * Note: the ERC-165 identifier for this interface is 0xb0202a11.
     * 0xb0202a11 ===
     *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
     *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
     *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
     *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)')) ^
     *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
     *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
     */

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferAndCall(address to, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @param data Additional data with no specified format, sent in call to `to`.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the allowance mechanism
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param from The address which you want to send tokens from.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferFromAndCall(address from, address to, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the allowance mechanism
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param from The address which you want to send tokens from.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @param data Additional data with no specified format, sent in call to `to`.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens and then calls {IERC1363Spender-onApprovalReceived} on `spender`.
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function approveAndCall(address spender, uint256 value) external returns (bool);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens and then calls {IERC1363Spender-onApprovalReceived} on `spender`.
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     * @param data Additional data with no specified format, sent in call to `spender`.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol


// OpenZeppelin Contracts (last updated v5.3.0) (token/ERC20/utils/SafeERC20.sol)

pragma solidity ^0.8.20;



/**
 * @title SafeERC20
 * @dev Wrappers around ERC-20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    /**
     * @dev An operation with an ERC-20 token failed.
     */
    error SafeERC20FailedOperation(address token);

    /**
     * @dev Indicates a failed `decreaseAllowance` request.
     */
    error SafeERC20FailedDecreaseAllowance(address spender, uint256 currentAllowance, uint256 requestedDecrease);

    /**
     * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeCall(token.transfer, (to, value)));
    }

    /**
     * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
     * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
     */
    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeCall(token.transferFrom, (from, to, value)));
    }

    /**
     * @dev Variant of {safeTransfer} that returns a bool instead of reverting if the operation is not successful.
     */
    function trySafeTransfer(IERC20 token, address to, uint256 value) internal returns (bool) {
        return _callOptionalReturnBool(token, abi.encodeCall(token.transfer, (to, value)));
    }

    /**
     * @dev Variant of {safeTransferFrom} that returns a bool instead of reverting if the operation is not successful.
     */
    function trySafeTransferFrom(IERC20 token, address from, address to, uint256 value) internal returns (bool) {
        return _callOptionalReturnBool(token, abi.encodeCall(token.transferFrom, (from, to, value)));
    }

    /**
     * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     *
     * IMPORTANT: If the token implements ERC-7674 (ERC-20 with temporary allowance), and if the "client"
     * smart contract uses ERC-7674 to set temporary allowances, then the "client" smart contract should avoid using
     * this function. Performing a {safeIncreaseAllowance} or {safeDecreaseAllowance} operation on a token contract
     * that has a non-zero temporary allowance (for that particular owner-spender) will result in unexpected behavior.
     */
    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 oldAllowance = token.allowance(address(this), spender);
        forceApprove(token, spender, oldAllowance + value);
    }

    /**
     * @dev Decrease the calling contract's allowance toward `spender` by `requestedDecrease`. If `token` returns no
     * value, non-reverting calls are assumed to be successful.
     *
     * IMPORTANT: If the token implements ERC-7674 (ERC-20 with temporary allowance), and if the "client"
     * smart contract uses ERC-7674 to set temporary allowances, then the "client" smart contract should avoid using
     * this function. Performing a {safeIncreaseAllowance} or {safeDecreaseAllowance} operation on a token contract
     * that has a non-zero temporary allowance (for that particular owner-spender) will result in unexpected behavior.
     */
    function safeDecreaseAllowance(IERC20 token, address spender, uint256 requestedDecrease) internal {
        unchecked {
            uint256 currentAllowance = token.allowance(address(this), spender);
            if (currentAllowance < requestedDecrease) {
                revert SafeERC20FailedDecreaseAllowance(spender, currentAllowance, requestedDecrease);
            }
            forceApprove(token, spender, currentAllowance - requestedDecrease);
        }
    }

    /**
     * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful. Meant to be used with tokens that require the approval
     * to be set to zero before setting it to a non-zero value, such as USDT.
     *
     * NOTE: If the token implements ERC-7674, this function will not modify any temporary allowance. This function
     * only sets the "standard" allowance. Any temporary allowance will remain active, in addition to the value being
     * set here.
     */
    function forceApprove(IERC20 token, address spender, uint256 value) internal {
        bytes memory approvalCall = abi.encodeCall(token.approve, (spender, value));

        if (!_callOptionalReturnBool(token, approvalCall)) {
            _callOptionalReturn(token, abi.encodeCall(token.approve, (spender, 0)));
            _callOptionalReturn(token, approvalCall);
        }
    }

    /**
     * @dev Performs an {ERC1363} transferAndCall, with a fallback to the simple {ERC20} transfer if the target has no
     * code. This can be used to implement an {ERC721}-like safe transfer that rely on {ERC1363} checks when
     * targeting contracts.
     *
     * Reverts if the returned value is other than `true`.
     */
    function transferAndCallRelaxed(IERC1363 token, address to, uint256 value, bytes memory data) internal {
        if (to.code.length == 0) {
            safeTransfer(token, to, value);
        } else if (!token.transferAndCall(to, value, data)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Performs an {ERC1363} transferFromAndCall, with a fallback to the simple {ERC20} transferFrom if the target
     * has no code. This can be used to implement an {ERC721}-like safe transfer that rely on {ERC1363} checks when
     * targeting contracts.
     *
     * Reverts if the returned value is other than `true`.
     */
    function transferFromAndCallRelaxed(
        IERC1363 token,
        address from,
        address to,
        uint256 value,
        bytes memory data
    ) internal {
        if (to.code.length == 0) {
            safeTransferFrom(token, from, to, value);
        } else if (!token.transferFromAndCall(from, to, value, data)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Performs an {ERC1363} approveAndCall, with a fallback to the simple {ERC20} approve if the target has no
     * code. This can be used to implement an {ERC721}-like safe transfer that rely on {ERC1363} checks when
     * targeting contracts.
     *
     * NOTE: When the recipient address (`to`) has no code (i.e. is an EOA), this function behaves as {forceApprove}.
     * Opposedly, when the recipient address (`to`) has code, this function only attempts to call {ERC1363-approveAndCall}
     * once without retrying, and relies on the returned value to be true.
     *
     * Reverts if the returned value is other than `true`.
     */
    function approveAndCallRelaxed(IERC1363 token, address to, uint256 value, bytes memory data) internal {
        if (to.code.length == 0) {
            forceApprove(token, to, value);
        } else if (!token.approveAndCall(to, value, data)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     *
     * This is a variant of {_callOptionalReturnBool} that reverts if call fails to meet the requirements.
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        uint256 returnSize;
        uint256 returnValue;
        assembly ("memory-safe") {
            let success := call(gas(), token, 0, add(data, 0x20), mload(data), 0, 0x20)
            // bubble errors
            if iszero(success) {
                let ptr := mload(0x40)
                returndatacopy(ptr, 0, returndatasize())
                revert(ptr, returndatasize())
            }
            returnSize := returndatasize()
            returnValue := mload(0)
        }

        if (returnSize == 0 ? address(token).code.length == 0 : returnValue != 1) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     *
     * This is a variant of {_callOptionalReturn} that silently catches all reverts and returns a bool instead.
     */
    function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns (bool) {
        bool success;
        uint256 returnSize;
        uint256 returnValue;
        assembly ("memory-safe") {
            success := call(gas(), token, 0, add(data, 0x20), mload(data), 0, 0x20)
            returnSize := returndatasize()
            returnValue := mload(0)
        }
        return success && (returnSize == 0 ? address(token).code.length > 0 : returnValue == 1);
    }
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity >=0.6.2;


/**
 * @dev Interface for the optional metadata functions from the ERC-20 standard.
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol


pragma solidity ^0.8.0;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

// File: contracts/KipuBankV2.sol


pragma solidity ^0.8.24;

/**
 * @title KipuBankV2
 * @author N.K.G.G.
 * @notice Final project for ETH Kipu — Module 3 (Upgraded Bank/Vault)
 * @dev Beginner-friendly implementation where I focus on:
 *      - ETH and ERC-20 deposits/withdrawals (multi-token vault)
 *      - Simple admin using Ownable (just one owner for now)
 *      - Caps: global (bank cap) and per-tx withdraw cap, per token
 *      - Chainlink ETH/USD oracle to enforce a USD cap for ETH TVL
 *      - CEI (Checks-Effects-Interactions) and SafeERC20 usage
 *      - Custom errors and events for clear testing on Etherscan
 *
 * Learning notes:
 * - I wrote comments to help myself (and reviewers) follow each step.
 * - I kept roles simple (only owner) to avoid complexity as a beginner.
 * - address(0) represents native ETH inside mappings and events.
 */





contract KipuBankV2 is Ownable {
    using SafeERC20 for IERC20;

    // ---------------------- Constants & Types ----------------------

    /// @dev I use the zero-address to represent the native token (ETH) in mappings.
    address public constant NATIVE = address(0);

    /// @dev Most Chainlink ETH/USD feeds return 8 decimals (I keep this constant for clarity).
    uint8 public constant ORACLE_DECIMALS = 8;

    // ---------------------- Custom Errors (gas-cheaper than strings) ----------------------

    error ZeroAmount(); // amount must be > 0
    error InvalidToken(address token); // e.g., using address(0) in token funcs
    error InsufficientBalance(address token, uint256 requested, uint256 available);
    error WithdrawLimitExceeded(address token, uint256 requested, uint256 limit);
    error BankCapReached(address token, uint256 attempted, uint256 cap); // exceeds global cap
    error NativeTransferFailed(address to, uint256 amount); // low-level call failed
    error OracleUnavailable(); // price feed not returning a valid price

    // ---------------------- Storage: balances and caps ----------------------

    /**
     * @notice Nested balances: user -> token -> amount.
     * @dev For ETH, token = address(0). For ERC20, token = token address.
     */
    mapping(address => mapping(address => uint256)) private balances;

    /// @notice Global TVL per token inside the contract (sum of all users).
    mapping(address => uint256) public totalDepositedPerToken;

    /// @notice Global deposit cap per token (0 = no cap).
    mapping(address => uint256) public bankCapPerToken;

    /// @notice Withdraw cap per tx per token (0 = no cap).
    mapping(address => uint256) public withdrawCapPerToken;

    /**
     * @notice USD cap (8 decimals) for ETH TVL (optional).
     * @dev Example: 100 USD cap = 100 * 1e8. If 0, this check is disabled.
     */
    uint256 public bankCapUsdETH;

    /// @notice Chainlink ETH/USD price feed (Sepolia example: 0x694A...5306).
    AggregatorV3Interface public priceFeed;

    // ---------------------- Events (to see actions in Etherscan) ----------------------

    event Deposited(address indexed user, address indexed token, uint256 amount);
    event Withdrawn(address indexed user, address indexed token, uint256 amount);

    event CapsUpdated(address indexed token, uint256 bankCap, uint256 withdrawCap);
    event OracleUpdated(address indexed oracle);
    event BankCapUsdEthUpdated(uint256 newCapUsd8d);

    // ---------------------- Constructor ----------------------

    /**
     * @param _oracle Chainlink ETH/USD aggregator address (8 decimals usually)
     * @param _bankCapUsdETH USD cap for ETH TVL (8 decimals). 0 = disabled.
     * @param _initialEthBankCap Global cap for ETH in wei (0 = disabled).
     * @param _initialEthWithdrawCap Per-tx withdraw cap for ETH in wei (0 = disabled).
     *
     * I keep the owner model simple (Ownable). Only the owner can change caps/oracle.
     */
    constructor(
        address _oracle,
        uint256 _bankCapUsdETH,
        uint256 _initialEthBankCap,
        uint256 _initialEthWithdrawCap
    ) Ownable(msg.sender) {
        priceFeed = AggregatorV3Interface(_oracle);
        bankCapUsdETH = _bankCapUsdETH;

        if (_initialEthBankCap > 0) bankCapPerToken[NATIVE] = _initialEthBankCap;
        if (_initialEthWithdrawCap > 0) withdrawCapPerToken[NATIVE] = _initialEthWithdrawCap;

        emit OracleUpdated(_oracle);
        emit BankCapUsdEthUpdated(_bankCapUsdETH);
        emit CapsUpdated(NATIVE, bankCapPerToken[NATIVE], withdrawCapPerToken[NATIVE]);
    }

    // ---------------------- Views (read-only helpers) ----------------------

    /**
     * @notice See any user balance for a given token.
     * @param user Address to query (can be msg.sender or someone else).
     * @param token address(0) for ETH; ERC-20 address for tokens.
     */
    function viewBalance(address user, address token) external view returns (uint256) {
        return balances[user][token];
    }

    /**
     * @notice Latest ETH/USD price (8 decimals). Reverts if not available.
     * @dev I use this to compute a USD-based cap for ETH TVL.
     */
    function getETHPriceUSD_8d() public view returns (uint256) {
        (, int256 price,, uint256 updatedAt, ) = priceFeed.latestRoundData();
        if (price <= 0 || updatedAt == 0) revert OracleUnavailable();
        return uint256(price);
    }

    /**
     * @notice Normalize amounts across different token decimals.
     * @dev Example: from 18 (ETH/DAI) to 6 (USDC). Handy for accounting if needed.
     */
    function normalizeDecimals(
        uint256 amount,
        uint8 fromDecimals,
        uint8 toDecimals
    ) public pure returns (uint256) {
        if (fromDecimals == toDecimals) return amount;
        if (fromDecimals > toDecimals) {
            return amount / 10 ** (fromDecimals - toDecimals);
        } else {
            return amount * 10 ** (toDecimals - fromDecimals);
        }
    }

    // ---------------------- ETH (native) deposit/withdraw ----------------------

    /**
     * @notice Deposit native ETH into your vault.
     * @dev CEI: 1) checks caps, 2) update storage, 3) emit event.
     *      Also enforces optional ETH TVL cap in USD using Chainlink.
     */
    function depositETH() external payable {
        uint256 amount = msg.value;
        if (amount == 0) revert ZeroAmount();

        // 1) CHECKS — per-token native cap (in wei), if set
        uint256 ethCapWei = bankCapPerToken[NATIVE];
        if (ethCapWei > 0) {
            uint256 newTotal = totalDepositedPerToken[NATIVE] + amount;
            if (newTotal > ethCapWei) revert BankCapReached(NATIVE, newTotal, ethCapWei);
        }

        // 2) CHECKS — USD cap for ETH TVL (if enabled)
        if (bankCapUsdETH > 0) {
            uint256 price8d = getETHPriceUSD_8d();                 // USD * 1e8
            uint256 currentUsd8d = (totalDepositedPerToken[NATIVE] * price8d) / 1e18;
            uint256 incomingUsd8d = (amount * price8d) / 1e18;
            if (currentUsd8d + incomingUsd8d > bankCapUsdETH) {
                revert BankCapReached(NATIVE, currentUsd8d + incomingUsd8d, bankCapUsdETH);
            }
        }

        // 3) EFFECTS
        balances[msg.sender][NATIVE] += amount;
        totalDepositedPerToken[NATIVE] += amount;

        // 4) INTERACTION (only event here)
        emit Deposited(msg.sender, NATIVE, amount);
    }

    /**
     * @notice Withdraw native ETH from your vault.
     * @dev CEI: validate caps and balance, update storage, then transfer ETH.
     */
    function withdrawETH(uint256 amount) external {
        if (amount == 0) revert ZeroAmount();

        uint256 cap = withdrawCapPerToken[NATIVE];
        if (cap > 0 && amount > cap) revert WithdrawLimitExceeded(NATIVE, amount, cap);

        uint256 bal = balances[msg.sender][NATIVE];
        if (bal < amount) revert InsufficientBalance(NATIVE, amount, bal);

        // EFFECTS
        balances[msg.sender][NATIVE] = bal - amount;
        totalDepositedPerToken[NATIVE] -= amount;

        // INTERACTION — low-level call wrapped in helper + event
        _safeTransferETH(msg.sender, amount);
        emit Withdrawn(msg.sender, NATIVE, amount);
    }

    /**
     * @notice Receive ETH sent directly (no data). I treat it as a deposit.
     * @dev I replicate the same cap checks as depositETH() to keep behavior consistent.
     */
    receive() external payable {
        uint256 amount = msg.value;
        if (amount == 0) revert ZeroAmount();

        uint256 ethCapWei = bankCapPerToken[NATIVE];
        if (ethCapWei > 0) {
            uint256 newTotal = totalDepositedPerToken[NATIVE] + amount;
            if (newTotal > ethCapWei) revert BankCapReached(NATIVE, newTotal, ethCapWei);
        }
        if (bankCapUsdETH > 0) {
            uint256 price8d = getETHPriceUSD_8d();
            uint256 currentUsd8d = (totalDepositedPerToken[NATIVE] * price8d) / 1e18;
            uint256 incomingUsd8d = (amount * price8d) / 1e18;
            if (currentUsd8d + incomingUsd8d > bankCapUsdETH) {
                revert BankCapReached(NATIVE, currentUsd8d + incomingUsd8d, bankCapUsdETH);
            }
        }

        balances[msg.sender][NATIVE] += amount;
        totalDepositedPerToken[NATIVE] += amount;
        emit Deposited(msg.sender, NATIVE, amount);
    }

    // ---------------------- ERC-20 deposit/withdraw ----------------------

    /**
     * @notice Deposit an ERC-20 token (after approving this contract).
     * @dev I enforce bank cap per token (if configured). SafeERC20 handles non-standard tokens.
     */
    function depositToken(address token, uint256 amount) external {
        if (token == NATIVE) revert InvalidToken(token);
        if (amount == 0) revert ZeroAmount();

        uint256 cap = bankCapPerToken[token];
        if (cap > 0) {
            uint256 newTotal = totalDepositedPerToken[token] + amount;
            if (newTotal > cap) revert BankCapReached(token, newTotal, cap);
        }

        // CEI: transfer first? I prefer updating after transferFrom succeeds (safer if it reverts).
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);

        balances[msg.sender][token] += amount;
        totalDepositedPerToken[token] += amount;

        emit Deposited(msg.sender, token, amount);
    }

    /**
     * @notice Withdraw an ERC-20 token you deposited.
     * @dev Enforces per-tx withdraw cap if set and checks your balance.
     */
    function withdrawToken(address token, uint256 amount) external {
        if (token == NATIVE) revert InvalidToken(token);
        if (amount == 0) revert ZeroAmount();

        uint256 cap = withdrawCapPerToken[token];
        if (cap > 0 && amount > cap) revert WithdrawLimitExceeded(token, amount, cap);

        uint256 bal = balances[msg.sender][token];
        if (bal < amount) revert InsufficientBalance(token, amount, bal);

        // EFFECTS
        balances[msg.sender][token] = bal - amount;
        totalDepositedPerToken[token] -= amount;

        // INTERACTION
        IERC20(token).safeTransfer(msg.sender, amount);
        emit Withdrawn(msg.sender, token, amount);
    }

    // ---------------------- Owner (admin) configuration ----------------------

    /**
     * @notice Set global bank cap and per-tx withdraw cap for a token (token=address(0) is ETH).
     * @dev Only owner (bank admin) can call this.
     */
    function setCapsForToken(address token, uint256 bankCap, uint256 withdrawCap) external onlyOwner {
        bankCapPerToken[token] = bankCap;
        withdrawCapPerToken[token] = withdrawCap;
        emit CapsUpdated(token, bankCap, withdrawCap);
    }

    /**
     * @notice Update the Chainlink oracle (in case of feed migration).
     */
    function setOracle(address newOracle) external onlyOwner {
        if (newOracle == address(0)) revert InvalidToken(newOracle);
        priceFeed = AggregatorV3Interface(newOracle);
        emit OracleUpdated(newOracle);
    }

    /**
     * @notice Set or update the USD cap (8 decimals) for ETH TVL. 0 disables it.
     */
    function setBankCapUsdETH(uint256 newCapUsd8d) external onlyOwner {
        bankCapUsdETH = newCapUsd8d;
        emit BankCapUsdEthUpdated(newCapUsd8d);
    }

    /**
     * @notice Rescue ERC-20 tokens accidentally sent (admin only).
     * @dev This is not meant to withdraw user balances; use with caution.
     */
    function rescueERC20(address token, uint256 amount, address to) external onlyOwner {
        IERC20(token).safeTransfer(to, amount);
    }

    /**
     * @notice Rescue native ETH accidentally sent (admin only).
     */
    function rescueETH(uint256 amount, address to) external onlyOwner {
        _safeTransferETH(to, amount);
    }

    // ---------------------- Internal helper ----------------------

    /// @dev Private ETH transfer helper using low-level call (more reliable than transfer()).
    function _safeTransferETH(address to, uint256 amount) private {
        (bool ok, ) = payable(to).call{value: amount}("");
        if (!ok) revert NativeTransferFailed(to, amount);
    }
}
