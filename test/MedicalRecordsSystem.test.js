const Web3 = require('web3');
const ganache = require('ganache-cli');
const assert = require('assert');
const { interface, bytecode } = require('../compile');

const web3 = new Web3(ganache.provider());

let accounts, lotteryContract;
let deployer, player1, player2, player3, player4;
let player1InitialBalance, player2InitialBalance, player3InitialBalance ;
let player1FinalBalance, player2FinalBalance, player3FinalBalance ;
const player1Amount = web3.utils.toWei('0.02', 'ether');
const player2Amount = web3.utils.toWei('0.04', 'ether');
const player3Amount = web3.utils.toWei('0.1', 'ether');
const player4Amount = web3.utils.toWei('0.009', 'ether');
const totalWeiSent = parseInt(player1Amount) +parseInt(player2Amount) + parseInt(player3Amount);

before( async () => {
  accounts = await web3.eth.getAccounts();
  deployer = accounts[0];
  player1 = accounts[1];
  player2 = accounts[2];
  player3 = accounts[3];
  player4 = accounts[4];
  lotteryContract = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: bytecode, arguments: [] })
    .send({ from: deployer, gas:'1000000' });
});

describe('Lottery Contract', () => {

  it('is deployed and has address', async () => {
    assert.ok(lotteryContract.options.address);
  });

  it('has deployer account as the manager', async () => {
    const manager = await lotteryContract.methods.manager().call();
    assert.equal(deployer, manager);
  });

  it('allows player1 to participate', async () => {
    // getBalance function can be called on account or could be also called on account or could be called on contract too
    player1InitialBalance = await web3.eth.getBalance(player1);
    await lotteryContract.methods.enter().send({ from: player1, value: player1Amount });
    const contractPlayer1 = await lotteryContract.methods.players(0).call();
    assert.equal(player1, contractPlayer1);
  });

  it('allows player2 to participate', async () => {
    player2InitialBalance = await web3.eth.getBalance(player2);
    await lotteryContract.methods.enter().send({ from: player2, value: player2Amount });
    const contractPlayer2 = await lotteryContract.methods.players(1).call();
    assert.equal(player2, contractPlayer2);
  });

  it('allows player3 to participate', async () => {
    player3InitialBalance = await web3.eth.getBalance(player3);
    await lotteryContract.methods.enter().send({ from: player3, value: player3Amount });
    const contractPlayer3 = await lotteryContract.methods.players(2).call();
    assert.equal(player3, contractPlayer3);
  });

  it('prevents player from entering if he has less than 0.1 ether', async () => {
    try {
      await lotteryContract.methods.enter().send({ from: player4, value: player4Amount });
      // if the statement didn't throw error the test should fail. 
      assert(false);
    } catch (error) {
       assert(error);
    }
  });

  it('has three players', async () => {
    const numberOfPlayers = await lotteryContract.methods.getNumberOfPlayers().call();
    assert.equal(3, numberOfPlayers);
  });

  it('has right amount of wei from all players', async () => {
    const weiAmountInContract = await lotteryContract.methods.getAvailableWei().call();
    assert.equal(totalWeiSent, parseInt(weiAmountInContract));
  });

  it('prevent normal user from picking a winnner', async () => {
    try {
      await lotteryContract.methods.pickWinner().send({ from: player1 });
      assert(false);
    } catch (error) {
      assert(error);
    }
  });

  it('allows manger to pick a winner', async () => {
    await lotteryContract.methods.pickWinner().send({ from: deployer });
    player1FinalBalance = await web3.eth.getBalance(player1);
    player2FinalBalance = await web3.eth.getBalance(player2);
    player3FinalBalance = await web3.eth.getBalance(player3);
    assert(true);
  });

  it('sends the winner his prize', async () => {
    const player1Balance = await web3.eth.getBalance(player1);
    assert( player1FinalBalance > player1InitialBalance || player2FinalBalance > player2InitialBalance || player3FinalBalance > player3InitialBalance );
  });

  it('should reset the contract', async () => {
    const numberOfPlayers = await lotteryContract.methods.getNumberOfPlayers().call();
    assert.equal(0, numberOfPlayers);
    const weiAmountInContract = await lotteryContract.methods.getAvailableWei().call();
    assert.equal(0, parseInt(weiAmountInContract));
  });

}); 