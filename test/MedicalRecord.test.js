const Web3 = require('web3');
const ganache = require('ganache-cli');
const assert = require('assert');
const compiledMedicalRecordsSystem = require('../build/MedicalRecordsSystem.json');
const compiledMedicalRecord = require('../build/MedicalRecord.json');

// const provider = ganache.provider();
// const web3 = new Web3(provider);
var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));

let accounts, medicalRecordsSystemContract, medicalRecordContract;
let ministryOfHelath, hospitalOne, hospitalTwo, pharmacyOne, pharmacyTwo;

beforeEach(async () => {
  accounts = await web3.eth.getAccounts();
  ministryOfHelath = accounts[0];
  hospitalOne = accounts[1];
  hospitalTwo = accounts[2];
  pharmacyOne = accounts[3];
  pharmacyTwo = accounts[4];

  medicalRecordsSystemContract = await new web3.eth.Contract(JSON.parse(compiledMedicalRecordsSystem.interface))
    .deploy({ data: compiledMedicalRecordsSystem.bytecode })
    .send({ from: ministryOfHelath, gas: '30000000' });

  await medicalRecordsSystemContract.methods.addHospital(hospitalOne, 'king khaled hospital').send({ from: ministryOfHelath, gas: '200000000' });
  await medicalRecordsSystemContract.methods.createMedicalRecord(425990389, 'Mohammed', 9871634389, '0551292881', 'male', 'o+', '044239448').send({ from: hospitalOne, gas: '200000000' });
  let medicalRecordAddress = await medicalRecordsSystemContract.methods.getMedicalRecord(425990389).call();
  medicalRecordContract = await new web3.eth.Contract(
    JSON.parse(compiledMedicalRecord.interface),
    medicalRecordAddress
  );
});

describe('MedicalRecord Contract', async () => {
  it('is deployed and has address', async () => {
    assert.ok(medicalRecordContract.options.address);
  });

  it('saves the basic information correctly', async () => {
    assert.equal(await medicalRecordContract.methods.name().call(), 'Mohammed');
    assert.equal(await medicalRecordContract.methods.dateOfBirth().call(), 9871634389);
    assert.equal(await medicalRecordContract.methods.phoneNumber().call(), '0551292881');
    assert.equal(await medicalRecordContract.methods.gender().call(), 'male');
    assert.equal(await medicalRecordContract.methods.bloodType().call(), 'o+');
    assert.equal(await medicalRecordContract.methods.emergencyContacts(0).call(), '044239448');
    assert.equal(await medicalRecordContract.methods.hospitalName().call(), 'king khaled hospital');
  });

  it('adds a new surgery and stores its data correctly', async () => {
    await medicalRecordContract.methods.addSurgery('King Khaled Hospital', 'Open Heart Surgery', 'Dr. Khaled Al Khateeb', 9834754, 8902, 'x298id02zksoi2083kdx', 'cut his stomic').send({ from: hospitalOne, gas: '200000000' });
    let surgery = await medicalRecordContract.methods.surgeries(0).call();
    assert.equal(surgery.hospitalName, 'King Khaled Hospital');
    assert.equal(surgery.surgeryName, 'Open Heart Surgery'); 
    assert.equal(surgery.mainDoctor, 'Dr. Khaled Al Khateeb');
    assert.equal(surgery.date, 9834754);
    assert.equal(surgery.duration, 8902);
    assert.equal(surgery.fileHash, 'x298id02zksoi2083kdx');
    assert.equal(surgery.isCorrectionFor, '');
  });

  it('marks transaction as medical error', async () => {
    await medicalRecordContract.methods.addSurgery('King Khaled Hospital', 'Open Heart Surgery', 'Dr. Khaled Al Khateeb', 9834754, 8902, 'x298id02zksoi2083kdx', 'cut his stomic').send({ from: hospitalOne, gas: '200000000' });
    let surgery = await medicalRecordContract.methods.surgeries(0).call();
    assert.equal(surgery.hospitalName, 'King Khaled Hospital');
    assert.equal(surgery.surgeryName, 'Open Heart Surgery'); 
    assert.equal(surgery.mainDoctor, 'Dr. Khaled Al Khateeb');
    assert.equal(surgery.date, 9834754);
    assert.equal(surgery.duration, 8902);
    assert.equal(surgery.fileHash, 'x298id02zksoi2083kdx');
    assert.equal(surgery.isCorrectionFor, '');

    // marking a surgery transaction as a medical error
    await medicalRecordContract.methods.markTransactionAsMedicalError(1, 1).send({ from: hospitalOne, gas: '200000000' });
    surgery = await medicalRecordContract.methods.surgeries(0).call();
    assert.equal(surgery.isCorrectionFor, 'true');
  });


}); 
