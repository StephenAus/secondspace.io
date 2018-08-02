pragma solidity ^0.4.23;


// import 'github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "./SecondSpaceLiquidityControl.sol";

contract SecondSpaceCoin is StandardToken , SecondSpaceLiquidityControl {
    string public name = "Second Space Coin";
    string public symbol = "SSC";
    uint8 public decimals = 18;
    uint256 public INITIAL_SUPPLY = 100 * (10**9) * (10**18);

    constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = totalSupply_;
        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
    }

    /**
    * @dev Transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) public returns (bool) {

        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        require(!locked || msg.sender == financialAddress,"Trading is not allowed for the time being");

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
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
        returns (bool)
    {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);

        require(!locked || msg.sender == financialAddress,"Trading is not allowed for the time being");

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }
}