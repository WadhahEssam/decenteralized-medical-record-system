pragma solidity >=0.4.25;

contract MedicalRecord {
    string public name;
    uint256 public nationalID;
    uint public birthDate; // timestamp format
    string public phoneNumber;
    string public gender;
    string public bloodType;
    string[] public emergencyContacts;
    string public hospitalName; // which hospital the record was submitted by
    uint public submissionDate; 
    
    // Surgeries
    struct Surgery {
        uint ID;
        string hospitalName;
        string surgeryName;
        string surgeryDescription;
        string doctor;
        uint date;
        uint duration;
        string fileHash; // hash of the uploaded image ( 0 means no file was uploaded )
        bool isMedicalError;
        uint isCorrectionFor; // sugeryId
    }
    
    Surgery[] public surgeries;
    
    // Diagnosis[] public diagnosisList;
    // DrugPrescription[] public drugPrescription;
    // LaboratoryTest[] public laboratoryTests;
    // BloodDonation[] public bloodDonations;
    
    constructor(uint256 nationalIDI, string memory nameI, uint birthDateI, string memory phoneNumberI, string memory genderI, string memory bloodTypeI, string memory emergencyContactI, string memory hospitalNameI) public {
        name = nameI;
        nationalID = nationalIDI;
        birthDate = birthDateI;
        phoneNumber = phoneNumberI;
        gender = genderI;
        bloodType = bloodTypeI;
        emergencyContacts.push(emergencyContactI); 
        hospitalName = hospitalNameI;
        submissionDate = block.timestamp;
    }
    
    function addSurgery(string memory _hospiatlName, string memory _surgeryName, string memory _surgeryDescription, string memory _doctor, uint _date, uint _duration, string memory _fileHash) public {
        surgeries.push(Surgery({
            ID: surgeries.length+1,
            hospitalName: _hospiatlName,
            surgeryName: _surgeryName,
            surgeryDescription: _surgeryDescription,
            doctor: _doctor,
            date: _date,
            duration: _duration,
            fileHash: _fileHash,
            isMedicalError: false,
            isCorrectionFor: 0
        }));
    }
}


    


    