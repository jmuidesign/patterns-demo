// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TestERC1155 is ERC1155, Ownable {
    constructor() ERC1155("") Ownable(msg.sender) {}

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        external
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }
}
