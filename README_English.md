# 🏦 KipuBankV2

### Overview
**KipuBankV2** is a smart contract developed as part of **ETH Kipu – Module 3**.  
It implements a **multi-asset vault/bank** that allows deposits and withdrawals of **ETH and ERC-20 tokens**, with both per-token and global USD limits enforced through a **Chainlink oracle**.

This version includes improved access control, global and per-transaction caps, and a USD cap linked to the ETH/USD oracle price feed.

---

## 🔐 Access Control
- Uses OpenZeppelin’s **Ownable** contract.  
- Only the **owner (deployer)** can modify:
  - The Chainlink oracle address.
  - The USD cap and per-token caps.

---

## 🧩 Dependencies
- `@openzeppelin/contracts/access/Ownable.sol`
- `@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol`
- `@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol`

---

## ⚙️ Key Variables

| Variable | Description |
|-----------|-------------|
| `NATIVE` | Represents ETH using `address(0)`. |
| `balances` | Nested mapping of user → token → balance. |
| `totalDepositedPerToken` | Tracks total deposits per token. |
| `bankCapPerToken` | Global cap per token. |
| `withdrawCapPerToken` | Withdrawal cap per transaction. |
| `bankCapUsdETH` | Global USD cap for ETH (8 decimals). |
| `priceFeed` | Chainlink ETH/USD price oracle. |

---

## 🧠 Constructor Parameters

```solidity
constructor(
    address _oracle,
    uint256 _bankCapUsdETH,
    uint256 _initialEthBankCap,
    uint256 _initialEthWithdrawCap
)

| Parameter                | Value used on Sepolia                        |
| ------------------------ | -------------------------------------------- |
| `_oracle`                | `0x694AA1769357215DE4FAC081bf1f309aDC325306` |
| `_bankCapUsdETH`         | `0`                                          |
| `_initialEthBankCap`     | `1550000000000000000` (1.55 ETH)             |
| `_initialEthWithdrawCap` | `20000000000000000` (0.02 ETH)               |


💡 Main Functions

| Function                                                               | Description                                       |
| ---------------------------------------------------------------------- | ------------------------------------------------- |
| `depositETH()`                                                         | Allows ETH deposits (`msg.value`).                |
| `withdrawETH(uint256 amount)`                                          | Withdraws ETH if limits are met.                  |
| `depositToken(address token, uint256 amount)`                          | Deposits ERC-20 tokens (after approval).          |
| `withdrawToken(address token, uint256 amount)`                         | Withdraws ERC-20 tokens.                          |
| `viewBalance(address user, address token)`                             | Returns the user’s balance by token.              |
| `getETHPriceUSD_8d()`                                                  | Returns the ETH/USD price (8 decimals).           |
| `setCapsForToken(address token, uint256 bankCap, uint256 withdrawCap)` | Updates token caps.                               |
| `setBankCapUsdETH(uint256 newCapUsd8d)`                                | Updates global USD cap.                           |
| `setOracle(address newOracle)`                                         | Updates the Chainlink oracle address.             |
| `rescueERC20(address token, uint256 amount, address to)`               | Allows admin to recover tokens accidentally sent. |
| `rescueETH(uint256 amount, address to)`                                | Allows admin to recover ETH accidentally sent.    |


🧩 Design Decisions (Trade-offs)

ETH handled as address(0) for unified logic.

SafeERC20 ensures safer ERC-20 transfers.

CEI (Checks–Effects–Interactions) pattern applied throughout.

Custom errors improve gas efficiency and debugging clarity.

Simple Ownable structure used instead of complex role management for beginner clarity.

🧪 Test Summary (Sepolia)
🧱 ETH — Native Token
| Test                     | Action                       | Result                |
| ------------------------ | ---------------------------- | --------------------- |
| Deposit ETH              | `depositETH()` with 0.02 ETH | ✅ Success             |
| Withdraw ETH             | `withdrawETH(0.0003 ETH)`    | ✅ Success             |
| Revert Exceeding USD Cap | Attempt > cap                | ⚠️ Correctly reverted |
| Total ETH Deposited      | `400000000000000005` wei     | ✅ Matches expected    |


USD Oracle Value:
getETHPriceUSD_8d() → 325670622552 ≈ $3,256.70 per ETH


💰 ERC-20 Tokens — Mock DAI and Mock USDC

🪙 MockDAI

| Step              | Function                                   | Value / Result        |
| ----------------- | ------------------------------------------ | --------------------- |
| Deployment        | `MockDAI.sol`                              | ✅ Successful          |
| Minting           | `mint(user, 200000000000000000)` (0.2 DAI) | ✅ Success             |
| Approval          | `approve(KipuBankV2, 200000000000000000)`  | ✅ Success             |
| Deposit           | `depositToken(MockDAI, 10000000000000000)` | ✅ Success             |
| View Balance      | `viewBalance(user, MockDAI)`               | `10000000000000000`   |
| Withdraw          | `withdrawToken(MockDAI, 5000000000000000)` | ✅ Success             |
| Revert Exceed Cap | Attempt > withdrawCap                      | ⚠️ Correctly reverted |

Final DAI Balance in Vault:
5000000000000000 (0.005 DAI remaining)


🪙 MockUSDC

| Step              | Function                                            | Value / Result        |
| ----------------- | --------------------------------------------------- | --------------------- |
| Deployment        | `MockUSDC.sol`                                      | ✅ Successful          |
| Minting           | `mint(user, 3000000)` (3 USDC, assuming 6 decimals) | ✅ Success             |
| Approval          | `approve(KipuBankV2, 3000000)`                      | ✅ Success             |
| Deposit           | `depositToken(MockUSDC, 1000000)`                   | ✅ Success             |
| View Balance      | `viewBalance(user, MockUSDC)`                       | `1000000`             |
| Withdraw          | `withdrawToken(MockUSDC, 500000)`                   | ✅ Success             |
| Revert Exceed Cap | Attempt > withdrawCap                               | ⚠️ Correctly reverted |

Final USDC Balance in Vault:
500000 (0.5 USDC remaining)

📉 Oracle Integration

Chainlink ETH/USD Oracle (Sepolia):
0x694AA1769357215DE4FAC081bf1f309aDC325306

Returned price (8 decimals): 325670622552

Verified correct conversion for ETH/USD cap in all deposit operations.


📊 Final Contract State (Sepolia Verified)

| Field               | Value                                        |
| ------------------- | -------------------------------------------- |
| Owner               | `0xeFCD678F3E8Ba831787b6eb41ea8A618674B1d8`  |
| Oracle              | `0x694AA1769357215DE4FAC081bf1f309aDC325306` |
| Bank Cap (ETH)      | `1550000000000000000` (1.55 ETH)             |
| Withdraw Cap        | `20000000000000000` (0.02 ETH)               |
| USD Cap             | `100000000000` ($1,000, 8 decimals)          |
| Total ETH Deposited | `400000000000000005`                         |
| Tokens Tested       | `MockDAI`, `MockUSDC`                        |
| Network             | Sepolia Testnet                              |

🚀 Deployment & Verification Steps
🧩 Compile

Solidity version: 0.8.24

EVM: Shanghai

Optimizer: ON (200 runs)

🧱 Deploy to Sepolia
| Parameter                | Example Value                                |
| ------------------------ | -------------------------------------------- |
| `_oracle`                | `0x694AA1769357215DE4FAC081bf1f309aDC325306` |
| `_bankCapUsdETH`         | `0`                                          |
| `_initialEthBankCap`     | `1550000000000000000`                        |
| `_initialEthWithdrawCap` | `20000000000000000`                          |


🔍 Verify on Etherscan

Contract: KipuBankV2_flattened.sol

License: MIT

Compiler: Solidity 0.8.24

Constructor arguments: same as deployment above.


🌐 Contract Addresses

| Contract                        | Address                                       |
| ------------------------------- | --------------------------------------------- |
| **KipuBankV2 (Sepolia)**        | `0x259F2AcE582C19436268f4dE17B09a0EE92C6E8`   |
| **Chainlink ETH/USD (Sepolia)** | `0x694AA1769357215DE4FAC081bf1f309aDC325306`  |
| **MockDAI**                     | `0x9ad21efa0611d2e2e6d3c803660755bda2d95000`  |
| **MockUSDC**                    | `0x09ad21efa0611d2e2e6d3c803660755bda2d95000` |

📜 License

This project is licensed under the MIT License.

👩‍💻 Author

Developed by N.K.G.G. (Nidia Karina Garzón Grajales)
ETH Kipu – Module 3: Smart Contracts (Final Project)