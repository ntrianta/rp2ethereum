primary = eth.accounts[0];
globalRegistrarTxHash = admin.setGlobalRegistrar("0x0");
globalRegistrarTxHash = admin.setGlobalRegistrar("", primary);
miner.start(4); admin.sleepBlocks(1); miner.stop();
globalRegistrarAddr = eth.getTransactionReceipt(globalRegistrarTxHash).contractAddress;
admin.setGlobalRegistrar(globalRegistrarAddr);
registrar = GlobalRegistrar.at(globalRegistrarAddr);
