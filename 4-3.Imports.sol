//以下代码用于验证“Hold at least 1 Imports Pin NFTs”任务
//在remix中Deploy & run transactions选项下
//Contract选项选择“ImportsExercise-自己的文件名.sol”
//点击部署，并到下方地址验证合约
//https://docs.base.org/learn/imports/imports-exercise


``````````````````````````````
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Import the SillyStringUtils library
library SillyStringUtils {
    struct Haiku {
        string line1;
        string line2;
        string line3;
    }

    function shruggie(string memory _input) internal pure returns (string memory) {
        return string.concat(_input, unicode" 🤷");
    }
}

contract ImportsExercise {
    // Using the library
    using SillyStringUtils for string;
    
    // Public instance of Haiku
    SillyStringUtils.Haiku public haiku;
    
    // Save Haiku function
    function saveHaiku(
        string memory _line1, 
        string memory _line2, 
        string memory _line3
    ) public {
        haiku.line1 = _line1;
        haiku.line2 = _line2;
        haiku.line3 = _line3;
    }
    
    // Get Haiku function - returns the complete Haiku struct
    function getHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }
    
    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
        SillyStringUtils.Haiku memory modifiedHaiku = SillyStringUtils.Haiku({
            line1: haiku.line1,
            line2: haiku.line2,
            line3: SillyStringUtils.shruggie(haiku.line3)
        });
        return modifiedHaiku;
    }
}
