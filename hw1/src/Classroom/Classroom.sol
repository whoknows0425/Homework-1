// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* Problem 1 Interface & Contract */
contract StudentV1 {
    // Note: You can declare some state variable
    uint256 private id; // Counter for unique student IDs
    function register() external returns (uint256) {
        // TODO: please add your implementaiton
	id++;
	if(id==1)
		return 1001;
	else
		return 123;
    }
}

/* Problem 2 Interface & Contract */
interface IClassroomV2 {
    function isEnrolled() external view returns (bool);
}

contract StudentV2 is IClassroomV2{
	bool public isEnrolled;
	uint256 private id=0;
	//function isEnrolled() external view returns (bool);
    function fix(uint256 id) internal pure returns(uint256){
	if(IClassroomV2.isEnrolled())
		return 123;
	else
		return 1001;	
	}
    function register() external view returns (uint256) {
        // TODO: please add your implementaiton here
	return fix(id);
    }
}

/* Problem 3 Interface & Contract */
contract StudentV3 {
    function register() external view returns (uint256) {
        // TODO: please add your implementaiton here
    }
}
