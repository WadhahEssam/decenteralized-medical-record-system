pragma solidity ^0.5.3;

contract MedicalRecordsSystem {
    address public ministryOfHealth;
    MedicalRecord[] public medicalRecords;
    address[] public hospitalAddresses;
    address[] public pharmaciesAddresses;
    
    constructor() public {
        ministryOfHealth = msg.sender;
    }
    
    function createMedicalRecord() public {
        medicalRecords.push(new MedicalRecord());
    }

    function checkMedicalRecord() public {
      // to be developed
    }

    function getMedicalRecord() public {
      // to be developed
    }
    
    function addHospital(address hospitalAddress) public restrected {
        hospitalAddresses.push(hospitalAddress);
    }
    
    function addPharmacy(address pharmacyAddress) public restrected {
        pharmaciesAddresses.push(pharmacyAddress);
    }
    
    modifier restrected() {
        require(msg.sender == ministryOfHealth,"Nor Authorized Request");
        _;
    }
}

contract MedicalRecord {
    string public name;
    
    constructor() public {
        name = "new medical record";
    }
}