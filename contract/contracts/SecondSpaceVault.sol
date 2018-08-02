pragma solidity ^0.4.23;

import "./SecondSpaceLiquidityControl.sol";
import "../node_modules/openzeppelin-solidity/contracts//math/SafeMath.sol";

contract SecondSpaceVault is SecondSpaceLiquidityControl {
    using SafeMath for uint256;

    //Wallet Addresses for allocation
    // 创始团队钱包地址
    address public teamReserveWallet;
    // 基金会钱包地址
    address public foundationReserveWallet ;
    // 市场推广激励钱包地址
    address public advisorReserveWallet;

    //Token Allocations
    // Total Token Allocations
    uint256 public totalAllocation = 100 * (10 ** 9) * (10 ** 18);
    // 创始团队 10%
    uint256 public teamReserveAllocation          = 0.1 * 100 * (10 ** 9) * (10 ** 18);
    // 基金会   15%
    uint256 public foundationReserveAllocation    = 0.15 * 100 * (10 ** 9) * (10 ** 18);
    // 公开募集投资人 10%
    uint256 public institutionalReserveAllocation = 0.1 * 100 * (10 ** 9) * (10 ** 18);
    // 市场推广激励  5%
    uint256 public advisorReserveAllocation       = 0.05 * 100 * (10 ** 9) * (10 ** 18);
    // 市场流通  60%
    uint256 public publicReserveAllocation        = 0.6 * 100 * (10 ** 9) * (10 ** 18);

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

     /// @param _new The address of the new Executive
    function setTeamReserveWallet(address _new) external onlyExecutive {
        require(_new != address(0));

        teamReserveWallet = _new;
    }

    /// @param _new The address of the new Financial
    function setFoundationReserveWallet(address _new) external onlyExecutive {
        require(_new != address(0));

        foundationReserveWallet = _new;
    }

    /// @param _new The address of the new Platform
    function setAdvisorReserveWallet(address _new) external onlyExecutive {
        require(_new != address(0));

        advisorReserveWallet = _new;
    }


    function allocate() public notLocked onlyFinancial {

        allocations[teamReserveWallet] = teamReserveAllocation;
        allocations[foundationReserveWallet] = foundationReserveAllocation;
        allocations[advisorReserveWallet] = advisorReserveAllocation;

        emit Allocated(teamReserveWallet, teamReserveAllocation);
        emit Allocated(foundationReserveWallet, foundationReserveAllocation);
        emit Allocated(advisorReserveWallet, advisorReserveAllocation);

        lockedAt = block.timestamp;

        timeLocks[teamReserveWallet] = lockedAt.add(timeLock);
        timeLocks[foundationReserveWallet] = lockedAt.add(timeLock);

        emit Locked(lockedAt);
    }

    //Current Vesting stage 
    function teamVestingStage() public view onlyFinancial returns(uint256){
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