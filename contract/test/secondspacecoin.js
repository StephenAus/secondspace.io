var SecondSpaceCoin = artifacts.require("./SecondSpaceCoin.sol");

contract('SecondSpaceCoin',  async function(accounts) {
  it("should put 10 billion SecondSpaceCoin in the first account", async function() {
    let instance = await SecondSpaceCoin.deployed();
    
    let balance = await instance.balanceOf.call(accounts[0]);
    assert.equal(balance.valueOf(), 100 * 1000000000 * 1000000000000000000, "10000 wasn't in the first account");
    
  });

  it("SecondSpaceCoin is Locked", async function() {
    let instance = await SecondSpaceCoin.deployed();
    let balance = await instance.locked();

    assert.equal(balance, true, "SecondSpaceCoin is Locked true");
     
  });

  it("owner transfer to", async function() {
    try {
      let instance = await SecondSpaceCoin.deployed();

      let result = await instance.transfer(accounts[1] ,100000);
      // assert.equal(result, false, "transfer failure");

      let balance = await instance.balanceOf.call(accounts[1]);
      assert.equal(balance.valueOf(), 100000, "0 SSC in accounts[1]");

    } catch (error) {
      const revert = error.message.search('revert') >= 1;
      // console.log(revert);
      console.log(error.message);
      assert.equal(revert, true, "throws error revert");
    }
  });

  it("set Financial", async function() {
    let instance = await SecondSpaceCoin.deployed();

    let result = await instance.setFinancial(accounts[1]);

    let financialAddress = await instance.financialAddress()

    assert.equal(financialAddress, accounts[1], "setFinancial  succeed");
  });
 

  it("setFinancial and financial transfer to", async function() {
    try{
      let instance = await SecondSpaceCoin.deployed();

      // let result = await instance.setFinancial(accounts[1]);
      let financialAddress = await instance.financialAddress()

      // console.log(financialAddress);
      // console.log(accounts[1]);

      let transfer = await instance.transfer(accounts[2] ,10000 , {from : accounts[1]});

      // console.log(transfer);
      // assert.equal(result, true, "transfer failure");

      let balance = await instance.balanceOf.call(accounts[2]);
      assert.equal(balance.valueOf(), 10000, "10000 SSC in accounts[2]");
    }catch(error){
      console.log(error);
      
    }
  });


  it("other transfer throws error", async function() {
    let instance = await SecondSpaceCoin.deployed();
    
    try {
      let result = await instance.transfer(accounts[3] ,10000, {from : accounts[2]});
    } catch (error) {
      const revert = error.message.search('revert') >= 1;
      console.log(error.message);
      assert.equal(revert, true, "throws error revert");
    }

    let balance = await instance.balanceOf.call(accounts[3]);
    assert.equal(balance.valueOf(), 0, "0 SSC in accounts[1]");
  });


  it("unlock and other transfer ", async function() {
    let instance = await SecondSpaceCoin.deployed();
    
    await instance.unlock({from : accounts[1]});
    await instance.transfer(accounts[3] ,10000, {from : accounts[2]});
     
    let balance = await instance.balanceOf.call(accounts[3]);
    assert.equal(balance.valueOf(), 10000, "0 SSC in accounts[1]");
  });

   
});
