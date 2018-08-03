pragma solidity ^0.4.23;

import "../node_modules/openzeppelin-solidity/contracts/access/Whitelist.sol";

// 管理团队钱包地址
// 代币的分配和释放
contract SecondSpaceAccessControl is Whitelist{

    // 设置团队管理者钱包地址.
    // Executive 执行人
    // 负责设置Financial，平台管理员，负责设置团队地址，推广地址，基金会地址
    // 控制流动性开关，
    address public executiveAddress;
    // 财务，负责私募发行，团队、基金会定期释放，广告推广资金的授权。
    address public financialAddress;
    // 平台，负责市场流通部分的发行
    address public platformAddress;


    /// @dev Access modifier for Executive-only functionality
    modifier onlyExecutive() {
        require(msg.sender == executiveAddress);
        _;
    }

    /// @dev Access modifier for Financial-only functionality
    modifier onlyFinancial() {
        require(msg.sender == financialAddress);
        _;
    }

    /// @dev Access modifier for Platform-only functionality
    modifier onlyPlatform() {
        require(msg.sender == platformAddress);
        _;
    }

    modifier onlyMaster() {
        require(
            msg.sender == executiveAddress || 
            msg.sender == financialAddress ||
            msg.sender == platformAddress
        );
        _;
    }

    /// @dev Assigns a new address to act as the Executive. Only available to the current Executive.
    /// @param _new The address of the new Executive
    function setExecutive(address _new) external onlyExecutive {
        require(_new != address(0));

        if(executiveAddress != address(0)){
            removeAddressFromWhitelist(executiveAddress);
        }
        executiveAddress = _new;
        addAddressToWhitelist(executiveAddress);
    }

    /// @dev Assigns a new address to act as the Financial. Only available to the current Executive.
    /// @param _new The address of the new Financial
    function setFinancial(address _new) external onlyExecutive {
        require(_new != address(0));
        if(financialAddress != address(0)){
            removeAddressFromWhitelist(financialAddress);
        }
        financialAddress = _new;
        addAddressToWhitelist(financialAddress);
    }

    /// @dev Assigns a new address to act as the Platform. Only available to the current Executive.
    /// @param _new The address of the new Platform
    function setPlatform(address _new) external onlyExecutive {
        require(_new != address(0));
        if(platformAddress != address(0)){
            removeAddressFromWhitelist(platformAddress);
        }
        platformAddress = _new;
        addAddressToWhitelist(platformAddress);
    }


}
