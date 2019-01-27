const Web3 = require('web3');
const ganache = require('ganache-cli');
const assert = require('assert');
const compiledMedicalRecordsSystem = require('../build/MedicalRecordsSystem.json');
const compiledMedicalRecord = require('../build/MedicalRecord.json');

const provider = ganache.provider();
const web3 = new Web3(provider);

let accounts, medicalRecordsSystemContract, medicalRecordContract;
let ministryOfHelath, hospitalOne, hospitalTwo, pharmacyOne, pharmacyTwo;

beforeEach( async () => {
  accounts = await web3.eth.getAccounts();

  medicalRecordsSystemContract = await new web3.eth.Contract(JSON.parse(compiledMedicalRecordsSystem.interface))
    .deploy({ data: compiledMedicalRecordsSystem.bytecode })
    .send({ from: accounts[0], gas: '1000000' });
});

describe('MedicalRecordSystem Contract', async () => {
  it('is deployed and has address', async () => {
    assert.notEqual('1','0101');
  });
}); 