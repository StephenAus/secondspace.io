pragma solidity ^0.4.23;


import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "./SecondSpaceLiquidityControl.sol";

contract SecondSpaceCoin is StandardToken , SecondSpaceLiquidityControl {
    string public name = "Second Space Coin";
    string public symbol = "SSC";
    uint8 public decimals = 18;
    uint256 public INITIAL_SUPPLY = 100 * (10**9) * (10**18);

    constructor() public {
        totalSupply_            = INITIAL_SUPPLY;
        balances[msg.sender]    = totalSupply_;
        executiveAddress        = msg.sender;
        addAddressToWhitelist(executiveAddress);

        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
    }

    /**
    * @dev Transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value)  public restrictedLiquidity returns (bool) {
        return super.transfer(_to, _value);
    }


    /**
    * @dev Transfer tokens from one address to another
    * @param _from address The address which you want to send tokens from
    * @param _to address The address which you want to transfer to
    * @param _value uint256 the amount of tokens to be transferred
    */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    )
        public
        restrictedLiquidity
        returns (bool)
    {
        return super.transferFrom(_from, _to, _value);
    }
}