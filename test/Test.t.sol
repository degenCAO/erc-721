pragma solidity 0.8.30;

import {Test} from "forge-std/Test.sol";
import {BasicNFT} from "src/BasicNFT.sol";
import {Deploy} from "script/Deploy.s.sol";

contract BasicNFTTest is Test {
    Deploy public deploy;
    BasicNFT public basicNFT;
    address public USER = makeAddr("user");
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deploy = new Deploy();
        basicNFT = deploy.run();
        vm.deal(USER, 100 ether);
    }

    function testNameIsCorrect() public view {
        string memory actualName = basicNFT.name();
        string memory expectedName = "Dogie";
        assert(
            keccak256(abi.encodePacked(actualName)) ==
                keccak256(abi.encodePacked(expectedName))
        );
    }

    function testIsMintableAndHaveABalance() public {
        vm.prank(USER);

        basicNFT.mintNFT(PUG);

        assert(basicNFT.balanceOf(USER) == 1);
        assert(
            keccak256(abi.encodePacked(PUG)) ==
                keccak256(abi.encodePacked(basicNFT.tokenURI(0)))
        );
    }
}
