pragma solidity ^0.4.23;

import "./SecondSpaceVault.sol";
import "./SecondSpaceCoin.sol";

contract SecondSpace is SecondSpaceVault {

    SecondSpaceCoin public token;

    constructor() public {
        owner = msg.sender;
        executiveAddress = msg.sender;

        // token = SecondSpaceCoin(tokenAddress);
    }

 
    // Number of tokens that are still locked
    function getLockedBalance() public view onlyFinancial returns (uint256 tokensLocked) {
        return allocations[msg.sender].sub(claimed[msg.sender]);
    }

    //Distribute tokens for non-vesting reserve wallets
    function claimAdvisorReserve() onlyFinancial isLocked public {
        
        // Must Only claim once
        require(allocations[advisorReserveWallet] > 0);
        require(claimed[advisorReserveWallet] == 0);

        uint256 amount = allocations[advisorReserveWallet];

        claimed[advisorReserveWallet] = amount;

        require(token.transfer(advisorReserveWallet, amount));

        emit Distributed(advisorReserveWallet, amount);
    }

     //Claim tokens for team reserve wallet
    function claimReserve(address reserveWallet) onlyFinancial isLocked public {

        require(reserveWallet == teamReserveWallet || reserveWallet == foundationReserveWallet);

        uint256 vestingStage = teamVestingStage();

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