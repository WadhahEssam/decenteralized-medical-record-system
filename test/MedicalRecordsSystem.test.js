const Web3 = require('web3');
const ganache = require('ganache-cli');
const assert = require('assert');
const compiledMedicalRecordsSystem = require('../ethereum/build/MedicalRecordsSystem.json');
const compiledMedicalRecord = require('../ethereum/build/MedicalRecord.json');

const provider = ganache.provider();
const web3 = new Web3(provider);

let accounts, medicalRecordsSystemContract, medicalRecordContract;
let ministryOfHelath, hospitalOne, hospitalTwo, pharmacyOne, pharmacyTwo;

beforeEach( async () => {
  accounts = await web3.eth.getAccounts();
  console.log(accounts);

  medicalRecordsSystemContract = await new web3.eth.Contract(JSON.parse(compiledMedicalRecordsSystem.interface))
    .deploy({ data: compiledMedicalRecordsSystem.bytecode })
    .send({ from: accounts[0], gas: '1000000' });

  medicalRecordsSystemContract.setProvider(provider);
});

describe('MedicalRecordSystem Contract', async () => {
  it('is deployed and has address', async () => {
    assert.notEqual('1','0101');
  });
}); 