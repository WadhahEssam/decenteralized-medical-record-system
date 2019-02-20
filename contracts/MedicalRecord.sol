//
// MedicalRecord.sol
// Decentralized Medical Record System
//
// This smart contract represents one Medical Record and stors its models,
// as well its different functions.
// Medical reords are created and deployed using the Medical Records System smart contract.
//

pragma solidity >=0.4.25;

contract MedicalRecord {

    // -- State Variables --
    address public medicalRecordAddress; // The address in the blockchain
    uint256 public nationalID;
    string public name;
    uint public birthOfDate; // timestamp format
    string public phoneNumber;
    string public gender;
    string public bloodType;
    string[] public emergencyContacts;
    Diognosis[] public diognoses; // Holds the diognoses assosiated with this medical record
    // DrugPrescribtion[] public drugPrescribtions;
    Surgery[] public surgeries; // Holds the surgeries assosiated with this medical record
    LaboratoryTest[] public laboratoryTests; // Holds the laboratory tests assosiated with this medical record
    // BloodDonation[] public bloodDonations;
    string public hospitalName; // which hospital the record was submitted by
    uint public submissionDate;
    address private noAddress = address(0x0000000000000000000000000);
    
    // -- Models --
    struct Surgery {
        string mainDoctor;
        // currently solidity does not support an array of strings as an argument type. So I had to store it as bytes32.
        // we can use web3's web3.utils.asciiToHex(arg) to convert the string to byte32 and store it in the assistantDoctors array.
        bytes32[] assistantDoctors;
        uint date;
        string surgeryType;
        string surgeryInformation;
        uint duration; // in minutes
        bool isMedicalError;
        address isCorrectionFor; // Holds the address of another surgery to mark this one as a correction for it.
        string hospitalName;
        string surgeryName;
        string fileHash; // hash of the uploaded image ( 0 means no file was uploaded )
    }

    struct Diognosis {
        string doctorName;
        uint date;
        string diognosisDescription;
        bool isMedicalError;
        address isCorrectionFor; // Holds the address of another diognosis to mark this one as a correction for it.
    }

    struct LaboratoryTest {
        address transactionAddress;
        address hospitalAddress;
        string laboratoryWorkerName;
        uint date;
        string testType;
        string laboratoryTestDescription;
        string testHash; // unique set of characters which helps in validating the test.
        bool isMedicalError;
        address isCorrectionFor; // Holds the address of another test to mark this one as a correction for it.
    }

    // TODO: Drug Prescribtion struct
    // struct DrugPrescribtion {

    // }

    // TODO: Drug struct
    // struct Drug {

    // }

    // TODO: Blood Donation struct
    // struct BloodDonation {

    // }
    
    // -- Constructor --
    constructor(uint256 nationalIDI, string memory nameI, uint birthDateI, string memory phoneNumberI, string memory genderI,
        string memory bloodTypeI, string memory emergencyContactI, string memory hospitalNameI) public {
        name = nameI;
        nationalID = nationalIDI;
        birthOfDate = birthDateI;
        phoneNumber = phoneNumberI;
        gender = genderI;
        bloodType = bloodTypeI;
        emergencyContacts.push(emergencyContactI); 
        hospitalName = hospitalNameI;
        submissionDate = block.timestamp;
    }

    // -- Setters --
    function addEmergencyContact(string _phoneNumber) public {
        emergencyContacts.push(_phoneNumber);
    }

    function addDiognosis(string _doctorName, string _diognosisDescription) public {
        diognoses.push(Diognosis({
            doctorName: _doctorName,
            date: block.timestamp,
            diognosisDescription: _diognosisDescription,
            isMedicalError: false,
            isCorrectionFor: noAddress
        }));
    }

    function addSurgery(
        string memory _mainDoctor,
        bytes32[] memory _assistantDoctors,
        uint _date,
        string memory _surgeryType,
        string memory _surgeryInformation, 
        uint _duration,
        string _hospitalName,
        string _surgeryName,
        string memory _fileHash) public {

        surgeries.push(Surgery({
            mainDoctor: _mainDoctor,
            assistantDoctors: _assistantDoctors,
            date: _date,
            surgeryType: _surgeryType,
            surgeryInformation: _surgeryInformation,
            duration: _duration,
            isMedicalError: false,
            isCorrectionFor: noAddress,
            hospitalName: _hospitalName,
            surgeryName: _surgeryName,
            fileHash: _fileHash
        }));
    }
}


    


    