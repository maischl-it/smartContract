// SPDX-License-Identifier: CC0-1.0
pragma solidity >=0.7 <0.9;

contract RockPaperScissors {
    address payable player1;
    address payable player2;
    
    bytes32 comm1;
    bytes32 comm2;
    
    uint8 reveal1;
    uint8 reveal2;

    constructor(address payable _player2) payable {
        require(_player2 != msg.sender);
        player1 = payable(msg.sender);
        player2 = _player2;
    }
    
    function commit(bytes32 comm) public {
        require(msg.sender == player1 || msg.sender == player2);
        require(comm != bytes32(0));
        
        if (msg.sender == player1) {
            require(comm1 == bytes32(0));
            comm1 = comm;
        } else {
            require(comm2 == bytes32(0));
            comm2 = comm;
        }
    }
    
    function reveal(uint8 choice, string calldata secret) public {
        require(msg.sender == player1 || msg.sender == player2);
        require(comm1 != bytes32(0) && comm2 != bytes32(0));
        
        bytes32 expected = sha256(
            abi.encodePacked(
                choice2str(choice),
                secret
            )
        );
        
        if (msg.sender == player1) {
            require(expected == comm1 && reveal1 == 0);
            reveal1 = choice;
        } else {
            require(expected == comm2 && reveal2 == 0);
            reveal2 = choice;
        }
    }
    
    
    function finish() public {
        require(reveal1 > 0 && reveal2 > 0);
        selfdestruct(winner());
    }
    
    
    function choice2str(uint8 choice) private pure returns (string memory) {
        if (choice == 1) return "1";
        if (choice == 2) return "2";
        return "3";
    }
    
    
    function winner() private view returns (address payable) {
        if (reveal2 < 1 || reveal2 > 3)
            return player1;
        if (reveal1 < 1 || reveal1 > 3)
            return player2;
        
        if (
            (reveal1 == 1 && reveal2 == 2) || 
            (reveal1 == 2 && reveal2 == 3) || 
            (reveal1 == 3 && reveal2 == 1)    
        )
            return player2;
        else
            return player1;
    }
}
