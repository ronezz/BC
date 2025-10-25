// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.30;
contract TokenContract {

    address public owner;
    struct Receivers {
        string name;
        uint256 tokens;
    }

    mapping(address => Receivers) public users;

    uint256 public constant TOKEN_PRICE = 5 ether;

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor(){
        owner = msg.sender;
        users[owner].tokens = 100;
    }

    function double(uint _value) public pure returns (uint){
        return _value * 2;
    }

    function register(string memory _name) public {
        users[msg.sender].name = _name;
    }

    function giveToken(address _receiver, uint256 _amount) public onlyOwner {
        require(users[owner].tokens >= _amount, "Not enough tokens");
        users[owner].tokens -= _amount;
        users[_receiver].tokens += _amount;
    }

    function buyTokens() public payable {
        uint256 tokensToBuy = msg.value / TOKEN_PRICE;
        require(tokensToBuy > 0, "Not enough Ether sent");
        require(users[owner].tokens >= tokensToBuy, "Owner does not have enough tokens");
        users[owner].tokens -= tokensToBuy;
        users[msg.sender].tokens += tokensToBuy;
    }

    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
