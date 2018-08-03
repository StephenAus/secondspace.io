# SecondSpace

http://www.secondspace.io

### Introduction

Senond Space is a secure, easy-to-use, easily extensible, blockchain-based DApp open platform that provides infrastructure such as network, bandwidth, smart contracts, and program interfaces, making it easy for anyone to create and deploy their own DApp.


### WhitePaper

 [WhitePaper](WhitePaper.md)

### Development


```shell
truffle compile

truffle migrate

truffle console
```


### Test

```shell
truffle test
```

### Deployment

```shell
truffle-flattener contracts/SecondSpaceCoin.sol > build/SecondSpaceCoin.remix.sol

truffle-flattener contracts/SecondSpaceVault.sol > build/SecondSpaceVault.remix.sol
```

> https://github.com/alcuadrado/truffle-flattener
