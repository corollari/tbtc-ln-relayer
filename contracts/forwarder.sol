pragma solidity ^0.6.0;

import "@openzeppelin/contracts-ethereum-package/contracts/GSN/GSNRecipient.sol";

contract Forwarder is GSNRecipientUpgradeSafe {
    address public sender;

    constructor(address _sender) public {
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

    
}
