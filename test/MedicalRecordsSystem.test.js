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

beforeEach( async () => {
  accounts = await web3.eth.getAccounts();
  ministryOfHelath = accounts[0];
  hospitalOne = accounts[1];
  hospitalTwo = accounts[2];
  pharmacyOne = accounts[3];
  pharmacyTwo = accounts[4];

  medicalRecordsSystemContract = await new web3.eth.Contract(JSON.parse(compiledMedicalRecordsSystem.interface))
    .deploy({ data: compiledMedicalRecordsSystem.bytecode })
    .send({ from: ministryOfHelath, gas: '2000000' });
});

describe('MedicalRecordSystem Contract', async () => {
  it('is deployed and has address', async () => {
    assert.ok(medicalRecordsSystemContract.options.address);
  });

  it('can add hospitals by the ministry of health', async () => {
    await medicalRecordsSystemContract.methods.addHospital(hospitalOne).send({ from: ministryOfHelath, gas: '1000000' });
    assert.equal(await medicalRecordsSystemContract.methods.hospitalAddresses(hospitalOne).call(), true);
  });

  it('can add pharmacies by the ministry of health', async () => {
    await medicalRecordsSystemContract.methods.addPharmacy(pharmacyOne).send({ from: ministryOfHelath, gas: '1000000' });
    assert.equal(await medicalRecordsSystemContract.methods.pharmacyAddresses(pharmacyOne).call(), true);
  });

  it('creates a medical record by hospitals', async () => {
    // add the hospital
    await medicalRecordsSystemContract.methods.addHospital(hospitalOne).send({ from: ministryOfHelath, gas: '1000000' });
    assert.equal(await medicalRecordsSystemContract.methods.hospitalAddresses(hospitalOne).call(), true);
    // create medical record
    await medicalRecordsSystemContract.methods.createMedicalRecord(435108270, 'Wadhah Essam', '9871634389', '0551292881', 'male', 'o+', '044239448').send({ from: hospitalOne, gas: '1000000' });
    let checkMedicalRecord = await medicalRecordsSystemContract.methods.checkMedicalRecord(435108270).call();
    assert.equal(checkMedicalRecord, true);
  });

  it('can return the address of the medical record', async () => {
    // add the hospital
    await medicalRecordsSystemContract.methods.addHospital(hospitalOne).send({ from: ministryOfHelath, gas: '1000000' });
    assert.equal(true, await medicalRecordsSystemContract.methods.hospitalAddresses(hospitalOne).call());
    // create medical record
    await medicalRecordsSystemContract.methods.createMedicalRecord(425990389, 'Mohammed', '9871634389', '0551292881', 'male', 'o+', '044239448').send({ from: hospitalOne, gas: '1000000' });
    let medicalRecordAddress = await medicalRecordsSystemContract.methods.getMedicalRecord(425990389).call();
    let newMedicalRecordsSystemContract = await new web3.eth.Contract(
      JSON.parse(compiledMedicalRecord.interface), 
      medicalRecordAddress
    ); 
    assert.equal(await newMedicalRecordsSystemContract.methods.name().call(), 'Mohammed');
    assert.equal(await newMedicalRecordsSystemContract.methods.date().call(), '9871634389');
    assert.equal(await newMedicalRecordsSystemContract.methods.phoneNumber().call(), '0551292881');
    assert.equal(await newMedicalRecordsSystemContract.methods.gender().call(), 'male');
    assert.equal(await newMedicalRecordsSystemContract.methods.bloodType().call(), 'o+');
    assert.equal(await newMedicalRecordsSystemContract.methods.emergencyContacts(0).call(), '044239448');
  });
}); 