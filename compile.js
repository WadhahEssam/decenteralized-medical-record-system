const solc = require('solc');
const path = require('path');
const fs = require('fs-extra'); 

const buildPath = path.resolve(__dirname, 'build'); 

fs.removeSync(buildPath);

const medicalRecordsSystemPath = path.resolve(__dirname, 'contracts', 'MedicalRecordsSystem.sol');
const medicalRecordSystemSource = fs.readFileSync(medicalRecordsSystemPath, 'utf8');

const medicalRecordPath = path.resolve(__dirname, 'contracts', 'MedicalRecord.sol');
const medicalRecordSource = fs.readFileSync(medicalRecordPath, 'utf8');

const input = {
  sources: {
    'MedicalRecordsSystem.sol': medicalRecordSystemSource,
    'MedicalRecord.sol': medicalRecordSource
  }
};

const output = solc.compile(input, 1).contracts; 

fs.mkdirsSync(buildPath);

for (let contract in output) {
  fs.outputJsonSync(
    path.resolve(buildPath, contract.substring(contract.indexOf(':')+1,contract.length) + '.json'),
    output[contract], 
  );
}