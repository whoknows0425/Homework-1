// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function setApprovalForAll(address operator, bool approved) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
}

interface IERC721TokenReceiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4);
}

contract NFinTech is IERC721 {
    // Note: I have declared all variables you need to complete this challenge
    string private _name;
    string private _symbol;

    uint256 private _tokenId;

    mapping(uint256 => address) private _owner;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApproval;
    mapping(address => bool) private isClaim;
    mapping(address => mapping(address => bool)) _operatorApproval;

    error ZeroAddress();

    constructor(string memory name_, string memory symbol_) payable {
        _name = name_;
        _symbol = symbol_;
    }

    function claim() public {
        if (isClaim[msg.sender] == false) {
            uint256 id = _tokenId;
            _owner[id] = msg.sender;

            _balances[msg.sender] += 1;
            isClaim[msg.sender] = true;

            _tokenId += 1;
        }
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function balanceOf(address owner) public view returns (uint256) {
        /*require(owner != address(0), "ERROR: address 0 cannot be owner");
        return _balances[owner];*/

	if (owner == address(0)) revert ZeroAddress();
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        /*address owner = _owner[tokenId];
        require(owner != address(0), "ERROR: tokenId is not valid Id");
        return owner;*/

	address owner = _owner[tokenId];
        if (owner == address(0)) revert ZeroAddress();
        return owner;
    }

    function setApprovalForAll(address operator, bool approved) public {
        // TODO: please add your implementaiton here
	if (operator == address(0)) {
            revert ZeroAddress();
        }
        _operatorApproval[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);

	/*require(msg.sender != operator, "ERROR: owner == operator");
        _operatorApproval[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);*/
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        // TODO: please add your implementaiton here
	return _operatorApproval[owner][operator];
    }

    function approve(address to, uint256 tokenId) public {
        // TODO: please add your implementaiton here
	

	address owner = _owner[tokenId];
        require(owner != to, "ERROR: owner == to");
        require(owner == msg.sender || isApprovedForAll(owner, msg.sender), "ERROR: Caller is not token owner / approved for all");
        _tokenApproval[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function getApproved(uint256 tokenId) public view returns (address operator) {
        // TODO: please add your implementaiton here
	address owner = _owner[tokenId];
        require(owner != address(0), "ERROR: Token is not minted or is burn");
        return _tokenApproval[tokenId];
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        // TODO: please add your implementaiton here
	if (to == address(0)) {
            revert ZeroAddress();
        }
        address previousOwner = _update(to, tokenId, msg.sender);
        if (previousOwner != from) {
            revert ZeroAddress();
        }

	//_transfer(from, to, tokenId);
    }

    function _update(address to, uint256 tokenId, address auth) internal virtual returns (address) {
        address from = ownerOf(tokenId);

        // Perform (optional) operator check
        /*if (auth != address(0)) {
            _checkAuthorized(from, auth, tokenId);
        }*/

        // Execute the update
        if (from != address(0)) {
            // Clear approval. No need to re-authorize or emit the Approval event
            _approve(address(0), tokenId, address(0), false);

            unchecked {
                _balances[from] -= 1;
            }
        }

        if (to != address(0)) {
            unchecked {
                _balances[to] += 1;
            }
        }

        _owner[tokenId] = to;

        emit Transfer(from, to, tokenId);

        return from;
    }

    function _approve(address to, uint256 tokenId, address auth, bool emitEvent) internal virtual {
        // Avoid reading the owner unless necessary
        if (emitEvent || auth != address(0)) {
            address owner = _requireOwned(tokenId);

            // We do not use _isAuthorized because single-token approvals should not be able to call approve
            if (auth != address(0) && owner != auth && !isApprovedForAll(owner, auth)) {
                revert ZeroAddress();
            }

            if (emitEvent) {
                emit Approval(owner, to, tokenId);
            }
        }

        _tokenApproval[tokenId] = to;
    }

    function _requireOwned(uint256 tokenId) internal view returns (address) {
        address owner = ownerOf(tokenId);
        if (owner == address(0)) {
            revert ZeroAddress();
        }
        return owner;
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        address owner = _owner[tokenId];
        require(owner == from, "ERROR: Owner is not the from address");
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender) || getApproved(tokenId) == msg.sender, "ERROR: Caller doesn't have permission to transfer");
        delete _tokenApproval[tokenId];
        _balances[from] -= 1;
        _balances[to] += 1;
        _owner[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) public {
        // TODO: please add your implementaiton here
	transferFrom(from, to, tokenId);
	require(_checkOnERC721Received(from, to, tokenId, data), "Receiver not compatible");
}

    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        // TODO: please add your implementaiton here
	transferFrom(from, to, tokenId);
	//require(_checkOnERC721Received(from, to, tokenId, ""), "ERROR: ERC721Receiver is not implmeneted");
    }

    function isContract(address addr) private view returns (bool) {
    uint256 size;
    assembly { size := extcodesize(addr) }
    return size > 0;
  }
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes calldata data) private returns (bool) {
  try IERC721TokenReceiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 response) {
    return response == type(IERC721TokenReceiver).interfaceId;
  } catch (bytes memory reason) {
    // Handle revert reason here (optional)
    return false;
  }
}
}
