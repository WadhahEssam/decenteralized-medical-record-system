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
    Diognosis[] public diognoses; // Holds the diognoses assosiated with this medical record
    uint public diognosesCount;
    DrugPrescribtion[] public drugPrescribtions;
    uint public drugPrescribtionsCount;
    Surgery[] public surgeries; // Holds the surgeries assosiated with this medical record
    uint public surgeriesCount; // Holds the number of surgeries in the surgeries array
    LaboratoryTest[] public laboratoryTests; // Holds the laboratory tests assosiated with this medical record
    uint public laboratoryTestsCount;
    BloodDonation[] public bloodDonations;
    uint public bloodDonationsCount;
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

    struct Diognosis {
        string doctorName;
        uint date;
        string diognosisDescription;
        bool isMedicalError;
        address isCorrectionFor; // Holds the address of another diognosis to mark this one as a correction for it.
    }

    struct LaboratoryTest {
        string laboratoryWorkerName;
        uint date;
        string testType;
        string laboratoryTestDescription;
        string testHash; // unique set of characters which helps in validating the test.
        bool isMedicalError;
        address isCorrectionFor; // Holds the address of another test to mark this one as a correction for it.
    }

    struct DrugPrescribtion {
        string doctorName;
        uint date;
        string drugList;
        uint drugListCount;
        bool isMedicalError;
        address isCorrectionFor;
    }

    struct Drug {
        string drugName;
        uint quantity;
        string doctorComment;
        bool isDispensed;
    }

    struct BloodDonation {
        string doctorNAme;
        uint date;
        string donationType;
        uint ammount;
        bool isMedicalError;
        address isCorrectionFor;
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

    function addDiognosis(string _doctorName, string _diognosisDescription) public {
        diognoses.push(Diognosis({
            doctorName: _doctorName,
            date: block.timestamp,
            diognosisDescription: _diognosisDescription,
            isMedicalError: false,
            isCorrectionFor: noAddress
        }));
    }

    function addDrugPrescribtion(string _doctorName, string _drugList) public {
        drugPrescribtions.push(DrugPrescribtion({
            doctorName: _doctorName,
            date: block.timestamp,
            drugList: _drugList,
            drugListCount: 0,
            isMedicalError: false,
            isCorrectionFor: noAddress
        }));
    }

    function addSurgery(
        string _hospitalName,
        string _surgeryName,
        string memory _mainDoctor,
        uint _date,
        uint _duration,
        string memory _fileHash,
        string _surgeryInformation) public {
            
        globalCounter++;

        surgeries.push(Surgery({
            id: surgeriesCount + 1,
            mainDoctor: _mainDoctor,
            date: _date,
            surgeryInformation: _surgeryInformation,
            duration: _duration,
            isCorrectionFor: "",
            hospitalName: _hospitalName,
            surgeryName: _surgeryName,
            fileHash: _fileHash
        }));
    }

    function addLaboratoryTest(string _laboratoryWorkerName, string _testType, string _laboratoryTestDescription) public {
        laboratoryTests.push(LaboratoryTest({
            laboratoryWorkerName: _laboratoryWorkerName,
            date: block.timestamp,
            testType: _testType,
            laboratoryTestDescription: _laboratoryTestDescription,
            testHash: "0x0",
            isMedicalError: false,
            isCorrectionFor: noAddress
        }));
    }

    // TODO: function addBloodDonation(string _doctorName, string _donationType, double _ammount)

    // TODO: test this function and complete it if it's working as expected
    function markTransactionAsMedicalError(uint _type, uint _id) public {
        if (_type == 1) { // Surgery
            surgeries[_id-1].isCorrectionFor = "true";
        } else if (_type == 2) { // Diognosis
        
        } else if (_type == 3) { // DrugPrescribtion
            
        } else if (_type == 4) { // LaboratoryTest
            
        } else { //BloodDonation
            
        }
    }
    
    function hashCompareWithLengthCheck(string a, string b) internal returns (bool) {
        if(bytes(a).length != bytes(b).length) {
            return false;
        } else {
            return keccak256(a) == keccak256(b);
        }
    }
    
    function uint2str(uint i) internal pure returns (string){
        if (i == 0) return "0";
        uint j = i;
        uint length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length - 1;
        while (i != 0){
            bstr[k--] = byte(48 + i % 10);
            i /= 10;
        }
        return string(bstr);
    }
    
    function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }
}