contract justice{function justice(uint256 _supply);function justiceBalance(address )constant returns(uint256 );function sendJustice(address _receiver,string _role,uint256 _amount)returns(bool sufficient);}

contract Case{
    
    struct Vote{
        address voter;
        uint party;
    }
    
    struct Party{
        address addr;
        bool turn;
    }
    
    string public description;
    string public turn; 
    
    uint juryNum;
    uint judgesNum;
    uint jurorJus;
    uint judgeJus;
    
    address public treasurer; 
    address[] public judges;
    address[] public jury;
    
    justice public internalJustice; 
    
    Vote[] public votes;
    
    Party public plaintiff;
    Party public defendant;
    
    event caseInitiated(string descritpion);
    event juryVoted(address voter);
    event judgeSpoke(address judge, string argument);
    event partySpoke(address party, string argument);
    event outOfTurn(address party);
    //event votingClosed();
    //event whoWon();
    
    function Case(address _treasurer, address _plaintiff, address _defendant, string _description, uint _juryNum, uint _judgesNum, justice _internalJustice, uint _jurorJus, uint _judgeJus){
        treasurer = _treasurer;
        plaintiff = Party({addr: _plaintiff, turn: true});
        defendant = Party({addr: _defendant, turn: false});
        description = _description;
        juryNum = _juryNum;
        judgesNum = _judgesNum;
        jurorJus = _jurorJus;
        judgeJus = _judgeJus;
        internalJustice = justice(_internalJustice);
        caseInitiated(description);
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
    
    function toggleTurn() internal{
        plaintiff.turn = !plaintiff.turn;
        defendant.turn = !defendant.turn;
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
    
    function partySpeak(string _argument){
        if ((msg.sender == plaintiff.addr && plaintiff.turn) || (msg.sender == defendant.addr && defendant.turn)){
            toggleTurn();
            partySpoke(msg.sender, _argument);
        }
        else{
            outOfTurn(msg.sender);
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
    
  // function caseClosed(){}
  // function collectCollateral(){}
  
}
