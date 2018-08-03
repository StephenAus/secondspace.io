# SecondSpace

https://secondspace.io

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


### Pandoc

```shell
pandoc -f markdown+tex_math_dollars -t docx ./WhitePaper.md -o build/WhitePaper.docx

pandoc -f markdown+tex_math_dollars -t html5 WhitePaper.md -o build/WhitePaper.html
```