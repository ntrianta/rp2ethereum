primary = eth.accounts[0];
globalRegistrarTxHash = admin.setGlobalRegistrar("0x0");
globalRegistrarTxHash = admin.setGlobalRegistrar("", primary);
globalRegistrarAddr = eth.getTransactionReceipt(globalRegistrarTxHash).contractAddress;
admin.setGlobalRegistrar(globalRegistrarAddr);
registrar = GlobalRegistrar.at(globalRegistrarAddr);
