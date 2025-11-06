# 🏦 KipuBankV2

### Descripción general
**KipuBankV2** es un contrato inteligente desarrollado como parte del **Módulo 3 de ETH Kipu**.  
Implementa un **banco o bóveda multi-activo**, que permite depósitos y retiros de **ETH y tokens ERC-20**, con límites globales y por transacción, además de un límite en USD utilizando un **oráculo Chainlink**.

Esta versión mejora al contrato anterior al incluir:
- Soporte multi-token (ETH + ERC-20)
- Límites globales, por token y por transacción
- Límite global en USD según el precio ETH/USD de Chainlink
- Errores personalizados (`custom errors`)
- Patrón **CEI (Checks–Effects–Interactions)**
- Uso de **SafeERC20** para transferencias seguras
- Integración de **Ownable** para control administrativo

---

## 🔐 Control de acceso
- Usa **Ownable** de OpenZeppelin.
- Solo el **propietario (deployer)** puede modificar:
  - La dirección del oráculo Chainlink.
  - El límite global en USD.
  - Los límites de depósito y retiro por token.

---

## 🧩 Dependencias
- `@openzeppelin/contracts/access/Ownable.sol`
- `@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol`
- `@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol`

---

## ⚙️ Variables principales

| Variable | Descripción |
|-----------|-------------|
| `NATIVE` | Representa ETH usando `address(0)`. |
| `balances` | Mapping anidado: usuario → token → balance. |
| `totalDepositedPerToken` | Suma total de depósitos por token. |
| `bankCapPerToken` | Límite global por token (en wei o unidad mínima). |
| `withdrawCapPerToken` | Límite de retiro por transacción. |
| `bankCapUsdETH` | Límite global en USD para el TVL de ETH (8 decimales). |
| `priceFeed` | Oráculo Chainlink ETH/USD. |

---

## 🧠 Parámetros del constructor

```solidity
constructor(
    address _oracle,
    uint256 _bankCapUsdETH,
    uint256 _initialEthBankCap,
    uint256 _initialEthWithdrawCap
)

| Parámetro                | Valor (Sepolia)                              |
| ------------------------ | -------------------------------------------- |
| `_oracle`                | `0x694AA1769357215DE4FAC081bf1f309aDC325306` |
| `_bankCapUsdETH`         | `0`                                          |
| `_initialEthBankCap`     | `1550000000000000000` (1.55 ETH)             |
| `_initialEthWithdrawCap` | `20000000000000000` (0.02 ETH)               |

💡 Funciones principales
| Función                                                                | Descripción                                                   |
| ---------------------------------------------------------------------- | ------------------------------------------------------------- |
| `depositETH()`                                                         | Deposita ETH nativo en la bóveda.                             |
| `withdrawETH(uint256 amount)`                                          | Retira ETH respetando el límite por transacción.              |
| `depositToken(address token, uint256 amount)`                          | Deposita tokens ERC-20 (requiere aprobación previa).          |
| `withdrawToken(address token, uint256 amount)`                         | Retira tokens ERC-20.                                         |
| `viewBalance(address user, address token)`                             | Consulta el balance de un usuario.                            |
| `getETHPriceUSD_8d()`                                                  | Obtiene el precio ETH/USD desde Chainlink (8 decimales).      |
| `setCapsForToken(address token, uint256 bankCap, uint256 withdrawCap)` | Actualiza los límites por token.                              |
| `setBankCapUsdETH(uint256 newCapUsd8d)`                                | Configura el límite global en USD.                            |
| `setOracle(address newOracle)`                                         | Actualiza la dirección del oráculo.                           |
| `rescueERC20(address token, uint256 amount, address to)`               | Permite al administrador recuperar tokens enviados por error. |
| `rescueETH(uint256 amount, address to)`                                | Permite al administrador recuperar ETH enviados por error.    |

🧩 Decisiones de diseño (Trade-offs)

Manejo unificado de ETH y ERC-20 (ETH representado por address(0)).

Uso de SafeERC20 para evitar errores en transferencias de tokens.

Patrón CEI (Checks–Effects–Interactions) en todas las funciones críticas.

Errores personalizados para reducir consumo de gas.

Uso de un solo rol administrativo (Ownable) para mantener la simplicidad.

🧪 Resumen de pruebas
🧱 Pruebas con ETH
| Acción                        | Valor                             | Resultado    |
| ----------------------------- | --------------------------------- | ------------ |
| Depósito                      | 0.02 ETH                          | ✅ Exitoso    |
| Consulta de saldo             | `29700000000000000` (≈0.0297 ETH) | ✅ Correcto   |
| Retiro                        | 0.0003 ETH                        | ✅ Exitoso    |
| Retiro con saldo insuficiente | > 0.03 ETH                        | ⚠️ Revertido |
| Precio del oráculo            | `325670622552` (~$3,256.70/ETH)   | ✅ Correcto   |
| Límite en USD (bankCapUsdETH) | Reversión correcta al exceder     | ✅ Verificado |

💰 Tokens ERC-20: MockDAI y MockUSDC

Ambos tokens fueron probados con mint, approve, deposit y withdraw.

⚙️ Parámetros de los tokens
| Token        | Decimales | Símbolo | Monto inicial |
| ------------ | --------- | ------- | ------------- |
| **MockDAI**  | 18        | DAI     | 0.2 DAI       |
| **MockUSDC** | 6         | USDC    | 0.2 USDC      |

🧩 Pruebas con MockDAI
| Paso | Acción                              | Valor              | Resultado    |
| ---- | ----------------------------------- | ------------------ | ------------ |
| 1️⃣  | `mint(msg.sender, 0.2 DAI)`         | 0.2 DAI            | ✅ Éxito      |
| 2️⃣  | `approve(KipuBankV2, 0.2 DAI)`      | 200000000000000000 | ✅ Aprobado   |
| 3️⃣  | `depositToken(MockDAI, 0.01 DAI)`   | 10000000000000000  | ✅ Éxito      |
| 4️⃣  | `viewBalance(user, MockDAI)`        | 0.01 DAI           | ✅ Correcto   |
| 5️⃣  | `withdrawToken(MockDAI, 0.005 DAI)` | 5000000000000000   | ✅ Éxito      |
| 6️⃣  | Prueba de límite excedido           | > 0.2 DAI          | ⚠️ Revertido |

💵 Pruebas con MockUSDC
| Paso | Acción                           | Valor             | Resultado    |
| ---- | -------------------------------- | ----------------- | ------------ |
| 1️⃣  | `mint(msg.sender, 200000)`       | 0.2 USDC          | ✅ Éxito      |
| 2️⃣  | `approve(KipuBankV2, 200000)`    | 0.2 USDC          | ✅ Aprobado   |
| 3️⃣  | `depositToken(MockUSDC, 100000)` | 0.1 USDC          | ✅ Éxito      |
| 4️⃣  | `viewBalance(user, MockUSDC)`    | 100000 (0.1 USDC) | ✅ Correcto   |
| 5️⃣  | `withdrawToken(MockUSDC, 50000)` | 0.05 USDC         | ✅ Éxito      |
| 6️⃣  | Prueba de límite excedido        | > BankCap         | ⚠️ Revertido |

📉 Integración con el oráculo

Dirección del oráculo: 0x694AA1769357215DE4FAC081bf1f309aDC325306

Función utilizada: getETHPriceUSD_8d()

Último valor retornado: 325670622552 (8 decimales).

Usado para calcular el límite en USD del TVL de ETH.

📊 Estado final del contrato (Sepolia verificado)
| Campo                     | Valor                                        |
| ------------------------- | -------------------------------------------- |
| **Contrato**              | `KipuBankV2`                                 |
| **Propietario**           | `0xeFCD678F3E8Ba831787b6eb41ea8A618674B1d8`  |
| **Oráculo**               | `0x694AA1769357215DE4FAC081bf1f309aDC325306` |
| **Límite global ETH**     | `1550000000000000000` (1.55 ETH)             |
| **Límite de retiro ETH**  | `20000000000000000` (0.02 ETH)               |
| **Límite en USD (ETH)**   | `100000000000` ($1,000, 8 decimales)         |
| **ETH total depositado**  | `400000000000000005`                         |
| **DAI total depositado**  | `10000000000000000`                          |
| **USDC total depositado** | `100000`                                     |
| **Red de despliegue**     | Sepolia (verificado en Etherscan)            |

🚀 Despliegue y verificación
🔧 Compilación

Versión Solidity: 0.8.24

EVM: Shanghai

Optimizador: Activado (200 runs)

⚙️ Parámetros de despliegue
| Parámetro                | Valor                                        |
| ------------------------ | -------------------------------------------- |
| `_oracle`                | `0x694AA1769357215DE4FAC081bf1f309aDC325306` |
| `_bankCapUsdETH`         | `0`                                          |
| `_initialEthBankCap`     | `1550000000000000000`                        |
| `_initialEthWithdrawCap` | `20000000000000000`                          |

🔍 Verificación en Etherscan

Archivo: KipuBankV2_flattened.sol

Compilador: Solidity 0.8.24

Licencia: MIT

Argumentos: mismos del constructor.

🌐 Direcciones de contrato (Sepolia)
| Contrato                      | Dirección                                    |
| ----------------------------- | -------------------------------------------- |
| **KipuBankV2**                | `0x259F2AcE582C19436268f4dE17B09a0EE92C6E8`  |
| **Oráculo Chainlink ETH/USD** | `0x694AA1769357215DE4FAC081bf1f309aDC325306` |
| **MockDAI**                   | `0x69A4A1769357215DE4FAC081bf1f309aDC325306` |
| **MockUSDC**                  | `0x7b0E17bBdB3173aD186cbE8B9b7e3a87482Dc43f` |
📜 Licencia

Proyecto bajo la licencia MIT.

👩‍💻 Autora

Desarrollado por N.K.G.G. (Nidia Karina Garzón Grajales)
ETH Kipu – Módulo 3 

## 💡 Recomendación

This repository also includes an English version of the README: [README_ENGLISH.md](./README_ENGLISH.md)
