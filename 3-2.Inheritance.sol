//以下代码用于验证“Hold at least 1 Inheritance NFTs”任务
//此任务需要验证两个合约，最终将两个合约合并为一个合约
//第一个
//在remix中进入Deploy & run transactions
//在Contract选项中选择“Salesperson-自己的文件名.sol”
//在Deplay & Verify下方，输入：
//_idNumber:55555  _managerId:12345  _hourlyRate:20
//点击部署获得第一个合约

//第二个
//在remix中进入Deploy & run transactions
//在Contract选项中选择“EngineeringManager-自己的文件名.sol”
//在Deplay & Verify下方，输入：
//_idNumber:54321  _managerId:11111  _hourlyRate:200000
//点击部署获得第二个合约

//合成两个合约
//在remix中进入Deploy & run transactions
//在Contract选项中选择“InheritanceSubmission-自己的文件名.sol”
//在Deplay & Verify下方，输入：
//_salesPerson:第一个合约  _engineeringManager:第二个合约
//点击部署合约

//将合成的第三个合约在下方地址验证
//https://docs.base.org/learn/inheritance/inheritance-exercise


```````````````````````````
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Abstract base contract
abstract contract Employee {
    uint public idNumber;
    uint public managerId;
    
    constructor(uint _idNumber, uint _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }
    
    function getAnnualCost() public view virtual returns (uint);
}

// Salaried employee contract
contract Salaried is Employee {
    uint public annualSalary;
    
    constructor(uint _idNumber, uint _managerId, uint _annualSalary) 
        Employee(_idNumber, _managerId) {
        annualSalary = _annualSalary;
    }
    
    function getAnnualCost() public view override returns (uint) {
        return annualSalary;
    }
}

// Hourly employee contract
contract Hourly is Employee {
    uint public hourlyRate;
    
    constructor(uint _idNumber, uint _managerId, uint _hourlyRate) 
        Employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }
    
    function getAnnualCost() public view override returns (uint) {
        return hourlyRate * 2080; // 2080 hours per year
    }
}

// Manager contract
contract Manager {
    uint[] public employeeIds;
    
    function addReport(uint _employeeId) public {
        employeeIds.push(_employeeId);
    }
    
    function resetReports() public {
        delete employeeIds;
    }
    
    function getEmployeeIds() public view returns (uint[] memory) {
        return employeeIds;
    }
}

// Salesperson contract (inherits from Hourly)
contract Salesperson is Hourly {
    constructor(uint _idNumber, uint _managerId, uint _hourlyRate) 
        Hourly(_idNumber, _managerId, _hourlyRate) {
    }
}

// Engineering Manager contract (multiple inheritance)
contract EngineeringManager is Salaried, Manager {
    constructor(uint _idNumber, uint _managerId, uint _annualSalary) 
        Salaried(_idNumber, _managerId, _annualSalary) {
    }
}

// Submission contract
contract InheritanceSubmission {
    address public salesPerson;
    address public engineeringManager;

    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}
