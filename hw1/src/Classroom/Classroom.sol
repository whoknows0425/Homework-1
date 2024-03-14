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
    function updateID(uint256 newID) external {
    id = 123;
  }
}

/* Problem 2 Interface & Contract */
interface IClassroomV2 {
    function isEnrolled() external view returns (bool);
}

contract StudentV2 {
	bool public enrolled = false;
    function register() external view returns (uint256) {
        // TODO: please add your implementaiton here
	return 0;
    }
    function setIsEnrolled(IClassroomV2 classroom) public {
    enrolled = classroom.isEnrolled(); // Call ClassroomV2's function to check enrollment
  }
}

/* Problem 3 Interface & Contract */
contract StudentV3 {
    function register() external view returns (uint256) {
        // TODO: please add your implementaiton here
    }
}
