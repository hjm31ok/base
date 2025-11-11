//此代码用于验证“Hold at least 1 SCD ERC721 Pin NFTs”任务
//合约部署成功后，到下方地址验证
//https://docs.base.org/learn/token-development/erc-721-token/erc-721-exercise

//验证过程中会提示验证失败
//❌ Should be able to mint unique haikus but block copies
//-> Call to mintHaiku failed
//-> AssertionError: 0x6e48a8ba76b70e3d3f9bf6e86909018ab55abb85 is not equal to 0x70e101af1ddd0f4ab8374f5d55c57b8d6c7e1a29
//❌ Should create and share access to haikus
//-> AssertionError: 0x6e48a8ba76b70e3d3f9bf6e86909018ab55abb85 is not equal to 0xa682ae425546fa5bc8c524d77e243de30d44cd5f
//-> AssertionError: 0x6e48a8ba76b70e3d3f9bf6e86909018ab55abb85 is not equal to 0x17a4405c9ecf0a9f9ab9db3d842a97127884c6e5
//ERC-721 Tokens NFT Badge Earned on Base Sepolia!
//ERC-721 Tokens NFT Badge
//无需紧张，继续完成下面的任务即可


``````````````````````````````````
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HaikuNFT is ERC721 {
    // Custom errors
    error HaikuNotUnique();
    error NotYourHaiku(uint256 haikuId);
    error NoHaikusShared();

    // Structure for storing haiku data
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    // Public array to store all haiku
    Haiku[] public haikus;

    // Mapping to save shared haiku from address to haiku ID
    mapping(address => uint256[]) public sharedHaikus;

    // Counter for tracking total haiku and as next ID
    uint256 public counter = 1;

    // Mapping for tracking lines that have been used
    mapping(string => bool) private usedLines;

    constructor() ERC721("HaikuNFT", "HAIKU") {
        // Constructor kosong, ERC721 sudah menginisialisasi nama dan symbol
    }

    // Function for mint new haiku
    function mintHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) external {
        // Check whether one of the lines has been used before
        if (
            usedLines[_line1] ||
            usedLines[_line2] ||
            usedLines[_line3]
        ) {
            revert HaikuNotUnique();
        }

        // Mark lines as used
        usedLines[_line1] = true;
        usedLines[_line2] = true;
        usedLines[_line3] = true;

        // Create a new haiku
        Haiku memory newHaiku = Haiku({
            author: msg.sender,
            line1: _line1,
            line2: _line2,
            line3: _line3
        });

        // Add to array of haikus
        haikus.push(newHaiku);

        // Mint NFT with counter as tokenId
        _mint(msg.sender, counter);

        // Increment counter untuk ID berikutnya
        counter++;
    }

    // Function to share haiku to other addresses
    function shareHaiku(address _to, uint256 _haikuId) public {
        // Check if the sender is the owner of the haiku NFT
        if (ownerOf(_haikuId) != msg.sender) {
            revert NotYourHaiku(_haikuId);
        }

        // Add haiku ID to shared haikus from destination address
        sharedHaikus[_to].push(_haikuId);
    }

    // Function to get all haiku shared to caller
    function getMySharedHaikus() public view returns (Haiku[] memory) {
        uint256[] memory mySharedIds = sharedHaikus[msg.sender];
        
        // Check if there are any haiku shared
        if (mySharedIds.length == 0) {
            revert NoHaikusShared();
        }

        // Create a results array with a size according to the number of shared haikus.
        Haiku[] memory result = new Haiku[](mySharedIds.length);
        
        // Loop and fetch haiku data by ID
        for (uint256 i = 0; i < mySharedIds.length; i++) {
            // Because tokenId starts from 1, but array index from 0
            result[i] = haikus[mySharedIds[i] - 1];
        }

        return result;
    }

    // Helper function to get the total number of haiku that have been minted
    function getTotalHaikus() public view returns (uint256) {
        return haikus.length;
    }

    // Helper function to get haiku by ID
    function getHaiku(uint256 _haikuId) public view returns (Haiku memory) {
        require(_haikuId > 0 && _haikuId < counter, "Invalid haiku ID");
        return haikus[_haikuId - 1];
    }
}
