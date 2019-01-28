pragma solidity >=0.4.25;

contract MedicalRecordsSystem {
    address public ministryOfHealth;
    mapping(uint256 => address) public medicalRecords;
    mapping(address => bool) public hospitalAddresses;
    mapping(address => bool) public pharmacyAddresses;
    address private noAddress = address(0x0000000000000000000000000);
    
    constructor() public {
        ministryOfHealth = msg.sender;
    }
    
    function createMedicalRecord(uint256 nationalID, string memory name) public onlyHospitalsAndPharmacies {
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
    
    function addHospital(address hospitalAddressI) public onlyMinistryOfHealth {
        hospitalAddresses[hospitalAddressI] = true;
    }
    
    function addPharmacy(address pharmacyAddressI) public onlyMinistryOfHealth {
        pharmacyAddresses[pharmacyAddressI] = true;
    }
    
    
    modifier onlyHospitalsAndPharmacies() {
        require(hospitalAddresses[msg.sender] == true, "Only hospitals can do this operation");
        _;
    }
    
    modifier onlyMinistryOfHealth() {
        require(msg.sender == ministryOfHealth, "Only Ministry of health can do this operation");
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