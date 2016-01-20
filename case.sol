contract Case{
    
    string public description;
    
    uint juryNum;
    uint judgesNum;
    
    address public party1;
    address public party2; 
    address public treasurer; 
    address[] public judges;
    address[] public jury;
    
    event juryVoted();
    event judgeSpoke();
    event partySpoke();
    event votingClosed();
    event whoWon();
    
    // There probably exist better ways to do this and avoid a serial search on 
    // the arrays. Due to lack of proper documentation we will use this 
    // usoffisticated method
    
    function isJudge(address _key) internal constant returns(bool){
         for (uint i = 0; i < judges.length; ++i) {
             if (judges[i] == _key){
                 return true;
             }
         }
         return false; 
    }
    function isJury(address _key) internal constant returns(bool){
         for (uint i = 0; i < jury.length; ++i) {
             if (jury[i] == _key){
                 return true;
             }
         }
         return false; 
    }
    
    function Case(address _treasurer, string _description, uint _juryNum, uint _judgesNum){
        treasurer = _treasurer;
        description = _description;
        juryNum = _juryNum;
        judgesNum = _judgesNum;
    }
    
    function caseClosed(){}
    function juryVote(){}
    function judgeSpeak(){}
    function partySpeak(){}
    function collectCollateral(){}   
}
