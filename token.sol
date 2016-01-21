contract token { 
    
   mapping (address => uint) public balance;
   
   event fundsTransfered(address sender, address receiver, uint amount);

   function token(uint _supply) {
        balance[msg.sender] = _supply;
    }

   function sendFunds(address _receiver, string _role, uint _amount) returns(bool sufficient) {
        if (balance[msg.sender] < _amount) {
            return false;
        }
        balance[msg.sender] -= _amount;
        balance[_receiver] += _amount;
        fundsTransfered(msg.sender, _receiver, _amount);
        return true;
    }
}
