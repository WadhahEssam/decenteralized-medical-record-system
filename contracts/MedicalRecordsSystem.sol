pragma solidity >=0.4.25;

contract MedicalRecordsSystem {
    address public ministryOfHealth;
    // MedicalRecord[] public medicalRecords;
    mapping(uint256 => address) public medicalRecords;
    address[] public hospitalAddresses;
    address[] public pharmaciesAddresses;
    address private noAddress = address(0x0000000000000000000000000);
    
    constructor() public {
        ministryOfHealth = msg.sender;
    }
    
    function createMedicalRecord(uint256 nationalID, string memory name) public {
        MedicalRecord newMedicalRecord = new MedicalRecord(nationalID, name);
        medicalRecords[nationalID] = address(newMedicalRecord);
    }

    function checkMedicalRecord(uint256 nationalIDI) public view returns (bool) {
        if (medicalRecords[nationalIDI] == noAddress) {
            return false;
        } else {
            return true;
        }
    }

    function getMedicalRecord(uint256 nationalIDI) public view returns (address) {
        address medicalRecord = medicalRecords[nationalIDI];
        if (medicalRecord == noAddress) {
            return noAddress;
        } else {
            return medicalRecord;
        }
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
    uint256 public nationalID;
    
    constructor(uint256 nationalIDI, string memory nameI) public {
        name = nameI;
        nationalID = nationalIDI;
    }
}