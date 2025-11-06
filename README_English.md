# 🏦 KipuBankV2

### Overview
**KipuBankV2** is a smart contract developed as part of **Module 3 – ETH Kipu**.  
It implements a **multi-asset vault/bank** that allows deposits and withdrawals of **ETH and ERC20 tokens**, with both per-token and global USD limits enforced via a **Chainlink oracle**.

---

## 🔐 Access Control
- Built with OpenZeppelin’s **Ownable** contract.
- Only the **owner (deployer)** can modify the oracle address or the deposit/withdrawal limits.

---

## 🧩 Dependencies
- `@openzeppelin/contracts/access/Ownable.sol`
- `@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol`
- `@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol`

---

## ⚙️ Key Variables

| Variable | Description |
|-----------|-------------|
| `NATIVE` | Represents ETH (`address(0)`). |
| `balances` | Nested mapping user → token → balance. |
| `totalDepositedPerToken` | Tracks total deposits per token. |
| `bankCapPerToken` | Global cap per token. |
| `withdrawCapPerToken` | Per-transaction withdrawal cap. |
| `bankCapUsdETH` | Global USD cap (8 decimals). |
| `priceFeed` | Chainlink ETH/USD oracle. |

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

| Function                                                               | Description                             |
| ---------------------------------------------------------------------- | --------------------------------------- |
| `depositETH()`                                                         | Allows ETH deposits (`msg.value`).      |
| `withdrawETH(uint256 amount)`                                          | Withdraws ETH if limits are met.        |
| `depositToken(address token, uint256 amount)`                          | Deposits ERC20 tokens.                  |
| `withdrawToken(address token, uint256 amount)`                         | Withdraws ERC20 tokens.                 |
| `viewBalance(address user, address token)`                             | Checks balance by user/token.           |
| `getETHPriceUSD_8d()`                                                  | Returns the ETH/USD price (8 decimals). |
| `setCapsForToken(address token, uint256 bankCap, uint256 withdrawCap)` | Sets per-token caps.                    |
| `setBankCapUsdETH(uint256 newCapUsd8d)`                                | Sets global USD cap.                    |
| `setOracle(address newOracle)`                                         | Updates oracle address.                 |

🧩 Design Decisions (Trade-offs)

SafeERC20 used for token safety.

ETH handled as address(0) for unified logic.

Clear code over gas optimization.

CEI (Checks–Effects–Interactions) pattern used.

Custom errors for clarity and efficiency.

🧪 Tests Summary
🧱 ETH

Deposit 0.02 ETH → ✅ success.

Withdraw 0.0003 ETH → ✅ success.

Revert on low USD cap → ✅ correct.

💰 Mock Tokens

Minted and deposited MockDAI (0.2 → 0.01).

Withdrawn 0.005 DAI → ✅ success.

📉 Oracle Integration

getETHPriceUSD_8d() returned 325670622552 (~$3,256.70/ETH).

bankCapUsdETH enforcement tested successfully.

📊 Final Contract State (Sepolia Verified)
Field	Value
Owner	0xeFCD678F3E8Ba831787b6eb41ea8A618674B1d8
Oracle	0x694AA1769357215DE4FAC081bf1f309aDC325306
Cap ETH	1550000000000000000 (1.55 ETH)
Withdraw Cap	20000000000000000 (0.02 ETH)
USD Cap	100000000000 ($1,000, 8 decimals)
Total ETH Deposited	400000000000000005
Token Tested	MockDAI
🚀 Deployment Instructions

Compile:

Solidity 0.8.24, EVM Shanghai, Optimizer ON (200 runs).

Deploy to Sepolia:

_oracle → 0x694AA1769357215DE4FAC081bf1f309aDC325306

_bankCapUsdETH → 0

_initialEthBankCap → 1550000000000000000

_initialEthWithdrawCap → 20000000000000000

Verify on Etherscan:

Flattened file KipuBankV2_flattened.sol

License: MIT

Constructor args: same as above

🌐 Addresses

KipuBankV2 (Sepolia): 0x259F2AcE582C19436268f4dE17B09a0EE92C6E8

Chainlink ETH/USD (Sepolia): 0x694AA1769357215DE4FAC081bf1f309aDC325306

MockDAI: 0x69A4A1769357215DE4FAC081bf1f309aDC325306

📜 License

This project is licensed under the MIT License.

👩‍💻 Author

Developed by N.K.G.G. (Nidia Karina Garzón Grajales)
ETH Kipu – Module 3: Smart Contracts