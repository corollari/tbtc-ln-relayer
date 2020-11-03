pragma solidity ^0.6.0;

import "@openzeppelin/contracts-ethereum-package/contracts/GSN/GSNRecipient.sol";

contract Forwarder is GSNRecipientUpgradeSafe {
    address public tBTContract;
    address public sender;

    constructor(address _sender, address _tBTContract) public {
        tBTContract = _tBTContract;
        sender = _sender;
    }

    function acceptRelayedCall(
        address relay,
        address from,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata approvalData,
        uint256 maxPossibleCharge
    ) override external view returns (uint256, bytes memory) {
        if(from == sender){
            return (0, approvalData); // Approve
        } else {
            return (100, approvalData); // Reject
        }
    }

    // We won't do any pre or post processing, so leave _preRelayedCall and _postRelayedCall empty
    function _preRelayedCall(bytes memory context) override internal returns (bytes32) {
    }

    function _postRelayedCall(bytes memory context, bool, uint256 actualCharge, bytes32) override internal {
    }
    
    function extractAllEth() public {
        require(msg.sender == sender);
        msg.sender.transfer(address(this).balance);
    }

    fallback() external payable {
        assembly {
            let _target := sload(0)
            calldatacopy(0, 0, calldatasize())
            let result := call(gas(), _target, callvalue(), 0, calldatasize(), 0, 0)
            returndatacopy(0, 1, returndatasize())
            switch result
            // call returns 0 on error.
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }

    }
}
