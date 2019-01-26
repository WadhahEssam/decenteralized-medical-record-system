const path = require('path');
const fs = require('fs');
const solc = require('solc');

const contractPath = path.resolve(__dirname, 'contracts', 'MedicalRecordsSystem.sol');
const source = fs.readFileSync(contractPath, 'utf8');

let input = {
  language: 'Solidity',
  sources: {
      'MedicalRecordsSystem.sol': {
          content: source
      }
  },
  settings: {
      outputSelection: {
          '*': {
              '*': [ '*' ]
          }
      }
  }
}

var output = JSON.parse(solc.compile(JSON.stringify(input)))
module.exports = output.contracts['MedicalRecordsSystem.sol'];