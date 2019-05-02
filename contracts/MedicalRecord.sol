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
    uint public dateOfBirth; // timestamp format
    string public phoneNumber;
    string public gender;
    string public bloodType;
    string[] public emergencyContacts;
    uint public emergencyContactsCount;
    Diognosis[] public diagnosises; // Holds the diagnosises assosiated with this medical record
    uint public diagnosisesCount;
    DrugPrescribtion[] public drugPrescribtions;
    uint public drugPrescribtionsCount;
    Surgery[] public surgeries; // Holds the surgeries assosiated with this medical record
    uint public surgeriesCount; // Holds the number of surgeries in the surgeries array
    LaboratoryTest[] public laboratoryTests; // Holds the laboratory tests assosiated with this medical record
    uint public laboratoryTestsCount;
    BloodDonation[] public bloodDonations;
    uint public bloodDonationsCount;
    Radiology[] public radiologies;
    uint public radiologiesCount;
    string public hospitalName; // which hospital the record was submitted by
    uint public submissionDate;
    address private noAddress = address(0x0000000000000000000000000);
    uint globalCounter;
    
    // -- Models --
    struct Surgery {
        uint id;
        string mainDoctor;
        uint date;
        string surgeryInformation;
        uint duration; // in minutes
        string isCorrectionFor; // Holds the address of another surgery to mark this one as a correction for it.
        string hospitalName;
        string surgeryName;
        string fileHash; // hash of the uploaded image ( 0 means no file was uploaded )
    }

    struct Radiology {
        uint id;
        string radiologist;
        uint date;
        string radiologyType;
        string description;
        string isCorrectionFor; // Holds the address of another surgery to mark this one as a correction for it.
        string hospitalName;
        string fileHash; // hash of the uploaded image ( 0 means no file was uploaded )
    }

    struct Diognosis {
        uint id;
        string hospitalName;
        string doctorName;
        string diognosisDescription;
        uint date;
        string isCorrectionFor; // Holds the address of another diognosis to mark this one as a correction for it.
        string fileHash;
    }

    struct LaboratoryTest {
        uint id;
        string hospitalName;
        string laboratoryWorkerName;
        uint date;
        string testType;
        string laboratoryTestDescription;
        string testHash; // unique set of characters which helps in validating the test.
        string isCorrectionFor; // Holds the address of another test to mark this one as a correction for it.
    }

    struct DrugPrescribtion {
        uint id;
        string hospitalName;
        string doctorName;
        uint date;
        string drugList;
        uint drugListCount;
        string isCorrectionFor;
    }

    struct Drug {
        string drugName;
        uint quantity;
        string doctorComment;
        bool isDispensed;
    }

    struct BloodDonation {
        uint id;
        string hospitalName;
        string doctorName;
        string donationType;
        uint date;
        uint amount;
        string fileHash;
        string isCorrectionFor;
    }

    // -- Constructor --
    constructor(uint256 nationalIDI, string memory nameI, uint birthDateI, string memory phoneNumberI, string memory genderI,
        string memory bloodTypeI, string memory emergencyContactI, string memory hospitalNameI) public {
        name = nameI;
        nationalID = nationalIDI;
        dateOfBirth = birthDateI;
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

    function addBloodDonation(
        string _hospitalName,
        string _doctorName, 
        string _donationType,
        uint _amount,
        string memory _fileHash,
        string _isCorrectionFor) public {
        globalCounter++;
        bloodDonationsCount++;
        bloodDonations.push(BloodDonation({
            id: globalCounter,
            hospitalName: _hospitalName,
            doctorName: _doctorName,
            donationType: _donationType,
            date: block.timestamp,
            amount: _amount,
            fileHash: _fileHash,
            isCorrectionFor: _isCorrectionFor
        }));
    }

    function addRadiology(
        string _hospitalName,
        string _radiologistName, 
        string _radiologyType,
        string _description,
        string memory _fileHash,
        string _isCorrectionFor) public {
        globalCounter++;
        radiologiesCount++;
        radiologies.push(Radiology({
            id: globalCounter,
            radiologist: _radiologistName,
            date: block.timestamp,
            radiologyType: _radiologyType,
            description: _description,
            isCorrectionFor: _isCorrectionFor,
            hospitalName: _hospitalName,
            fileHash: _fileHash
        }));
    }


    function addDiagnosis(
        string _hospitalName,
        string _doctorName, 
        string _diognosisDescription, 
        string _fileHash,
        string _isCorrectionFor) public {
        globalCounter++;
        diagnosisesCount++;
        diagnosises.push(Diognosis({
            id: globalCounter,
            hospitalName: _hospitalName, 
            doctorName: _doctorName,
            diognosisDescription: _diognosisDescription,
            date: block.timestamp,
            fileHash: _fileHash,
            isCorrectionFor: _isCorrectionFor
        }));
    }

    function addDrugPrescribtion(
        string _hospitalName,
        string _doctorName, 
        string _drugList,
        string _isCorrectionFor) public {
        globalCounter++;
        drugPrescribtionsCount++;
        drugPrescribtions.push(DrugPrescribtion({
            id: globalCounter++,
            hospitalName: _hospitalName,
            doctorName: _doctorName,
            date: block.timestamp,
            drugList: _drugList,
            drugListCount: 0,
            isCorrectionFor: _isCorrectionFor
        }));
    }

    function addSurgery(
        string _hospitalName,
        string _surgeryName,
        string memory _mainDoctor,
        uint _duration,
        string memory _fileHash,
        string _surgeryInformation,
        string _isCorrectionFor) public {
        globalCounter++;
        surgeriesCount++;
        surgeries.push(Surgery({
            id: globalCounter,
            mainDoctor: _mainDoctor,
            date: block.timestamp,
            surgeryInformation: _surgeryInformation,
            duration: _duration,
            isCorrectionFor: _isCorrectionFor,
            hospitalName: _hospitalName,
            surgeryName: _surgeryName,
            fileHash: _fileHash
        }));
    }

    function addLaboratoryTest(
        string _hospitalName,
        string _laboratoryWorkerName, 
        string _testType, 
        string _laboratoryTestDescription,
        string memory _fileHash,
        string _isCorrectionFor) public {
        globalCounter++;
        laboratoryTestsCount++;
        laboratoryTests.push(LaboratoryTest({
            id: globalCounter,
            hospitalName: _hospitalName,
            laboratoryWorkerName: _laboratoryWorkerName,
            date: block.timestamp,
            testType: _testType,
            laboratoryTestDescription: _laboratoryTestDescription,
            testHash: _fileHash,
            isCorrectionFor: _isCorrectionFor
        }));
    }

    function markDrugAsDispensed(uint _id, string _editedDrugList) public {
        for ( uint y = 0 ; y < drugPrescribtions.length ; y++) {
            if (drugPrescribtions[y].id == _id) {
                drugPrescribtions[y].drugList = _editedDrugList;
            }
        }          
    }

    // TODO: test this function and complete it if it's working as expected
    function markTransactionAsMedicalError(uint _type, uint _id) public {
        if (_type == 1) { // Surgery
            for ( uint i = 0 ; i < surgeries.length ; i++) {
                if (surgeries[i].id == _id) {
                    surgeries[i].isCorrectionFor = "true";
                }
            }
        } else if (_type == 2) { // LaboratoryTest
            for ( uint j = 0 ; j < laboratoryTests.length ; j++) {
                if (laboratoryTests[j].id == _id) {
                    laboratoryTests[j].isCorrectionFor = "true";
                }
            }
        } else if (_type == 3) { // Diognosis
            for ( uint n = 0 ; n < diagnosises.length ; n++) {
                if (diagnosises[n].id == _id) {
                    diagnosises[n].isCorrectionFor = "true";
                }
            }
        } else if (_type == 4) { // BloodDonation
            for ( uint m = 0 ; m < bloodDonations.length ; m++) {
                if (bloodDonations[m].id == _id) {
                    bloodDonations[m].isCorrectionFor = "true";
                }
            }
        } else if (_type == 5){ // DrugPrescribtion
            for ( uint y = 0 ; y < drugPrescribtions.length ; y++) {
                if (drugPrescribtions[y].id == _id) {
                    drugPrescribtions[y].isCorrectionFor = "true";
                }
            }            
        } else if (_type == 6){
            for ( uint o= 0 ; o < radiologies.length ; o++) {
                if (radiologies[o].id == _id) {
                    radiologies[o].isCorrectionFor = "true";
                }
            }      
        }
    }
    
}