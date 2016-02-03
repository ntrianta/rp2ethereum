contract token { 
    
   mapping (address => uint) public balanceOf;
   
   event fundsTransfered(address sender, address receiver, uint amount);
   event fundsNotTransfered(address sender, address receiver, uint amount);

   function token(uint _supply) {
        balanceOf[msg.sender] = _supply;
   }

   function sendFunds(address _sender, address _receiver, uint _amount) returns(bool sufficient) {
        if (balanceOf[_sender] < _amount) {
            return false;
            fundsNotTransfered(_sender, _receiver, _amount);
        }
        balanceOf[_sender] -= _amount;
        balanceOf[_receiver] += _amount;
        fundsTransfered(_sender, _receiver, _amount);
        return true;
    }
}
