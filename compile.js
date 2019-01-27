const solc = require('solc');
const path = require('path');
const fs = require('fs-extra'); 

const buildPath = path.resolve(__dirname, 'build'); 

fs.removeSync(buildPath);

const contractPath = path.resolve(__dirname, 'contracts', 'MedicalRecordsSystem.sol');

const source = fs.readFileSync(contractPath, 'utf8');

const output = solc.compile(source,1).contracts; 

fs.mkdirsSync(buildPath);

for (let contract in output) {
  fs.outputJsonSync(
    path.resolve(buildPath, contract.substring(1,contract.length) + '.json'),
    output[contract], 
  );
}