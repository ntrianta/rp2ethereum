contract token{function token(uint256 _supply);function balanceOf(address )constant returns(uint256 );function sendFunds(address _sender,address _receiver,uint256 _amount)returns(bool sufficient);}

// This contract simulates a civil law case trial.
// LIMITATIONS & CAVEATS:
// 1. Token contract instance has to be initiated by treasurer
// 2. Any amount can be set as collateral for now. 
// 3. There is currently no check to prevent one party 
//    adding more judges than the other.
// 4. No check in place if all parties have enough justice before 
//    the start of the trial. 
// 5. Anyone can tamper with the justice balance of another entity. 
//    Justice balance is not a locked wallet.  
// 6. The concept of a justice token is rather moot at the current implementation
//    since it is just passed back and forth and is not actually necessary for 
//    controls implementation. 
// 7. There is no control to check if the votes are valid.
// 8. No check when adding new roles if sender is already an other role

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
    
    uint public jurySize;
    uint public benchSize;
    uint public jurorJustice;
    uint public judgeJustice;
    uint public partyJustice;
    uint public debateRounds;
    uint public currentRound;
    uint public collateralTarget;
    uint public collateralRaised;
    uint public plaintiffVotes;
    uint public defendantVotes;
    
    address public treasurer; 
    address public winner;
    address[] public bench;
    address[] public jury;
    
    token public justice; 
    
    Vote[] public votes;
    
    Party public plaintiff;
    Party public defendant;
    
    event caseInitiated(string descritpion);
    event juryVoted(address voter);
    event judgeSpoke(address judge, string argument);
    event judgeMute(address party);
    event partySpoke(address party, string argument);
    event outOfTurn(address party);
    event judgeAdded(address judge);
    event judgeNotAdded(address judge);
    event jurorAdded(address juror);
    event jurorNotAdded(address juror);
    event justiceSent(address receiver, uint amount);
    event justiceNotSent(address receiver, uint amount);
    event caseReady();
    event caseNotReady();
    event debateClosed();
    event debateOngoing();
    event votingClosed();
    event votingOngoing();
    event plaintiffWon(address plaintiff);
    event defendantWon(address defendant);
    event tied();
    
    modifier fullCourt() { 
        if (bench.length == benchSize && jury.length == jurySize && 
            collateralRaised == collateralTarget 
            /*&& justice.balanceOf(treasurer)==0 */){ 
            caseReady(); 
            _
        }
        else{
            caseNotReady();
            _
        }
    }
    
    modifier debateEnd() {
        if (debateRounds==currentRound){ 
            debateClosed();
            _
        }
        else{
            debateOngoing();
            _
        }
    }
    
    modifier voteEnd() { 
        if (votes.length == jurySize){ 
            votingClosed(); 
            _
        }
        else{
            votingOngoing();
            _
        }
    }
    
    function Case(address _treasurer, address _plaintiff, address _defendant, 
    string _description, uint _jurySize, uint _benchSize, token _justice, 
    uint _jurorJustice, uint _judgeJustice, uint _debateRounds, uint _partyJustice){
        treasurer = _treasurer;
        plaintiff = Party({addr: _plaintiff, turn: true});
        defendant = Party({addr: _defendant, turn: false});
        description = _description;
        jurySize = _jurySize;
        benchSize = _benchSize;
        jurorJustice = _jurorJustice;
        judgeJustice = _judgeJustice;
        justice = token(_justice);
        debateRounds = _debateRounds;
        currentRound = 0;
        collateralTarget = benchSize*judgeJustice + jurySize*jurorJustice;
        plaintiffVotes = 0;
        defendantVotes = 0;
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
    
    function isParty(address _key) internal constant returns(bool){
         if(plaintiff.addr==_key || defendant.addr==_key){
             return true;
         }
         return false; 
    }
    
    function toggleTurn() internal{
        plaintiff.turn = !plaintiff.turn;
        defendant.turn = !defendant.turn;
    }
    
    // Judges can be added only by one of the two opposing parties.
    function newJudge(address _judge) returns(uint judgeID){
        if(bench.length< benchSize && !isJudge(_judge) && 
        (msg.sender==plaintiff.addr || msg.sender==defendant.addr)){
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
    
    // Every entity in the court must request the amount of justice allocated to
    // their role.
    function requestJustice() returns(bool success){
        uint amount = msg.value;
        collateralRaised += amount;
        collateralOf[msg.sender] += amount;
        if(collateralOf[msg.sender]>0 && isJuror(msg.sender)){
            treasurer.send(amount);
            justice.sendFunds(treasurer, msg.sender, jurorJustice);
            success = true;
            justiceSent(msg.sender, jurorJustice);
        }
        else if(collateralOf[msg.sender]>0 && isJudge(msg.sender)){
            treasurer.send(amount);
            justice.sendFunds(treasurer, msg.sender, judgeJustice);
            success = true;
            justiceSent(msg.sender, judgeJustice);
        }
        else if(isParty(msg.sender)){
            justice.sendFunds(treasurer, msg.sender, judgeJustice);
            success = true;
            justiceSent(msg.sender, judgeJustice);
        }
        else{
            success = false;
            justiceNotSent(msg.sender, judgeJustice);
        }
    }
    
    function partySpeak(string _argument) fullCourt returns(bool success){
        if (((msg.sender == plaintiff.addr && plaintiff.turn) ||
             (msg.sender == defendant.addr && defendant.turn)
            ) && justice.balanceOf(msg.sender)>0 && currentRound<debateRounds){
            toggleTurn();
            justice.sendFunds(msg.sender, treasurer, 1);
            currentRound++;
            partySpoke(msg.sender, _argument);
            success = true;
        }
        else{
            outOfTurn(msg.sender);
            success = false; 
        }
    }
    
    function judgeSpeak(string _argument) fullCourt returns(bool success){
        if (isJudge(msg.sender) && justice.balanceOf(msg.sender)>0){
            justice.sendFunds(msg.sender, treasurer, 1);
            judgeSpoke(msg.sender, _argument);
            success = true;
        }
        else{
            success = false; 
        }
    }
    
    function juryVote(uint _vote) debateEnd returns(bool success){
        if (isJuror(msg.sender) && justice.balanceOf(msg.sender)>0){
            votes[votes.length++] = Vote({voter:msg.sender, party: _vote});
            justice.sendFunds(msg.sender, treasurer, 1);
            juryVoted(msg.sender);
            success = true;
        }
        else{
            success = false;
        }
    }
    
    function caseClosed() voteEnd returns(address winner){
        for (uint i = 0; i < votes.length; ++i) {
            if (votes[i].party == 1){
                plaintiffVotes++;
            }
            else{
                defendantVotes++;
            }
        }
        if (plaintiffVotes>defendantVotes){
            winner = plaintiff.addr;
            plaintiffWon(winner);
        }
        else if (plaintiffVotes<defendantVotes){
            winner = defendant.addr;
            defendantWon(winner);
        }
        else{
            tied();
        }
    }
}
