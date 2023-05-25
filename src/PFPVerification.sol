// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import {IPFPVerification} from "./IPFPVerification.sol";
import {ERC165} from "../lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {EnumerableSet} from "../lib/openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

/**
 * @title PFP unique images by community verification.
 *
 */
contract PFPVerification is Ownable, IPFPVerification, ERC165 {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private verifications;

    /**
     * @inheritdoc ERC165
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC165) returns (bool) {
        return
            interfaceId == type(IPFPVerification).interfaceId ||
            super.supportsInterface(interfaceId);
    }    

    function addVerification(
        address[] calldata contracts
    ) external override onlyOwner {
        uint contractsLength = contracts.length;
        for (uint i = 0; i < contractsLength; ) {
            address contract_ = contracts[i];
            verifications.add(contracts[i]);
            emit VerificationAdded(contract_);
            unchecked {
                ++i;
            }
        }
    }

    function removeVerification(
        address[] calldata contracts
    ) external override onlyOwner {
        uint contractsLength = contracts.length;
        for (uint i = 0; i < contractsLength; ) {
            address contract_ = contracts[i];
            verifications.remove(contracts[i]);
            emit VerificationRemoved(contract_);
            unchecked {
                ++i;
            }
        }
    }

    function isVerified(
        address contract_
    ) external view override returns (bool) {
        return verifications.contains(contract_);
    }

    function getVerifiedCollections() external view returns (address[] memory) {
        uint256 length = verifications.length();
        address[] memory result = new address[](length);
        for (uint256 i = 0; i < length; ) {
            result[i] = verifications.at(i);
            unchecked {
                ++i;
            }
        }
        return result;
    }
}
