// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {DefaultStakerRewards} from "./DefaultStakerRewards.sol";
import {Registry} from "@symbiotic/contracts/common/Registry.sol";

import {IDefaultStakerRewardsFactory} from "src/interfaces/defaultStakerRewards/IDefaultStakerRewardsFactory.sol";

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";

contract DefaultStakerRewardsFactory is Registry, IDefaultStakerRewardsFactory {
    using Clones for address;

    address private immutable STAKER_REWARDS_IMPLEMENTATION;

    constructor(address stakerRewardsImplementation) {
        STAKER_REWARDS_IMPLEMENTATION = stakerRewardsImplementation;
    }

    /**
     * @inheritdoc IDefaultStakerRewardsFactory
     */
    function create(address vault) external returns (address) {
        address stakerRewards =
            STAKER_REWARDS_IMPLEMENTATION.cloneDeterministic(keccak256(abi.encode(totalEntities(), vault)));
        DefaultStakerRewards(stakerRewards).initialize(vault);

        _addEntity(stakerRewards);

        return stakerRewards;
    }
}
