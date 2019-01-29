pragma solidity >=0.4.25;
import "./MedicalRecord.sol";

contract MedicalRecordsSystem {
    address public ministryOfHealth;
    mapping(uint256 => address) public medicalRecords;
    mapping(address => bool) public hospitalAddresses;
    mapping(address => bool) public pharmacyAddresses;
    address private noAddress = address(0x0000000000000000000000000);
    
    constructor() public {
        ministryOfHealth = msg.sender;
    }
    
    function createMedicalRecord(uint256 nationalID, string memory name, string memory dateI, string memory phoneNumberI, string memory genderI, string memory bloodTypeI, string memory emergencyContantI) public onlyHospitalsAndPharmacies {
        MedicalRecord newMedicalRecord = new MedicalRecord(nationalID, name, dateI, phoneNumberI, genderI, bloodTypeI, emergencyContantI);
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
