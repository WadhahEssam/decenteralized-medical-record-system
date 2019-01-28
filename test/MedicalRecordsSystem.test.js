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
  ministryOfHelath = accounts[0];
  hospitalOne = accounts[1];
  hospitalTwo = accounts[2];

  medicalRecordsSystemContract = await new web3.eth.Contract(JSON.parse(compiledMedicalRecordsSystem.interface))
    .deploy({ data: compiledMedicalRecordsSystem.bytecode })
    .send({ from: ministryOfHelath, gas: '1000000' });
});

describe('MedicalRecordSystem Contract', async () => {
  it('is deployed and has address', async () => {
    assert.ok(medicalRecordsSystemContract.options.address);
  });

  it('can add hospital by the minisity of healt', async () => {
    await medicalRecordsSystemContract.methods.addHospital(hospitalOne).send({ from: ministryOfHelath, gas: '1000000' });
    const hospitalAddress = await medicalRecordsSystemContract.methods.hospitalAddresses(0).call();
    assert.equal(hospitalOne, hospitalAddress);
  });

  it('creates a medical record contract', async () => {
    await medicalRecordsSystemContract.methods.createMedicalRecord(435108270, 'Wadhah Essam').send({ from: hospitalOne, gas: '1000000' });
    let checkMedicalRecord = await medicalRecordsSystemContract.methods.checkMedicalRecord(435108270).call();
    assert.equal(true, checkMedicalRecord);
  });

  it('can return the address of the medical record', async () => {
    await medicalRecordsSystemContract.methods.createMedicalRecord(435108270, 'Mohammed').send({ from: hospitalOne, gas: '1000000' });
    let medicalRecordAddress = await medicalRecordsSystemContract.methods.getMedicalRecord(435108270).call();
    let newMedicalRecordsSystemContract = await new web3.eth.Contract(
      JSON.parse(compiledMedicalRecord.interface), 
      medicalRecordAddress
    ); 
    let patientName = await newMedicalRecordsSystemContract.methods.name().call();
    assert.equal('Mohammed', patientName);
  });
}); 