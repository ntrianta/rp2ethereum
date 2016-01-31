name = "treasurer"
registrar.reserve.sendTransaction(name, {from:primary})
registrar.setAddress.sendTransaction (name, eth.accounts[0], true, {from: primary})
name = "plaintiff"
registrar.reserve.sendTransaction(name, {from:primary})
registrar.setAddress.sendTransaction (name, eth.accounts[1], true, {from: primary})
name = "defendant"
registrar.reserve.sendTransaction(name, {from:primary})
registrar.setAddress.sendTransaction (name, eth.accounts[2], true, {from: primary})
name = "judge1"
registrar.reserve.sendTransaction(name, {from:primary})
registrar.setAddress.sendTransaction (name, eth.accounts[3], true, {from: primary})
name = "judge2"
registrar.reserve.sendTransaction(name, {from:primary})
registrar.setAddress.sendTransaction (name, eth.accounts[4], true, {from: primary})
name = "juror1"
registrar.reserve.sendTransaction(name, {from:primary})
registrar.setAddress.sendTransaction (name, eth.accounts[5], true, {from: primary})
name = "juror2"
registrar.reserve.sendTransaction(name, {from:primary})
registrar.setAddress.sendTransaction (name, eth.accounts[6], true, {from: primary})
name = "juror3"
registrar.reserve.sendTransaction(name, {from:primary})
registrar.setAddress.sendTransaction (name, eth.accounts[7], true, {from: primary})
