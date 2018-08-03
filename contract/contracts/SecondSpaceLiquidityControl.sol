pragma solidity ^0.4.23;

import "./SecondSpaceAccessControl.sol";

// 控制代币的流动性
contract SecondSpaceLiquidityControl is SecondSpaceAccessControl {
      // @dev Keeps track whether the contract is locked. When that is true, most actions are blocked
    bool public locked = true;

    /// @dev Modifier to allow actions only when the contract IS NOT locked
    modifier whenNotLocked() {
        require(!locked);
        _;
    }

    /// @dev Modifier to allow actions only when the contract IS locked
    modifier whenLocked {
        require(locked);
        _;
    }
    /**
    * @dev Throws if operator is not whitelisted.
    */
    modifier restrictedLiquidity{
        if(locked){
            checkRole(msg.sender, ROLE_WHITELISTED);
        }
        _;
    }

    /// @dev Called by any "C-level" role to pause the contract. Used only when
    ///  a bug or exploit is detected and we need to limit damage.
    function lock() external onlyFinancial whenNotLocked {
        locked = true;
    }

    /// @dev Unpauses the smart contract. Can only be called by the CEO, since
    ///  one reason we may pause the contract is when CFO or COO accounts are
    ///  compromised.
    /// @notice This is public rather than external so it can be called by
    ///  derived contracts.
    function unlock() external onlyFinancial whenLocked {
        locked = false;
    }
}

