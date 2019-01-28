const solc = require('solc');
const path = require('path');
const fs = require('fs-extra'); 

const buildPath = path.resolve(__dirname, 'build'); 

fs.removeSync(buildPath);

const contractPath = path.resolve(__dirname, 'contracts', 'MedicalRecordsSystem.sol');
const contractPath2 = path.resolve(__dirname, 'contracts', 'MedicalRecord.sol');

const source = fs.readFileSync(contractPath, 'utf8');
const source2 = fs.readFileSync(contractPath2, 'utf8');

const input = {
  sources: {
    'MedicalRecordsSystem.sol': source,
    'MedicalRecord.sol': source2
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