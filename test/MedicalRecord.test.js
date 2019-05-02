const Web3 = require('web3');
const ganache = require('ganache-cli');
const assert = require('assert');
const compiledMedicalRecordsSystem = require('../build/MedicalRecordsSystem.json');
const compiledMedicalRecord = require('../build/MedicalRecord.json');

// const provider = ganache.provider();
// const web3 = new Web3(provider);
// var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));
// var web3 = new Web3(new Web3.providers.HttpProvider('http://10.131.192.69:7545'));

let accounts, medicalRecordsSystemContract, medicalRecordContract;
let ministryOfHelath, hospitalOne, hospitalTwo, pharmacyOne, pharmacyTwo;
let drugList = [
  {
    drugName: 'Amoxicilum',
    quantity: 2,
    doctorComment: 'take one bill after lunch every day for one week',
    isDispensed: false,
  },
  {
    drugName: 'anti baiotics',
    quantity: 1,
    doctorComment: 'no comment',
    isDispensed: false,
  },
];
let drugListString = JSON.stringify(drugList);

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
    assert.equal(await medicalRecordContract.methods.surgeriesCount().call(), 0);
    await medicalRecordContract.methods.addSurgery('King Khaled Hospital', 'Open Heart Surgery', 'Dr. Khaled Al Khateeb', 8902, 'x298id02zksoi2083kdx', 'cut his stomic', '').send({ from: hospitalOne, gas: '200000000' });
    let surgery = await medicalRecordContract.methods.surgeries(0).call();
    assert.equal(surgery.hospitalName, 'King Khaled Hospital');
    assert.equal(surgery.surgeryName, 'Open Heart Surgery'); 
    assert.equal(surgery.mainDoctor, 'Dr. Khaled Al Khateeb');
    assert.equal(surgery.duration, 8902);
    assert.equal(surgery.fileHash, 'x298id02zksoi2083kdx');
    assert.equal(surgery.isCorrectionFor, '');
    assert.equal(await medicalRecordContract.methods.surgeriesCount().call(), 1);
  });

  it('adds a new laboratory test', async () => {
    assert.equal(await medicalRecordContract.methods.laboratoryTestsCount().call(), 0);
    await medicalRecordContract.methods.addLaboratoryTest('King Khaled Hospital', 'Mohanned Yahya', 'Blood Test', 'This is a description for the blood test', 'x298id02zksoi2083kdx', '').send({ from: hospitalOne, gas: '200000000' });
    let labTest = await medicalRecordContract.methods.laboratoryTests(0).call();
    assert.equal(labTest.hospitalName, 'King Khaled Hospital');
    assert.equal(labTest.laboratoryWorkerName, 'Mohanned Yahya');
    assert.equal(labTest.testType, 'Blood Test'); 
    assert.equal(labTest.laboratoryTestDescription, 'This is a description for the blood test');
    assert.equal(labTest.testHash, 'x298id02zksoi2083kdx');
    assert.equal(labTest.isCorrectionFor, '');
    assert.equal(await medicalRecordContract.methods.laboratoryTestsCount().call(), 1);
  });

  it('adds a new diagnosis', async () => {
    assert.equal(await medicalRecordContract.methods.diagnosisesCount().call(), 0);
    await medicalRecordContract.methods.addDiagnosis('King Khaled Hospital', 'Dr. Khaled Al Khateeb', 'Breast Cancer', 'x298id02zksoi2083kdx', '').send({ from: hospitalOne, gas: '200000000' });
    let diagnosis = await medicalRecordContract.methods.diagnosises(0).call();
    assert.equal(diagnosis.hospitalName, 'King Khaled Hospital');
    assert.equal(diagnosis.doctorName, 'Dr. Khaled Al Khateeb');
    assert.equal(diagnosis.diognosisDescription, 'Breast Cancer'); 
    assert.equal(diagnosis.fileHash, 'x298id02zksoi2083kdx');
    assert.equal(diagnosis.isCorrectionFor, '');
    assert.equal(await medicalRecordContract.methods.diagnosisesCount().call(), 1);
  });
  
  it('adds a new blood donation', async () => {
    assert.equal(await medicalRecordContract.methods.bloodDonationsCount().call(), 0);
    await medicalRecordContract.methods.addBloodDonation('King Khaled Hospital', 'Dr. Khaled Al Khateeb', 'Red cells', 12, 'x298id02zksoi2083kdx', '').send({ from: hospitalOne, gas: '200000000' });
    let bloodDonation = await medicalRecordContract.methods.bloodDonations(0).call();
    assert.equal(bloodDonation.hospitalName, 'King Khaled Hospital');
    assert.equal(bloodDonation.doctorName, 'Dr. Khaled Al Khateeb');
    assert.equal(bloodDonation.donationType, 'Red cells'); 
    assert.equal(bloodDonation.fileHash, 'x298id02zksoi2083kdx');
    assert.equal(bloodDonation.isCorrectionFor, '');
    assert.equal(await medicalRecordContract.methods.bloodDonationsCount().call(), 1);
  });

  it('adds a new drug prescription', async () => {
    assert.equal(await medicalRecordContract.methods.drugPrescribtionsCount().call(), 0);
    await medicalRecordContract.methods.addDrugPrescribtion('King Khaled Hospital', 'Dr. Khaled Al Khateeb', drugListString, '').send({ from: hospitalOne, gas: '200000000' });
    let drugPrescribtion = await medicalRecordContract.methods.drugPrescribtions(0).call();
    assert.equal(drugPrescribtion.hospitalName, 'King Khaled Hospital');
    assert.equal(drugPrescribtion.doctorName, 'Dr. Khaled Al Khateeb');
    assert.equal(drugPrescribtion.drugList, drugListString); 
    assert.equal(drugPrescribtion.isCorrectionFor, '');
    assert.equal(await medicalRecordContract.methods.drugPrescribtionsCount().call(), 1);
  });

  it('adds a new radiology scan', async () => {
    assert.equal(await medicalRecordContract.methods.radiologiesCount().call(), 0);
    await medicalRecordContract.methods.addRadiology('King Khaled Hospital', 'Dr. Khaled Al Khateeb', 'Chest Scan', 'This is a description for the radiology test','x9812iswoeis321qA','').send({ from: hospitalOne, gas: '200000000' });
    let radiology = await medicalRecordContract.methods.radiologies(0).call();
    assert.equal(radiology.hospitalName, 'King Khaled Hospital');
    assert.equal(radiology.radiologist, 'Dr. Khaled Al Khateeb');
    assert.equal(radiology.radiologyType, 'Chest Scan'); 
    assert.equal(radiology.description, 'This is a description for the radiology test'); 
    assert.equal(radiology.isCorrectionFor, '');
    assert.equal(await medicalRecordContract.methods.radiologiesCount().call(), 1);
  });

  it('can mark drug as dispensed', async () => {
    await medicalRecordContract.methods.addDrugPrescribtion('King Khaled Hospital', 'Dr. Khaled Al Khateeb', drugListString, '').send({ from: hospitalOne, gas: '200000000' });
    let editedDrugList = [
      {
        drugName: 'Amoxicilum',
        quantity: 2,
        doctorComment: 'take one bill after lunch every day for one week',
        isDispensed: false,
      },
      {
        drugName: 'anti baiotics',
        quantity: 1,
        doctorComment: 'no comment',
        isDispensed: true,
      },
    ];
    let editedDrugListString = JSON.stringify(editedDrugList);
    await medicalRecordContract.methods.markDrugAsDispensed(1, editedDrugListString).send({ from: hospitalOne, gas: '200000000' });
    let drugPrescribtion = await medicalRecordContract.methods.drugPrescribtions(0).call();
    assert.equal(drugPrescribtion.drugList, editedDrugListString);

  });

  it('marks transaction as medical error', async () => {
    // adding several accounts
    await medicalRecordContract.methods.addSurgery('King Khaled Hospital', 'Open Heart Surgery', 'Dr. Khaled Al Khateeb', 8902, 'x298id02zksoi2083kdx', 'cut his stomic', '').send({ from: hospitalOne, gas: '200000000' }); // 1
    await medicalRecordContract.methods.addSurgery('King Khaled Hospital', 'Open Heart Surgery', 'Dr. Khaled Al Khateeb', 8902, 'x298id02zksoi2083kdx', 'cut his stomic', '').send({ from: hospitalOne, gas: '200000000' }); // 2
    await medicalRecordContract.methods.addLaboratoryTest('King Khaled Hospital', 'Mohanned Yahya', 'Blood Test', 'This is a description for the blood test', 'x298id02zksoi2083kdx', '').send({ from: hospitalOne, gas: '200000000' }); // 3
    await medicalRecordContract.methods.addDiagnosis('King Khaled Hospital', 'Dr. Khaled Al Khateeb', 'Breast Cancer', 'x298id02zksoi2083kdx', '').send({ from: hospitalOne, gas: '200000000' }); // 4
    await medicalRecordContract.methods.addBloodDonation('King Khaled Hospital', 'Dr. Khaled Al Khateeb', 'Red cells', 12, 'x298id02zksoi2083kdx', '').send({ from: hospitalOne, gas: '200000000' }); // 5
    // await medicalRecordContract.methods.addDrugPrescribtion('King Khaled Hospital', 'Dr. Khaled Al Khateeb', drugListString, '').send({ from: hospitalOne, gas: '200000000' }); // 6
    await medicalRecordContract.methods.addRadiology('King Khaled Hospital', 'Dr. Khaled Al Khateeb', 'Chest Scan', 'This is a description for the radiology test','x9812iswoeis321qA','').send({ from: hospitalOne, gas: '200000000' }); // 6
    await medicalRecordContract.methods.addRadiology('King Khaled Hospital', 'Dr. Khaled Al Khateeb', 'Chest Scan', 'This is a description for the radiology test','x9812iswoeis321qA','').send({ from: hospitalOne, gas: '200000000' }); // 6

    // marking a surgery transaction as a medical error
    await medicalRecordContract.methods.markTransactionAsMedicalError(1, 1).send({ from: hospitalOne, gas: '200000000' });
    let surgery = await medicalRecordContract.methods.surgeries(0).call();
    let surgery2 = await medicalRecordContract.methods.surgeries(1).call();
    assert.equal(surgery.isCorrectionFor, 'true');

    await medicalRecordContract.methods.markTransactionAsMedicalError(2, 3).send({ from: hospitalOne, gas: '200000000' });
    let labTest = await medicalRecordContract.methods.laboratoryTests(0).call();
    assert.equal(labTest.isCorrectionFor, 'true');

    await medicalRecordContract.methods.markTransactionAsMedicalError(3, 4).send({ from: hospitalOne, gas: '200000000' });
    let diagnosis = await medicalRecordContract.methods.diagnosises(0).call();
    assert.equal(diagnosis.isCorrectionFor, 'true');

    await medicalRecordContract.methods.markTransactionAsMedicalError(4, 5).send({ from: hospitalOne, gas: '200000000' });
    let bloodDonation = await medicalRecordContract.methods.bloodDonations(0).call();
    assert.equal(bloodDonation.isCorrectionFor, 'true');

    // await medicalRecordContract.methods.markTransactionAsMedicalError(5, 6).send({ from: hospitalOne, gas: '200000000' });
    // let drugPrescribtion = await medicalRecordContract.methods.drugPrescribtions(0).call();
    // assert.equal(drugPrescribtion.isCorrectionFor, 'true');

    await medicalRecordContract.methods.markTransactionAsMedicalError(6, 7).send({ from: hospitalOne, gas: '200000000' });
    let radioloy = await medicalRecordContract.methods.radiologies(1).call();
    assert.equal(radioloy.isCorrectionFor, 'true');
  });

}); 
