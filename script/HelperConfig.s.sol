// SPDX-License-Identifier: MIT

// Deploy mocks when we are on a local ancul chain
// keep track of contract address across different chains
//Sepolia ETH/USD

//Mainnet ETH/USD

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address pricefeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepliaEthConfig();
        } else {
            activeNetworkConfig = getorCreateAnvilEthConfig();
        }
    }

    function getSepliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getorCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.pricefeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            pricefeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}