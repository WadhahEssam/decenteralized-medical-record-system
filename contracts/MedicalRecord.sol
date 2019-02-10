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
    
    // Diagnosis[] public diagnosisList;
    // DrugPrescription[] public drugPrescription;
    // Surgery[] public surgeries;
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
}

    


    
    


    


    
//  note : address is saved automatically for any contract 
//     constructor() public {
//         medicalRecordAddress = msg.sender;
//     }

// note : national id must not be changed
//     function setNationalID(string memory _nationalID) public{
//         nationalID = _nationalID;
//     }

// note : getters are provided automatically by solidity 
//     function getNationalID() public view returns(string memory){
//         return nationalID;
//     }

// note : getters are provided automatically by solidity 
//     function getPhoneNumber() public view returns(string memory){
//         return phoneNumber;
//     }

// note : gender can't change
//     function setGender(string memory _gender) public{
//         gender = _gender;
//     }

// note : getters are provided automatically by solidity 
//     function getGender() public view returns(string memory){
//         return gender;
//     }

// note : blood type can't change
//       function setBloodType(string memory _bloodType) public{
//         bloodType = _bloodType;
//     }


// note : getters are provided automatically by solidity 
//     function getBloodType() public view returns(string memory){
//         return bloodType;
//     }
    
// note : getters are provided automatically by solidity 
//     function getEmergencyContacts() public view returns (string[]){
//         // TODO: getEmergencyContacts
//     }

// note : all the objects should be as struct or library not as contracts
// creating a contract in ethereum takes more time + more gas +
// you should get its address then access it, picture having 
// a 100 diagnosis , in order to access them one by one you need 
// to get the address of every single one and access it individually 


//     function addDiognosis(Diagnosis diagnosis) public{
//         // TODO: addDiognosis
//     }

//     function getDiognosis() public view returns (Diagnosis[]){
//         // TODO: getDiognosis
//     }

//     function addDrugPrescription(DrugPrescription drugPrescription) public {
//         // TODO: addDrugPrescription
//     }

//     function getDrugPrescription() public view returns (DrugPrescription[]){
//         // TODO: getDrugPrescription
//     }

//     function addSurgery(Surgery) public medical{
//       surgeries.push(new Surgery());
//     }

//     function getSurgeries() public medical returns (Surgery){
//        for ( uint i = 0 ; i < surgeries.length ; i++)
//             return surgeries[i];
//     }

//     function addLabTest(LaboratoryTest) public{
//         laboratoryTests.push(new LaboratoryTest());
//     }

//     function getLabTest() public view returns (LaboratoryTest){
//         for ( uint i = 0 ; i < laboratoryTests.length ; i++)
//             return laboratoryTests[i];
//     }

//     function addBloodDonation(BloodDonation) public{
//         bloodDonations.push(new BloodDonation());
//     }

//     function getBloodDonation() public view returns (BloodDonation){
//         for ( uint i = 0 ; i < bloodDonations.length ; i++)
//             return bloodDonations[i];
//     }

//     function markTransactionAsCorrection(address Address) public{
//         // TODO: markTransactionAsCorrection
//     }
    
//       modifier medical() {
//         require(msg.sender == medicalRecordAddress,"Sender not authorized.");
//         _;
//     }
    
// }

//     contract Surgery{
//         string public name;  

//         constructor() public{
//             name = "Surgery";
//         }
//     }
    
//     contract LaboratoryTest{
//         string public name;

//         constructor() public{
//              name = "LaboratoryTest";
//         }
//     }

//     contract BloodDonation{
//        string public name;
        
//         constructor() public{
//             name = "BloodDonation";
//         }
//     }
    
    
    
    
