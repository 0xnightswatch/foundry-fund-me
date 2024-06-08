// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    NetwrokCofig public activeNetworkConfig;

    struct NetwrokCofig {
        address priceFeed;
    }

    constructor () {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1){
            activeNetworkConfig = getEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }
    function getSepoliaEthConfig() public pure returns(NetwrokCofig memory) {
        NetwrokCofig memory sepoliaConfig = NetwrokCofig({priceFeed:0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43});
        return sepoliaConfig;
    }   

    function getEthConfig() public pure returns(NetwrokCofig memory) {
        NetwrokCofig memory ethConfig = NetwrokCofig({priceFeed:0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ethConfig;
    }

    function getOrCreateAnvilEthConfig() public returns(NetwrokCofig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
        NetwrokCofig memory anvilConfig = NetwrokCofig({priceFeed:address(mockPriceFeed) });
        return anvilConfig;
    }
}