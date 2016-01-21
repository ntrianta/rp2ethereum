contract token{function token(uint256 _supply);function sendFunds(address _receiver,string _role,uint256 _amount)returns(bool sufficient);function balanceOf(address )constant returns(uint256 );}

//This contract simulates a civil law case trial.
contract Case{
    
    mapping (address => uint) public collateralOf;

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
    string[] public partyArguments;
    string[] public judgeArguments;
    
    uint jurySize;
    uint benchSize;
    uint jurorJustice;
    uint judgeJustice;
    uint collateralTarget;
    uint collateralRaised;
    
    address public treasurer; 
    address[] public bench;
    address[] public jury;
    
    token public justice; 
    
    Vote[] public votes;
    
    Party public plaintiff;
    Party public defendant;
    
    event caseInitiated(string descritpion);
    event juryVoted(address voter);
    event judgeSpoke(address judge, string argument);
    event partySpoke(address party, string argument);
    event outOfTurn(address party);
    event judgeAdded(address judge);
    event judgeNotAdded(address judge);
    event jurorAdded(address juror);
    event jurorNotAdded(address juror);
    event caseReady();
    event caseNotReady();
    event justiceSent(address receiver);
    event justiceNotSent();
    // event votingClosed();
    // event whoWon();
    
    modifier fullCourt() { 
        if (bench.length == benchSize && jury.length == jurySize && 
        collateralRaised == collateralTarget){ 
            caseReady(); 
            _
        }
        else{
            caseNotReady();
            _
        }
    }

    function Case(address _treasurer, address _plaintiff, address _defendant, 
    string _description, uint _jurySize, uint _benchSize, token _justice, 
    uint _jurorJustice, uint _judgeJustice){
        treasurer = _treasurer;
        plaintiff = Party({addr: _plaintiff, turn: true});
        defendant = Party({addr: _defendant, turn: false});
        description = _description;
        jurySize = _jurySize;
        benchSize = _benchSize;
        jurorJustice = _jurorJustice;
        judgeJustice = _judgeJustice;
        justice = token(_justice);
        collateralTarget = benchSize*judgeJustice + jurySize*jurorJustice;
        caseInitiated(description);
    }
    
    // There are probably better ways to do this and avoid a serial search on 
    // the arrays. Due to lack of proper documentation we will use this 
    // non sophisticated method
    
    function isJudge(address _key) internal constant returns(bool){
         for (uint i = 0; i < bench.length; ++i) {
             if (bench[i] == _key){
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
    
    // Judges can be added only by one of the two opposing parties.
    // There is currently no check to prevent one party adding more judges 
    // than the other.
    function newJudge(address _judge) returns(uint judgeID){
        if(bench.length< benchSize && !isJudge(_judge) 
        && (msg.sender==plaintiff.addr || msg.sender==defendant.addr)){
            judgeID = bench.length++;
            bench[judgeID] = msg.sender;
            collateralOf[msg.sender] = 0;
            judgeAdded(msg.sender);
        }
        else{
            judgeID = 999; //let 999 be our error code
            judgeNotAdded(_judge);
        }
    }
    
    //Jurors add themselves provided that the jury is not full.
    function newJuror() returns(uint jurorID){
        if(jury.length< jurySize && !isJuror(msg.sender)){
            jurorID = jury.length++;
            jury[jurorID] = msg.sender;
            collateralOf[msg.sender] = 0;
            jurorAdded(msg.sender);
        }
        else{
            jurorID = 999; //let 999 be our error code
            jurorNotAdded(msg.sender);
        }
    }
    
    // There is no string comparison implemented in solidity as of yet.
    // We will thas use integer codes to distinguish between the different
    // court roles when distributing 'justice'.
    function distributeJustice(address _receiver, uint _role) returns(bool success){
        if(msg.sender==treasurer && collateralOf[_receiver]>0){
            if (_role == 1){
                justice.sendFunds(_receiver, "jurror", jurorJustice);
            }
            else if(_role == 2){
                justice.sendFunds(_receiver, "judge", judgeJustice);
            }
            success = true;
            justiceSent(_receiver);
        }
        else{
            success = false;
            justiceNotSent();
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
        if (isJudge(msg.sender) && justice.balanceOf(msg.sender)>0){
            judgeSpoke(msg.sender, _argument);
            success = true;
        }
        else{
            success = false; 
        }
    }
  
    function juryVote(uint _vote) returns(bool success){
        if (isJuror(msg.sender) && justice.balanceOf(msg.sender)>0){
            votes[votes.length++] = Vote({voter:msg.sender, party: _vote});
            juryVoted(msg.sender);
            success = true;
        }
        else{
            success = false;
        }
    }
    
    function collectCollateral(){
        uint amount = msg.value;
        collateralRaised += amount;
        collateralOf[msg.sender] += amount;
    }
    // function caseClosed(){}
}



