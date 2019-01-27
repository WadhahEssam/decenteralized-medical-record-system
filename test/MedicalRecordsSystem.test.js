const Web3 = require('web3');
const ganache = require('ganache-cli');
const assert = require('assert');
const compiledContracts = require('../compile');

const provider = ganache.provider();
const web3 = new Web3();
web3.setProvider(provider);

console.log(web3);

let accounts, medicalRecordSystemContract;
let ministryOfHelath, hospitalOne, hospitalTwo, pharmacyOne, pharmacyTwo;

before( async () => {
  accounts = await web3.eth.getAccounts();
  ministryOfHelath = accounts[0];
  hospitalOne = accounts[1];
  hospitalTwo = accounts[2];
  pharmacyOne = accounts[3];
  pharmacyTwo = accounts[4];
  medicalRecordSystemContract = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: bytecode, arguments: [] })
    .send({ from: deployer, gas:'1000000' });
  medicalRecordSystemContract.setProvider(provider);
});

describe('MedicalRecordSystem Contract', async () => {

  it('is deployed and has address', async () => {
    assert.notEqual('1','0101');
  });

}); 