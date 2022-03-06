// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
pragma experimental ABIEncoderV2;

contract ProofOfReserve {  

  mapping (bytes32 => bool) private listReserve;

    struct Reserved{
        string times;
        string rooms;
        string owners;
    }
    Reserved[] reserved;
  //---events---
  event NameAdded(
    address from,   
    string text,
    bytes32 hash,
    string time,
    string owner

  );
  
  event RegistrationError(
    address from,
    string text,
    string reason
  );

  // store the proof for a student in the contract state
  function recordProof(bytes32 proof) private {
    listReserve[proof] = true;
  }
  
  // record a student name
  function registration(string memory name ,string memory owner ,string memory time) public payable {


    //---check if string was previously stored---
    // if (listReserve[hashing(name)]) {
    //     //---fire the event---
    //     emit RegistrationError(msg.sender, name, "This room has been reserved.");
    //     //---refund back to the sender---
    //     payable(msg.sender).transfer(msg.value);
    //     //---exit the function---
    //     return;
    // }

    if(keccak256(bytes(name)) == keccak256(bytes("Single-Bed Room"))) {
        if (msg.value != 0.001 ether) {
            //---fire the event---
            emit RegistrationError(msg.sender, name, "Incorrect amout of Ether. You should pay 0.001 ether");
            //---refund back to the sender---
            payable(msg.sender).transfer(msg.value);
            //---exit the function---
            return;
        } 

    }else if(keccak256(bytes(name)) == keccak256(bytes("Twin-Bed Room"))){
        if (msg.value != 0.002 ether) {
            emit RegistrationError(msg.sender, name, "Incorrect amout of Ether. You should pay 0.002 ether");
            payable(msg.sender).transfer(msg.value);
            return;
        }     

    }else if(keccak256(bytes(name)) == keccak256(bytes("Deluxe Room"))){
        if (msg.value != 0.003 ether) {
            emit RegistrationError(msg.sender, name, "Incorrect amout of Ether. You should pay 0.003 ether");
            payable(msg.sender).transfer(msg.value);
            return;
        }     

    }else{
        emit RegistrationError(msg.sender, name, "Room not found, please contact staff");
        payable(msg.sender).transfer(msg.value);
        return;
    }
    //---check if msg.value != 0.001 ether---

    recordProof(hashing(name));

    //---fire the event---
    reserved.push(Reserved(time,name,owner));

    emit NameAdded(msg.sender, name, hashing(name), time, owner);
    //payable(msg.sender).transfer(msg.value);
    
  }
  
  // SHA256 for Integrity
  function hashing(string memory name) private 
  pure returns (bytes32) {
    return sha256(bytes(name));
  }
  
  // check name of student in this class
  function checkName(string memory name) public 
  view returns (bool) {
    return listReserve[hashing(name)];
  }

  function getReserved() public view returns(Reserved[] memory){
    return reserved;
  }


}