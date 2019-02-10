pragma solidity >=0.4.25;
import "./MedicalRecord.sol";

contract MedicalRecordsSystem {
    struct Hospital {
        string name;  
        address networkAddress;
        uint date;
    }
    struct Pharmacy {
        string name;
        address networkAddress;
        uint date;
    }
    address public ministryOfHealth;
    mapping(uint256 => address) public medicalRecords;
    mapping(address => bool) public hospitalAddresses;
    mapping(address => bool) public pharmacyAddresses;
    address private noAddress = address(0x0000000000000000000000000);
    Hospital[] public hospitals;
    Pharmacy[] public pharmacies;
    uint256 public medicalRecordsCount = 0;
    
    constructor() public {
        ministryOfHealth = msg.sender;
    }
    
    function createMedicalRecord(uint256 nationalID, string memory name, uint dateI, string memory phoneNumberI, string memory genderI, string memory bloodTypeI, string memory emergencyContactI) public onlyHospitalsAndPharmacies {
        string memory hospitalName = "noName";
        for (uint i = 0; i < hospitals.length; i++) {
            if (hospitals[i].networkAddress == msg.sender) {
                hospitalName = hospitals[i].name;
            }
        }
        MedicalRecord newMedicalRecord = new MedicalRecord(nationalID, name, dateI, phoneNumberI, genderI, bloodTypeI, emergencyContactI, hospitalName);
        medicalRecords[nationalID] = address(newMedicalRecord);
        medicalRecordsCount++;
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
    
    function addHospital(address hospitalAddressI, string memory hospitalName) public onlyMinistryOfHealth {
        hospitalAddresses[hospitalAddressI] = true;
        hospitals.push(Hospital({
            name: hospitalName,
            networkAddress: hospitalAddressI,
            date: block.timestamp
        }));
    }
    
    function addPharmacy(address pharmacyAddressI, string memory pharmacyName) public onlyMinistryOfHealth {
        pharmacyAddresses[pharmacyAddressI] = true;
        pharmacies.push(Pharmacy({
            name: pharmacyName,
            networkAddress: pharmacyAddressI,
            date: block.timestamp
        }));
    }
    
    function getHospitalsCount() public view returns(uint) {
        return hospitals.length;
    }
    
    function getPharmaciesCount() public view returns(uint) {
        return pharmacies.length;
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
