// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNFT is ERC721 {
    uint256 s_tokenCounter;
    string private s_sadSvgImageURI;
    string private s_happySvgImageURI;
    error MoodNft__CantFlipMoodIfNotOwner();

    enum Mood {
        Happy,
        Sad
    }
    mapping(uint256 => Mood) private s_tokenIdtoMood;

    constructor(
        string memory sadSvg,
        string memory happySvg
    ) ERC721("MoodNFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageURI = sadSvg;
        s_happySvgImageURI = happySvg;
    }

    function mintNFT() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdtoMood[s_tokenCounter] = Mood.Happy;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        if (
            getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender
        ) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if (s_tokenIdtoMood[tokenId] == Mood.Happy) {
            s_tokenIdtoMood[tokenId] = Mood.Sad;
        } else {
            s_tokenIdtoMood[tokenId] = Mood.Happy;
        }
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdtoMood[tokenId] == Mood.Happy) {
            imageURI = s_happySvgImageURI;
        } else {
            imageURI = s_sadSvgImageURI;
        }
        return
            string(
                abi.encodePacked(
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name(),
                                '","description":"an NFT that reflects owners mood.","atributes":[{"trait_type": "moodiness", "value": 100}], "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
