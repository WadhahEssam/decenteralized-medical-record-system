// this file is used for testing the contracts and creating a testing env
// with a medicalRecordsSystemContract along with the hospitals and the 
// pharmacies and the medical record ( wihch makes it better for testing) 

const solc = require('solc');
const path = require('path');
const fs = require('fs-extra'); 

// -- Compiling --
// Delete the entire "build" directory
const buildPath = path.resolve(__dirname, 'build'); 
fs.removeSync(buildPath);

// Read 'MedicalRecordsSystem.sol' from the 'contracts' directory
const medicalRecordsSystemPath = path.resolve(__dirname, 'contracts', 'MedicalRecordsSystem.sol');
const medicalRecordSystemSource = fs.readFileSync(medicalRecordsSystemPath, 'utf8');

// Read 'MedicalRecord.sol' from the 'contracts' directory
const medicalRecordPath = path.resolve(__dirname, 'contracts', 'MedicalRecord.sol');
const medicalRecordSource = fs.readFileSync(medicalRecordPath, 'utf8');

const input = {
  sources: {
    'MedicalRecordsSystem.sol': medicalRecordSystemSource,
    'MedicalRecord.sol': medicalRecordSource
  }
};

// Compile both the MedicalRecord and MedicalRecordsSystem with 'solc'
const output = solc.compile(input, 1).contracts; 

// Recreate the 'build' directory and write the output to it
fs.ensureDirSync(buildPath);

for (let contract in output) {
  fs.outputJsonSync(
    path.resolve(buildPath, contract.substring(contract.indexOf(':')+1,contract.length) + '.json'),
    output[contract]
  );
}

// -- Deploying --
const Web3 = require('web3');
const ganache = require('ganache-cli');
const assert = require('assert');
const compiledMedicalRecordsSystem = require('./build/MedicalRecordsSystem.json');
const compiledMedicalRecord = require('./build/MedicalRecord.json');

var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));
// var web3 = new Web3(new Web3.providers.HttpProvider('HTTP://10.131.192.242:7545'));
// var web3 = new Web3(new Web3.providers.HttpProvider('HTTP://172.20.10.2:7545'));

deploy();

async function deploy()  {

  let accounts, medicalRecordsSystemContract, medicalRecordContract;
  let ministryOfHelath, hospitalOne, hospitalTwo, hospitalThree, pharmacyOne, pharmacyTwo;
  
  accounts = await web3.eth.getAccounts();
  ministryOfHelath = accounts[0];
  hospitalOne = accounts[1];
  hospitalTwo = accounts[2];
  hospitalThree = accounts[3];
  pharmacyOne = accounts[4];
  pharmacyTwo = accounts[5];
  
  // creating the system contract
  medicalRecordsSystemContract = await new web3.eth.Contract(JSON.parse(compiledMedicalRecordsSystem.interface))
    .deploy({ data: compiledMedicalRecordsSystem.bytecode })
    .send({ from: ministryOfHelath, gas: '30000000' });

  // adding hospitals 
  await medicalRecordsSystemContract.methods.addHospital(hospitalTwo, 'King Abdullah Hospital').send({ from: ministryOfHelath, gas: '20000000' });
  await medicalRecordsSystemContract.methods.addHospital(hospitalThree, 'Al Salam Hospital').send({ from: ministryOfHelath, gas: '20000000' });

  // adding pharmacies
  await medicalRecordsSystemContract.methods.addPharmacy(pharmacyOne, 'Al Salam Pharmach').send({ from: ministryOfHelath, gas: '20000000' });
  await medicalRecordsSystemContract.methods.addPharmacy(pharmacyTwo, 'Al Wali Pharmacy').send({ from: ministryOfHelath, gas: '20000000' });

  console.log(medicalRecordsSystemContract.options.address);
  fs.outputJsonSync(
    path.resolve(buildPath, 'contractAddress.json'),
    {contractAddress: medicalRecordsSystemContract.options.address}, 
  );
}
