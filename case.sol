contract justice{function justice(uint256 _supply);function justiceBalance(address )constant returns(uint256 );function sendJustice(address _receiver,string _role,uint256 _amount)returns(bool sufficient);}

contract Case{
    
    string public description;
    
    uint juryNum;
    uint judgesNum;
    uint jurorJus;
    uint judgeJus;
    
    address public party1;
    address public party2; 
    address public treasurer; 
    address[] public judges;
    address[] public jury;
    
    justice public internalJustice; 
    
    event juryVoted(address voter);
    event judgeSpoke(address judge, string argument);
    //event partySpoke();
    //event votingClosed();
    //event whoWon();
    
    struct Vote{
        address voter;
        uint party;
    }
    
    Vote[] public votes;
    
    function Case(address _treasurer, string _description, uint _juryNum, uint _judgesNum, justice _internalJustice, uint _jurorJus, uint _judgeJus){
        treasurer = _treasurer;
        description = _description;
        juryNum = _juryNum;
        judgesNum = _judgesNum;
        jurorJus = _jurorJus;
        judgeJus = _judgeJus;
        internalJustice = justice(_internalJustice);
    }
    
    // There are probably better ways to do this and avoid a serial search on 
    // the arrays. Due to lack of proper documentation we will use this 
    // non sophisticated method
    
    function isJudge(address _key) internal constant returns(bool){
         for (uint i = 0; i < judges.length; ++i) {
             if (judges[i] == _key){
                 return true;
             }
         }
         return false; 
    }
    
    function isJuror(address _key) internal constant returns(bool){
         for (uint i = 0; i < jury.length; ++i) {
             if (jury[i] == _key){
                 return true;
             }
         }
         return false; 
    }
    
    function juryVote(uint _vote) returns(bool success){
        if (isJuror(msg.sender) && internalJustice.justiceBalance(msg.sender)>0){
            votes[votes.length++] = Vote({voter:msg.sender, party: _vote});
            juryVoted(msg.sender);
            success = true;
        }
        else{
            success = false;
        }
    }
    
    function judgeSpeak(string _argument) returns(bool success){
        if (isJudge(msg.sender) && internalJustice.justiceBalance(msg.sender)>0){
            judgeSpoke(msg.sender, _argument);
            success = true;
        }
        else{
            success = false; 
        }
    }
    
    // There is no string comparison implemented in solidity as of yet.
    // We will thas use integer codes to distinguish between the different
    // court roles when distributing 'justice'.
    
    function distributeJustice(address _receiver, uint _role) returns(bool success){
        if (msg.sender==treasurer){
            if (_role == 1){
                internalJustice.sendJustice(_receiver, "jurror", jurorJus);
            }
            else if(_role == 2){
                internalJustice.sendJustice(_receiver, "judge", judgeJus);
            }
            success = true;
        }
        else{
            success = false;
        }
    }
  
  // function caseClosed(){}
  // function partySpeak(){}
  // function collectCollateral(){}
    
}
