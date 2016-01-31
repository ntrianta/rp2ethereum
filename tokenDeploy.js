var _supply = 1000 ;
var tokenContract = web3.eth.contract([{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"_sender","type":"address"},{"name":"_receiver","type":"address"},{"name":"_amount","type":"uint256"}],"name":"sendFunds","outputs":[{"name":"sufficient","type":"bool"}],"type":"function"},{"inputs":[{"name":"_supply","type":"uint256"}],"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"sender","type":"address"},{"indexed":false,"name":"receiver","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"fundsTransfered","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"sender","type":"address"},{"indexed":false,"name":"receiver","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"fundsNotTransfered","type":"event"}]);
var token = tokenContract.new(
   _supply,
   {
     from: web3.eth.accounts[0], 
     data: '60606040526040516020806102de833981016040528080519060200190919050505b80600060005060003373ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600050819055505b50610279806100656000396000f360606040526000357c01000000000000000000000000000000000000000000000000000000009004806370a0823114610044578063e0ca14741461007057610042565b005b61005a60048080359060200190919050506100ae565b6040518082815260200191505060405180910390f35b61009860048080359060200190919080359060200190919080359060200190919050506100c9565b6040518082815260200191505060405180910390f35b60006000506020528060005260406000206000915090505481565b600081600060005060008673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060005054101561017e5760009050610272567fd6b2be61b35f3134aa21e4731525aaf2ba5bc836bca6af2472d45c684755fbea848484604051808473ffffffffffffffffffffffffffffffffffffffff1681526020018373ffffffffffffffffffffffffffffffffffffffff168152602001828152602001935050505060405180910390a15b81600060005060008673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282825054039250508190555081600060005060008573ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828282505401925050819055507f0c46318b49f468ef24c1103d79c7f2ed5caf9b4f70dc246716430f4fae7220b1848484604051808473ffffffffffffffffffffffffffffffffffffffff1681526020018373ffffffffffffffffffffffffffffffffffffffff168152602001828152602001935050505060405180910390a160019050610272565b939250505056', 
     gas: 3000000
   }, function(e, contract){
    console.log(e, contract);
    if (typeof contract.address != 'undefined') {
         console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
 })
