// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./P2P payment.sol";

contract CarPooling is P2PPayment{
    uint public numpassenger;
    uint public rider;

    struct Ride{
        string pickuppoint;
        string departure;
        uint departuretime;
        string destination;
        string vehicletype;
        uint seats;
        uint fare;
    }
    struct Passenger{
        string name;
        uint age;   
    }

    Ride[] public rides;
    Passenger[] public passengers;
    mapping (uint=>address) public rideDriver;
    mapping (uint=>mapping(uint=>address)) public rideTopassenger;

    event rideCreated(
        string pickuppoint,
        string destination,
        uint departuretime,
        string vehicletype,
        uint seats
    );
    event rideBooked(
        uint rideId,
        uint fare,
        address Passenger
    );
    
    function newPassenger(string memory _name, uint _age)   public {
        Passenger memory thispassenger= Passenger(_name,_age);
        passengers.push(thispassenger);
    }
    function creatingRide( string memory _pickuppoint,string memory _vehicletype,string  memory _destination, uint _departuretime, uint _seats) public{
        Ride storage newride= rides[rider];
        rider++;
        newride.pickuppoint=_pickuppoint;
        newride.destination=_destination;
        newride.departuretime=_departuretime;
        newride.vehicletype=_vehicletype;
        newride.seats=_seats;
        emit rideCreated(_pickuppoint, _destination, _departuretime,_vehicletype,_seats );
    }
    function bookingRide(uint _Id,uint _fare,address _Passenger) public{
        rideTopassenger[_Id][rides[_Id].seats]=msg.sender;
        rides[_Id].seats-=1;
        emit rideBooked(_Id, _fare, _Passenger);
    }
}

