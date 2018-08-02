// var ConvertLib = artifacts.require("./ConvertLib.sol");
// var MetaCoin = artifacts.require("./MetaCoin.sol");

// module.exports = function(deployer) {
//   deployer.deploy(ConvertLib);
//   deployer.link(ConvertLib, MetaCoin);
//   deployer.deploy(MetaCoin);
// };


// var SecondSpaceAccessControl = artifacts.require(
//   './SecondSpaceAccessControl.sol'
// )
// var SecondSpaceLiquidityControl = artifacts.require(
//   './SecondSpaceLiquidityControl.sol'
// )
var SecondSpaceCoin = artifacts.require('SecondSpaceCoin.sol')
// var ESICToken = artifacts.require('ESICToken.sol')

module.exports = function(deployer) {
  // deployer.deploy(SecondSpaceAccessControl)
  // deployer.link(SecondSpaceAccessControl, SecondSpaceLiquidityControl);
  // deployer.deploy(SecondSpaceLiquidityControl, SecondSpaceAccessControl.address)
  // deployer.link(SecondSpaceLiquidityControl, SecondSpaceCoin);
  deployer.deploy(SecondSpaceCoin)
  // deployer.deploy(ESICToken)
}
