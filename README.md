 Donation Vault — A Decentralized STX Donation Smart Contract on Stacks

 Overview
The **Donation Vault** smart contract is a decentralized application built using **Clarity** on the **Stacks blockchain**.  
It enables users to donate **STX tokens** into a shared vault while allowing the contract owner to **manage funds**, **track donors**, and **withdraw STX** securely.

This project demonstrates:
- Decentralized STX transfer and storage.
- Ownership-based access control.
- Safe transaction handling.
- Transparent and auditable donation tracking.

---

 Features

-  **STX Donations:** Anyone can send STX to the vault.  
-  **Track Donations:** Keeps a record of each donor and total donated STX.  
-  **Owner Privileges:** The owner can withdraw STX, reset donations, and transfer ownership.  
-  **Security Checks:** Validates all transfers and prevents invalid or unauthorized actions.  
-  **Clarinet Ready:** 100% compatible with `clarinet check` and `clarinet console`.

---

 Smart Contract Details

**Contract Name:** `donation-vault`  
**Language:** Clarity  
**Framework:** Clarinet  
**Network:** Stacks Blockchain  

---

 Core Functions

| Function | Type | Description |
|-----------|------|-------------|
| `donate (amount uint)` | Public | Allows users to donate STX to the contract. |
| `withdraw (amount uint)` | Public | Allows the owner to withdraw funds. |
| `transfer-ownership (new-owner principal)` | Public | Transfers contract ownership to another address. |
| `reset-donor (user principal)` | Public | Owner can reset a specific donor record. |
| `get-total-donations` | Read-only | Returns total STX donations stored. |
| `get-donor (user principal)` | Read-only | Returns donation total for a specific user. |
| `get-owner` | Read-only | Returns the current owner principal. |
| `is-donor (user principal)` | Read-only | Checks if a user has donated before. |
| `get-donor-info (user principal)` | Read-only | Returns detailed donor info if found. |

---

 Getting Started

 Clone the Repository
```bash
git clone https://github.com/your-username/donation-vault.git
cd donation-vault
