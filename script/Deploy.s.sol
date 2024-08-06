// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import { SafeProxyFactory } from "lib/safe-contracts/contracts/proxies/SafeProxyFactory.sol";
import { Safe } from "lib/safe-contracts/contracts/Safe.sol";
import { CompatibilityFallbackHandler } from "lib/safe-contracts/contracts/handler/CompatibilityFallbackHandler.sol";
import { WaymontSafeFactory } from "../src/WaymontSafeFactory.sol";
import { WaymontSafeExternalSignerFactory } from "../src/WaymontSafeExternalSignerFactory.sol";

import { BaseScript } from "./Base.s.sol";

contract Deploy is BaseScript {
    address public constant POLICY_GUARDIAN_MANAGER = 0x3bC25D139069Ca06f7079fE67dcEd166b40edA9e;

    function run() public broadcast {
        // Deploy SafeProxyFactory and Safe implementation
        SafeProxyFactory safeProxyFactory = new SafeProxyFactory();
        address safeImplementation = address(new Safe());
        CompatibilityFallbackHandler compatibilityFallbackHandler = new CompatibilityFallbackHandler();

        console.log("SafeProxyFactory deployed at:", address(safeProxyFactory));
        console.log("Safe implementation deployed at:", safeImplementation);
        console.log("CompatibilityFallbackHandler deployed at:", address(compatibilityFallbackHandler));

        // Deploy WaymontSafeFactory
        WaymontSafeFactory waymontSafeFactory = new WaymontSafeFactory(POLICY_GUARDIAN_MANAGER);
        console.log("WaymontSafeFactory deployed at:", address(waymontSafeFactory));

        // Get PolicyGuardianSigner address
        address policyGuardianSigner = address(waymontSafeFactory.policyGuardianSigner());
        console.log("PolicyGuardianSigner deployed at:", policyGuardianSigner);

        // Deploy WaymontSafeExternalSignerFactory
        WaymontSafeExternalSignerFactory waymontSafeExternalSignerFactory =
            new WaymontSafeExternalSignerFactory(waymontSafeFactory.policyGuardianSigner());
        console.log("WaymontSafeExternalSignerFactory deployed at:", address(waymontSafeExternalSignerFactory));
    }
}
