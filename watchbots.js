var caseInitiated = myCase2.caseInitiated({}, '', function(error, result){
  if (!error)
    console.log("New case with description: " + result.args.description)
});

var juryVoted = myCase2.juryVoted({}, '', function(error, result){
  if (!error)
    console.log("Juror " + result.args.voter + " just voted")
});

var judgeSpoke = myCase2.judgeSpoke({}, '', function(error, result){
  if (!error)


    console.log("Judge " + result.args.judge + " says " + result.args.argument)
});

var judgeMute = myCase2.judgeMute({}, '', function(error, result){
  if (!error)
    console.log("Judge " + result.args.judge + " cannot speak")
});

var partySpoke = myCase2.partySpoke({}, '', function(error, result){
  if (!error)
    console.log("Party " + result.args.party + " says " + result.args.argument)
});

var outOfTurn = myCase2.outOfTurn({}, '', function(error, result){
  if (!error)
    console.log("Party " + result.args.party + " tries to speak out of turn")
});

var judgeAdded = myCase2.judgeAdded({}, '', function(error, result){
  if (!error)
    console.log("New judge  " + result.args.judge + " added")
});

var judgeNotAdded = myCase2.judgeNotAdded({}, '', function(error, result){
  if (!error)
    console.log("New judge  " + result.args.judge + " could not be added. Either added before, bench full, or insufficient rights")
});

var jurorAdded = myCase2.jurorAdded({}, '', function(error, result){
  if (!error)
    console.log("New juror  " + result.args.juror + " added")
});

var judgeNotAdded = myCase2.jurorNotAdded({}, '', function(error, result){
  if (!error)
    console.log("New juror  " + result.args.judge + " could not be added. Either added before or jury full")
});

var justiceSent = myCase2.justiceSent({}, '', function(error, result){
  if (!error)
    console.log(result.args.amount + " Justice " + " sent to" + result.args.receiver)
});

var justiceNotSent = myCase2.justiceNotSent({}, '', function(error, result){
  if (!error)
    console.log(result.args.amount + " Justice " + " could not be sent to" + result.args.receiver + ". Collateral not collected")
});

var caseReady = myCase2.caseReady({}, '', function(error, result){
  if (!error)
    console.log("Trial is ready to start. DEBATE!")
});

var caseNotReady = myCase2.caseNotReady({}, '', function(error, result){
  if (!error)
    console.log("Debating is not ready to start yet")
});

var debateClosed = myCase2.debateClosed({}, '', function(error, result){
  if (!error)
    console.log("Debating has concluded. Please proceed to voting")
});

var debateOngoing = myCase2.debateOngoing({}, '', function(error, result){
  if (!error)
    console.log("Debating is still on going. Cannot vote yet.")
});

var votingClosed = myCase2.votingClosed({}, '', function(error, result){
  if (!error)
    console.log("Voting has concluded. Let's count the votes")
});

var votingOngoing = myCase2.votingOngoing({}, '', function(error, result){
  if (!error)
    console.log("Voting is in process. No result yet")
});

var plaintiffWon = myCase2.plaintiffWon({}, '', function(error, result){
  if (!error)
    console.log("plaintiff " + result.args.plaintiff + " has won the case!")
});

var defendantWon = myCase2.defendantWon({}, '', function(error, result){
  if (!error)
    console.log("defendant " + result.args.defendant + " has won the case!")
});

var tied = myCase2.tied({}, '', function(error, result){
  if (!error)
    console.log("Result is a tie! Not possible!")
});
