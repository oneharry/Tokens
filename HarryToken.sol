// SPDX-License-Identifier: MLT;

pragma solidity ^0.8.0;

import "github/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";


interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Approval(address indexed from, address indexed to, uint256 value);
    event Transfer(address indexed owner, address indexed spender, uint256 value);
}


contract HarryToken is IERC20 {

    using SafeMath for uint256;

    string public constant name = "Harry ERC20 Token";
    string public constant symbol = "HRET";
    uint256 public constant decimal = 18;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    uint256 totalTokenSupply;



    constructor(uint256 total) {
        totalTokenSupply = total;
        balances[msg.sender] = totalTokenSupply;
    }



    function totalSupply() public override view returns (uint256) {
        return totalTokenSupply;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }


    // BUY TOKEN FUNCTION. Buys token when ether is sent
    function buyToken(address receiver) public payable {
        uint256 tokens; 

        tokens = msg.value * 1000; //1000 tokens buys an ETH

        balances[receiver] = balances[receiver] + tokens;// add tokens bought to receivers balance

        totalTokenSupply = totalTokenSupply + tokens; //increment total supply with number of tokens bought
    }

}