pragma solidity ^0.5.0;

contract medicalRecord{
    
    
    address public medicalRecordAddress;
    string public nationalID;
    string public name;
    //Date  
    string public phoneNumber;
    string public gender;
    string public bloodType;
    string[] public emergencyContants;
    Diagnosis[] public diagnosisList;
    DrugPrescription[] public drugPrescription;
    Surgery[] public surgeries;
    LaboratoryTest[] public laboratoryTests;
    BloodDonation[] public bloodDonations;
    
    constructor() public {
        medicalRecordAddress = msg.sender;
    }
    
    function setNationalID(string memory _nationalID) public{
        nationalID = _nationalID;
    }
    
    function getNationalID() public view returns(string memory){
        return nationalID;
    }
    
    
    function setPhoneNumber(string memory _phoneNumber) public{
        phoneNumber = _phoneNumber;
    }
    
    function getPhoneNumber() public view returns(string memory){
        return phoneNumber;
    }
    
    function setGender(string memory _gender) public{
        gender = _gender;
    }
    
    function getGender() public view returns(string memory){
        return gender;
    }
    
      function setBloodType(string memory _bloodType) public{
        bloodType = _bloodType;
    }
    
    function getBloodType() public view returns(string memory){
        return bloodType;
    }
    

    function addEmergencyContact(string phoneNumber) public {
        // TODO: addEmergencyContact
    }

    function getEmergencyContacts() public view returns (string[]){
        // TODO: getEmergencyContacts
    }

    function addDiognosis(Diagnosis diagnosis) public{
        // TODO: addDiognosis
    }

    function getDiognosis() public view returns (Diagnosis[]){
        // TODO: getDiognosis
    }

    function addDrugPrescription(DrugPrescription drugPrescription) public {
        // TODO: addDrugPrescription
    }

    function getDrugPrescription() public view returns (DrugPrescription[]){
        // TODO: getDrugPrescription
    }

    function addSurgery(Surgery) public medical{
      surgeries.push(new Surgery());
    }

    function getSurgeries() public medical returns (Surgery){
       for ( uint i = 0 ; i < surgeries.length ; i++)
            return surgeries[i];
    }

    function addLabTest(LaboratoryTest) public{
        laboratoryTests.push(new LaboratoryTest());
    }

    function getLabTest() public view returns (LaboratoryTest){
        for ( uint i = 0 ; i < laboratoryTests.length ; i++)
            return laboratoryTests[i];
    }

    function addBloodDonation(BloodDonation) public{
        bloodDonations.push(new BloodDonation());
    }

    function getBloodDonation() public view returns (BloodDonation){
        for ( uint i = 0 ; i < bloodDonations.length ; i++)
            return bloodDonations[i];
    }

    function markTransactionAsCorrection(address Address) public{
        // TODO: markTransactionAsCorrection
    }
    
      modifier medical() {
        require(msg.sender == medicalRecordAddress,"Sender not authorized.");
        _;
    }
    
}

    contract Surgery{
       
        string public name;
        
        constructor() public{
            name = "Surgery";
        }
        
    }
    
    contract LaboratoryTest{
        string public name;
        
        constructor() public{
             name = "LaboratoryTest";
        }
    }
    contract BloodDonation{
       string public name;
        
        constructor() public{
            name = "BloodDonation";
        }
    }
    
    
    
    
