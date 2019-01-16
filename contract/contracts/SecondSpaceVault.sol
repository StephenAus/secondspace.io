pragma solidity ^0.4.23;

import "./SecondSpaceVesting.sol";
import "./SecondSpaceCoin.sol";

contract SecondSpaceVault is SecondSpaceVesting {

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


    SecondSpaceCoin public token;

    constructor(address _tokenAddress) public {
        owner = msg.sender;
        executiveAddress = msg.sender;

        token = SecondSpaceCoin(_tokenAddress);
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
        allocations[financialAddress] = institutionalReserveAllocation;
        allocations[platformAddress] = publicReserveAllocation;

        emit Allocated(teamReserveWallet, teamReserveAllocation);
        emit Allocated(foundationReserveWallet, foundationReserveAllocation);
        emit Allocated(advisorReserveWallet, advisorReserveAllocation);
        emit Allocated(financialAddress, institutionalReserveAllocation);
        emit Allocated(platformAddress, publicReserveAllocation);


        lockedAt = block.timestamp;
        emit Locked(lockedAt);
    }

    function distribute() public isLocked onlyFinancial {

        claimTokenReserve(advisorReserveWallet);
        claimTokenReserve(financialAddress);
        claimTokenReserve(platformAddress);
        
    }
    // Number of tokens that are still locked
    function getLockedBalance(address _reserveAddress) public view returns (uint256 tokensLocked) {
        return allocations[_reserveAddress].sub(claimed[_reserveAddress]);
    }

    //Distribute tokens for non-vesting reserve wallets
    function claimTokenReserve(address reserveWallet) onlyFinancial isLocked private {
        
        require(reserveWallet == advisorReserveWallet 
                || reserveWallet == financialAddress
                || reserveWallet == platformAddress);

        // Must Only claim once
        require(allocations[reserveWallet] > 0);
        require(claimed[reserveWallet] == 0);

        uint256 amount = allocations[reserveWallet];

        claimed[reserveWallet] = amount;

        require(token.transfer(reserveWallet, amount));

        emit Distributed(reserveWallet, amount);
    }

     //Claim tokens for team reserve wallet
    function claimReserve(address reserveWallet) public onlyFinancial isLocked  {

        require(reserveWallet == teamReserveWallet || reserveWallet == foundationReserveWallet);

        uint256 vestingStage = currentVestingStage();

        //Amount of tokens the team should have at this vesting stage
        uint256 totalUnlocked = vestingStage.mul(allocations[reserveWallet]).div(vestingStages);

        require(totalUnlocked <= allocations[reserveWallet]);

        //Previously claimed tokens must be less than what is unlocked
        require(claimed[reserveWallet] < totalUnlocked);

        uint256 payment = totalUnlocked.sub(claimed[reserveWallet]);

        claimed[reserveWallet] = totalUnlocked;

        require(token.transfer(reserveWallet, payment));

        emit Distributed(reserveWallet, payment);
    }
}