# 🏦 KipuBankV2

### Descripción general
**KipuBankV2** es un contrato inteligente desarrollado como parte del **Módulo 3** del programa ETH Kipu.  
El contrato implementa un **banco/vault descentralizado** que permite depósitos y retiros tanto en **ETH nativo** como en **tokens ERC20**, controlando límites por token y un límite global en USD mediante un **oráculo Chainlink**.

---

## 🔐 Control de acceso
- Uso de **Ownable (OpenZeppelin)**: solo el owner (deploy address) puede actualizar oráculo o límites.
- `msg.sender` del constructor se establece como `owner`.

---

## 🧩 Dependencias utilizadas
- `@openzeppelin/contracts/access/Ownable.sol`
- `@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol`
- `@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol`

---

## ⚙️ Variables clave

| Variable | Descripción |
|-----------|--------------|
| `NATIVE` | Representa ETH (`address(0)`) |
| `balances` | Mapeo anidado: usuario → token → balance |
| `totalDepositedPerToken` | Suma global por token |
| `bankCapPerToken` | Límite global por token |
| `withdrawCapPerToken` | Límite de retiro por transacción |
| `bankCapUsdETH` | Límite global en USD (8 decimales) |
| `priceFeed` | Oráculo ETH/USD de Chainlink |

---

## 🧠 Constructor y parámetros iniciales

```solidity
constructor(
    address _oracle,
    uint256 _bankCapUsdETH,
    uint256 _initialEthBankCap,
    uint256 _initialEthWithdrawCap
) Ownable(msg.sender)

Parámetros usados en el despliegue (Sepolia Testnet):

_oracle: 0x694AA1769357215DE4FAC081bf1f309aDC325306

_bankCapUsdETH: 0

_initialEthBankCap: 1550000000000000000 (≈ 1.55 ETH)

_initialEthWithdrawCap: 20000000000000000 (≈ 0.02 ETH)

| Función                                                                | Descripción                                          |
| ---------------------------------------------------------------------- | ---------------------------------------------------- |
| `depositETH()`                                                         | Deposita ETH (usa `msg.value`).                      |
| `withdrawETH(uint256 amount)`                                          | Retira ETH si cumple los límites.                    |
| `depositToken(address token, uint256 amount)`                          | Deposita tokens ERC20.                               |
| `withdrawToken(address token, uint256 amount)`                         | Retira tokens ERC20.                                 |
| `viewBalance(address user, address token)`                             | Consulta balance de usuario y token.                 |
| `getETHPriceUSD_8d()`                                                  | Devuelve precio ETH/USD con 8 decimales (Chainlink). |
| `setCapsForToken(address token, uint256 bankCap, uint256 withdrawCap)` | Define límites globales y por retiro.                |
| `setBankCapUsdETH(uint256 newCapUsd8d)`                                | Define el cap global en USD.                         |
| `setOracle(address newOracle)`                                         | Permite cambiar el oráculo Chainlink.                |

💡 Decisiones de diseño (Trade-offs)

Se utilizó SafeERC20 para evitar errores con tokens no estándar.

Se representa ETH con address(0) para unificar lógica con tokens ERC20.

Se priorizó la claridad y seguridad sobre la optimización extrema de gas.

Implementación de CEI (Checks–Effects–Interactions).

Uso de custom errors para mejorar la eficiencia y legibilidad.

🧪 Pruebas realizadas (Remix y Etherscan)
🧱 ETH:

Depósito: depositETH() con 0.02 ETH → ✅ exitoso.

Visualización: viewBalance() devolvió 400000000000000005 wei.

Retiro: withdrawETH(0.0003 ETH) → ✅ exitoso.

Reversión: al exceder bankCapUsdETH bajo, → revert correcto.

💰 Tokens (MockDAI):

Mint: 0.2 MockDAI → ✅ exitoso.

Approve: approve(KipuBankV2, 0.2 DAI) → ✅ exitoso.

Depósito: depositToken(MockDAI, 0.01 DAI) → ✅ exitoso.

Retiro: withdrawToken(MockDAI, 0.005 DAI) → ✅ exitoso.

📉 Cap USD (con oráculo)

Oráculo ETH/USD: getETHPriceUSD_8d() → 325670622552 (≈ $3,256.70/ETH).

Revert correcto al usar bankCapUsdETH = 30000000 ($0.30).

Depósito exitoso tras subir a 100000000000 ($1,000).

📊 Estado final del contrato (verificado en Sepolia)
Campo	Valor
Owner	0xeFCD678F3E8Ba831787b6eb41ea8A618674B1d8
Oráculo	0x694AA1769357215DE4FAC081bf1f309aDC325306
Cap global ETH	1550000000000000000 (1.55 ETH)
Cap retiro ETH	20000000000000000 (0.02 ETH)
Cap USD ETH	100000000000 ($1,000 con 8 decimales)
Total depositado ETH	400000000000000005
Token probado	MockDAI
🚀 Instrucciones de despliegue

Compilación:

Solidity versión: 0.8.24

EVM: Shanghai

Optimizer: ON (200 runs)

Despliegue en Sepolia:

_oracle → 0x694AA1769357215DE4FAC081bf1f309aDC325306

_bankCapUsdETH → 0

_initialEthBankCap → 1550000000000000000

_initialEthWithdrawCap → 20000000000000000

Verificación en Etherscan:

Flattened KipuBankV2_flattened.sol

License: MIT

Constructor arguments: mismos que arriba

Interacción:

Read/Write Contract o Remix

Para ETH usar Value en wei

Para tokens usar approve antes de depositar

🌐 Direcciones de despliegue

Contrato principal (Sepolia):
0x259F2AcE582C19436268f4dE17B09a0EE92C6E8

Oráculo Chainlink ETH/USD (Sepolia):
0x694AA1769357215DE4FAC081bf1f309aDC325306

MockDAI:
0x69A4A1769357215DE4FAC081bf1f309aDC325306 (contrato de prueba ERC20)

📜 Licencia

Este proyecto está bajo la licencia MIT.

🧾 Créditos

Desarrollado por N.K.G.G. (Nidia Karina Garzón Grajales)
Como entrega oficial del Módulo 3 — ETH Kipu: Smart Contracts.
Instituto: Soy Henry / ETH Kipu.


---

## 💡 Recomendación

This repository also includes an English version of the README: [README_ENGLISH.md](./README_ENGLISH.md)
