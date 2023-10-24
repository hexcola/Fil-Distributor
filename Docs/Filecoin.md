#  Filecoin

## How Does It Sign A Message?

### What Is The Send Message Looks Like?

```json
{
    Version: 0,
    To: '<To Account Address>',
    From: '<From Account Address>',
    Nonce: 32242,
    Value: '5501717030000000000',
    GasLimit: 0,
    GasFeeCap: '0',
    GasPremium: '0',
    Method: 0,
    Params: null,
}
```

### Where To Get The Nonce, GasLimit, GasFeeCap, GasPremium Value?

**1. Here are the JSON-RPC APIs**

- Nonce: [MpoolGetNonce](https://lotus.filecoin.io/reference/lotus/mpool/#mpoolgetnonce)
- Packed: [GasEstimateMessageGas](https://lotus.filecoin.io/reference/lotus/gas/#gasestimatemessagegas), which means you don't need the following three methods unless you want to do some research. BONUS! if you use this method, you will get CID for free!
    - GasLimit: [GasEstimateGasLimit](https://lotus.filecoin.io/reference/lotus/gas/#gasestimategaslimit)
    - GasFeeCap: [GasEstimateFeeCap](https://lotus.filecoin.io/reference/lotus/gas/#gasestimatefeecap)
    - GasPremium: [GasEstimateGasPremium](https://lotus.filecoin.io/reference/lotus/gas/#gasestimategaspremium)

**2. How to get the API service?**
- Start a full node locally (Not a option)
- https://node.filutils.com/rpc/v1 (You can request without API key)
- https://api.node.glif.io/rpc/v0 (Only support `GasEstimateMessageGas` method)


### How To Sign The Send Message?

1. Generate a CID for the Send message. This step will breaks to two steps. First, the CBOR way to serialize the message. Secondly, use `Blake2b-256` to hash the CID message.
2. Sign the message(include CID), e.g.

```json
{
  Message: {
    Version: 0,
    To: '<To Account Address>',
    From: '<From Account Address>',
    Nonce: 32242,
    Value: '5501717030000000000',
    GasLimit: 1531203,
    GasFeeCap: '101469',
    GasPremium: '100120',
    Method: 0,
    Params: null,
    CID: {
      '/': 'bafy2bzacedge2cv4atcba2o2qu5h7u.................'
    }
  }
}
```
                
In addition of that, it needs the private key.

#### How do they generate private key?

- [go-crypto/crypto.go GenerateKey()](https://github.com/filecoin-project/go-crypto/blob/1d565524a3870963ce21412f8d7834f5459c5ded/crypto.go#L64)
    - [GenerateKeyFromSeed](https://github.com/filecoin-project/go-crypto/blob/1d565524a3870963ce21412f8d7834f5459c5ded/crypto.go#L47)   
    
Only need to know : https://github.com/filecoin-project/lotus/blob/14a7ae339fa57459283cd62ce8c0070b55a39c64/cli/wallet.go#L276

json marshal Key info, which private key is a array to string

#### Sign process

- [WalletSignMessage](https://github.com/filecoin-project/lotus/blob/14a7ae339fa57459283cd62ce8c0070b55a39c64/node/impl/full/wallet.go#L49)
    - [WalletSign](https://github.com/filecoin-project/lotus/blob/0374c5072804f5d8c79236944ef468af75f9627c/chain/wallet/wallet.go#L64) calls [`sigs.Sign`](https://github.com/filecoin-project/lotus/blob/0374c5072804f5d8c79236944ef468af75f9627c/lib/sigs/sigs.go#L18)
        - [secp256k1](https://github.com/filecoin-project/lotus/blob/0374c5072804f5d8c79236944ef468af75f9627c/lib/sigs/secp/init.go#L29)
            - `b2sum := blake2b.Sum256(msg)` [Sum256](https://github.com/minio/blake2b-simd/blob/3f5f724cb5b182a5c278d6d3d55b40e7f8c2efb4/blake2b.go#L294)
            - `sig, err := crypto.Sign(pk, b2sum[:])` [crypto.Sign](https://github.com/filecoin-project/go-crypto/blob/1d565524a3870963ce21412f8d7834f5459c5ded/crypto.go#L26)
                - `secp256k1.Sign(msg, sk)` [secp256k1.Sign](https://github.com/ipsn/go-secp256k1/blob/9d62b9f0bc52d16160f79bfb84b2bbf0f6276b03/secp256.go#L58)
        - [bls](https://github.com/filecoin-project/lotus/blob/0374c5072804f5d8c79236944ef468af75f9627c/lib/sigs/bls/init.go#L48) will call [`ffi.PrivateKeySign`](https://github.com/filecoin-project/filecoin-ffi/blob/441fa8e61189dc32c2960c1f8d8ba56269f20366/rust/src/bls/api.rs#L229)
            - [bls-signatures](https://github.com/filecoin-project/bls-signatures/blob/08fcca2728b3ff5be720f7874c780bfa79e66ec2/src/key.rs#L103)
            
            

### Push Signature To Mpool

Since we will have many messages, we better use `MpoolBatchPush` method, it need an array input of signed messages

```swift
[
  [
    {
      "Message": {
        "Version": 42,
        "To": "f01234",
        "From": "f01234",
        "Nonce": 42,
        "Value": "0",
        "GasLimit": 9,
        "GasFeeCap": "0",
        "GasPremium": "0",
        "Method": 1,
        "Params": "Ynl0ZSBhcnJheQ==",
        "CID": {
          "/": "bafy2bzacebbpdegvr3i4cosewthysg5xkxpqfn2wfcz6mv2hmoktwbdxkax4s"
        }
      },
      "Signature": {
        "Type": 2,
        "Data": "Ynl0ZSBhcnJheQ=="
      }
    },
    ...
    {
      "Message": {
        "Version": 42,
        "To": "f01234",
        "From": "f01234",
        "Nonce": 42,
        "Value": "0",
        "GasLimit": 9,
        "GasFeeCap": "0",
        "GasPremium": "0",
        "Method": 1,
        "Params": "Ynl0ZSBhcnJheQ==",
        "CID": {
          "/": "bafy2bzacebbpdegvr3i4cosewthysg5xkxpqfn2wfcz6mv2hmoktwbdxkax4s"
        }
      },
      "Signature": {
        "Type": 2,
        "Data": "Ynl0ZSBhcnJheQ=="
      }
    }
  ]
]
```

And it will return:

[
  {
    "/": "bafy2bzacea3wsdh6y3a36tb3skempjoxqpuyompjb.........."
  }
  ...
  {
      "/": "..."
  }
]

## How To Generate A PublicKey Address From A PrivateKey

Step 1

- [NewKey(ki KeyInfo)](https://github.com/filecoin-project/lotus/blob/14a7ae339fa57459283cd62ce8c0070b55a39c64/chain/wallet/key/key.go#L37)
  - sigs.ToPublic
    - bls
    - secp
      - [ToPublic](https://github.com/filecoin-project/lotus/blob/14a7ae339fa57459283cd62ce8c0070b55a39c64/lib/sigs/secp/init.go#L25)
        - [crypto.PublicKey](https://github.com/filecoin-project/go-crypto/blob/1d565524a3870963ce21412f8d7834f5459c5ded/crypto.go#L20)
          - [ScalarBaseMult](https://github.com/ipsn/go-secp256k1/blob/9d62b9f0bc52d16160f79bfb84b2bbf0f6276b03/curve.go#L278)
          - [elliptic.Marshal](https://pkg.go.dev/crypto/elliptic#Marshal)   


Step 2
- [address.NewSecp256k1Address(k.PublicKey)](https://github.com/filecoin-project/lotus/blob/14a7ae339fa57459283cd62ce8c0070b55a39c64/chain/wallet/key/key.go#L50C20-L50C60)
  - https://github.com/filecoin-project/go-address/blob/37ccdec47b76ea45424c7c9310e821cb224894e6/address.go#L170
    - [newAddress](https://github.com/filecoin-project/go-address/blob/37ccdec47b76ea45424c7c9310e821cb224894e6/address.go#L231)


## CHANGELOG

- 20231018 @hexcola 
