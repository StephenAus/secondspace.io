pragma solidity ^0.4.23;

import "./SecondSpaceAccessControl.sol";
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract SecondSpaceVesting is SecondSpaceAccessControl {
    using SafeMath for uint256;
   
    // variables
    // 资金锁定时间
    uint256 public timeLock = 3 * 365 days;
    // 分36个月，分批释放
    uint256 public vestingStages = 36;

    /** Reserve allocations */
    mapping(address => uint256) public allocations;

    /** When timeLocks are over (UNIX Timestamp)  */
    mapping(address => uint256) public timeLocks;

    /** How many tokens each reserve wallet has claimed */
    mapping(address => uint256) public claimed;

    /** When this vault was locked (UNIX Timestamp)*/
    uint256 public lockedAt = 0;

    // events
    /** Allocated reserve tokens */
    event Allocated(address wallet, uint256 value);

    /** Distributed reserved tokens */
    event Distributed(address wallet, uint256 value);

    /** Tokens have been locked */
    event Locked(uint256 lockTime);

    // modifiers
    //Has not been locked yet
    modifier notLocked {
        require(lockedAt == 0);
        _;
    }

    modifier isLocked {
        require(lockedAt > 0);
        _;
    }

    //Current Vesting stage 
    function currentVestingStage() public view onlyFinancial returns(uint256){
        // Every 3 months
        uint256 vestingMonths = timeLock.div(vestingStages);

        uint256 stage = (block.timestamp.sub(lockedAt)).div(vestingMonths);

        //Ensures team vesting stage doesn't go past teamVestingStages
        if(stage > vestingStages){
            stage = vestingStages;
        }
        return stage;
    }


}