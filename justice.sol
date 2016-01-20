contract justice { 
    
   mapping (address => uint) public justiceBalance;
   
   event justiceSent(address receiver, string role, uint amount);

   function justice(uint _supply) {
        justiceBalance[msg.sender] = _supply;
    }

   function sendJustice(address _receiver, string _role, uint _amount) returns(bool sufficient) {
        if (justiceBalance[msg.sender] < _amount) {
            return false;
        }
        justiceBalance[msg.sender] -= _amount;
        justiceBalance[_receiver] += _amount;
        justiceSent(_receiver, _role, _amount);
        return true;
    }
}
