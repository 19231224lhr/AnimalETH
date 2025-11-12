/*
* 文件名: ownable.sol
* 编译器版本: 0.4.19
*/

pragma solidity ^0.4.19;

contract Ownable {
    
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // 构造函数
    function Ownable() public {
        owner = msg.sender;
    }

    // 修饰符
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // 转移所有权函数
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        
        // 修正: 移除了 'emit' 关键字
        OwnershipTransferred(owner, newOwner); 
        
        owner = newOwner;
    }
}