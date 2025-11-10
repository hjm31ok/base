//Hold at least 1 Basic Contracts Pin NFTs(以下代码置于remix，用于完成base公会任务Base Learn Newcomer)

复制合约地址到下方链接，验证合约地址完成任务
https://docs.base.org/learn/deployment-to-testnet/deployment-to-testnet-exercise

·············································

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BasicMath {
    function adder(uint _a, uint _b) public pure returns (uint sum, bool error) {
        // Use `unchecked` to allow overflow
        unchecked {
            uint c = _a + _b;
            // If the result of the addition is smaller than _a, it means an overflow has occurred
            if (c < _a) {
                return (0, true);
            }
            return (c, false);
        }
    }

    function subtractor(uint _a, uint _b) public pure returns (uint difference, bool error) {
        // Manually check whether underflow will occur (when _a is smaller than _b)
        if (_a < _b) {
            return (0, true);
        }

        // Use `unchecked` to avoid Solidity's underflow check which will stop the transaction
        unchecked {
            uint c = _a - _b;
            return (c, false);
        }
    }
}
