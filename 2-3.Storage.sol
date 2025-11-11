//此代码为“Hold at least 1 Storage Pin NFTs”部署代码
//在remix部署时，SOLDITY COMPILER选择solidity ^0.8.30
//DEPLOY & RUNTRANSACTIONS选项中，Verify Contract on Explorers强制填写：
//shares - 1000
//name - Pat
//salary - 50000
//idNumber - 112358132134

//最后到以下地址验证
//https://docs.base.org/learn/storage/storage-exercise

·····································

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmployeeStorage {
    // Custom error for too many shares
    error TooManyShares(uint256 totalShares);
    
    // State variables optimized for storage packing
    // Slot 0: shares (uint16) + salary (uint32) = 48 bits total
    uint16 private shares;      // Max 65,535 (enough for max 5,000 shares)
    uint32 private salary;      // Max 4.2 billion (enough for max 1,000,000)
    
    // Slot 1: name (string) - dynamic size, takes full slot
    string public name;
    
    // Slot 2: idNumber (uint256) - takes full slot  
    uint256 public idNumber;
    
    constructor(
        uint16 _shares,
        string memory _name, 
        uint32 _salary,
        uint256 _idNumber
    ) {
        shares = _shares;
        name = _name;
        salary = _salary;
        idNumber = _idNumber;
    }
    
    // View functions for private variables
    function viewSalary() public view returns (uint32) {
        return salary;
    }
    
    function viewShares() public view returns (uint16) {
        return shares;
    }
    
    // Grant shares function with validation
    function grantShares(uint16 _newShares) public {
        // Check if _newShares itself is greater than 5000
        if (_newShares > 5000) {
            revert("Too many shares");
        }
        
        uint256 totalShares = uint256(shares) + uint256(_newShares);
        
        // Check if total would exceed 5000
        if (totalShares > 5000) {
            revert TooManyShares(totalShares);
        }
        
        shares += _newShares;
    }
    
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot)
        }
    }

    function debugResetShares() public {
        shares = 1000;
    }
}
