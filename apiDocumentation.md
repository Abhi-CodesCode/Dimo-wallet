## API Usage Documentation

### 1. API Endpoints Documentation

This section provides a comprehensive guide to the API endpoints used in the `demo_wallet` project. Each endpoint includes details about the request structure, response structure, and examples of how to use them.

---

#### 1.1. User Login

- **Endpoint:** `/user/login`
- **Method:** POST
- **Description:** Authenticates a user and returns an authentication token along with wallet details.

##### Request Structure

```json
{
  "mixed": "user_identifier",
  "password": "user_password"
}
```

##### Response Structure

```json
{
  "token": "auth_token",
  "wallet_address": "user_wallet_address",
  "has_wallet": true
}
```

##### Example Request

```sh
curl -X POST https://api.socialverseapp.com/user/login \
     -H "Content-Type: application/json" \
     -d '{"mixed": "user@example.com", "password": "password123"}'
```

##### Example Response

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "wallet_address": "0x1234567890abcdef1234567890abcdef12345678",
  "has_wallet": true
}
```

---

#### 1.2. Create Wallet

- **Endpoint:** `/solana/wallet/create`
- **Method:** POST
- **Description:** Creates a new wallet for the authenticated user.

##### Request Structure

```json
{
  "name": "user_wallet_name",
  "passCode": "user_wallet_passcode"
}
```

##### Response Structure

```json
{
  "message": "Wallet created successfully",
  "wallet_address": "new_wallet_address"
}
```

##### Example Request

```sh
curl -X POST https://api.socialverseapp.com/solana/wallet/create \
     -H "Content-Type: application/json" \
     -H "Flic-Token: auth_token" \
     -d '{"name": "MyWallet", "passCode": "123456"}'
```

##### Example Response

```json
{
  "message": "Wallet created successfully",
  "wallet_address": "0xabcdef1234567890abcdef1234567890abcdef12"
}
```

---

#### 1.3. Transfer Tokens

- **Endpoint:** `/mainnet/transfer-tokens`
- **Method:** POST
- **Description:** Transfers tokens from the authenticated user's wallet to a recipient's address.

##### Request Structure

```json
{
  "recipient": "recipient_wallet_address",
  "network": "network_name",
  "from": "sender_wallet_address",
  "amount": amount,
  "user_pin": "user_pin",
  "developer_secret": "developer_secret",
  "token": "token_address"
}
```

##### Response Structure

```json
{
  "message": "Transfer successful"
}
```

##### Example Request

```sh
curl -X POST "https://api.socialverseapp.com/mainnet/transfer-tokens?recipient=0xabcdef1234567890abcdef1234567890abcdef12&network=Polygon&from=0x1234567890abcdef1234567890abcdef12345678&amount=10.5&user_pin=123456&developer_secret=testnet-secret&token=0xec05f9eb5ebc36732256bc86eaf654c55a20752a" \
     -H "Content-Type: application/json" \
     -H "Flic-Token: auth_token"
```

##### Example Response

```json
{
  "message": "Transfer successful"
}
```

---

#### 1.4. Fetch Wallet Balance

- **Endpoint:** `/mainnet/wallet/balance`
- **Method:** GET
- **Description:** Retrieves the balance of the authenticated user's wallet.

##### Request Structure

No request body needed.

##### Response Structure

```json
{
  "balance": {
    "token_address": {
      "token_name": "token_balance"
    }
  }
}
```

##### Example Request

```sh
curl -X GET https://api.socialverseapp.com/mainnet/wallet/balance?network=Polygon&wallet_address=0x1234567890abcdef1234567890abcdef12345678 \
     -H "Content-Type: application/json" \
     -H "Flic-Token: auth_token"
```

##### Example Response

```json
{
  "balance": {
    "0xec05f9eb5ebc36732256bc86eaf654c55a20752a": {
      "Polygon Token": "1000"
    }
  }
}
```

---

#### 1.5. Fetch Wallet Activity

- **Endpoint:** `/mainnet/activity`
- **Method:** GET
- **Description:** Retrieves the transaction history of the authenticated user's wallet.

##### Request Structure

No request body needed.

##### Response Structure

```json
{
  "activity": [
    {
      "timestamp": "2024-06-01T12:34:56Z",
      "transaction_type": "send",
      "amount": "10.5",
      "recipient": "0xabcdef1234567890abcdef1234567890abcdef12"
    },
    {
      "timestamp": "2024-05-20T08:12:34Z",
      "transaction_type": "receive",
      "amount": "15.0",
      "sender": "0x1234567890abcdef1234567890abcdef12345678"
    }
  ]
}
```

##### Example Request

```sh
curl -X GET https://api.socialverseapp.com/mainnet/activity?network=Polygon&wallet_address=0x1234567890abcdef1234567890abcdef12345678 \
     -H "Content-Type: application/json" \
     -H "Flic-Token: auth_token"
```

##### Example Response

```json
{
  "activity": [
    {
      "timestamp": "2024-06-01T12:34:56Z",
      "transaction_type": "send",
      "amount": "10.5",
      "recipient": "0xabcdef1234567890abcdef1234567890abcdef12"
    },
    {
      "timestamp": "2024-05-20T08:12:34Z",
      "transaction_type": "receive",
      "amount": "15.0",
      "sender": "0x1234567890abcdef1234567890abcdef12345678"
    }
  ]
}
```

---
