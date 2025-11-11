/*
* 文件名: AnimalIncubators_prc2.sol
* 编译器版本: 0.4.19
*/

pragma solidity ^0.4.19;

contract AnimalIncubators {

    event NewAnimal(uint AnimalId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaLength = 10 ** dnaDigits;

    struct Animal {
        string name;
        uint dna;
    }

    Animal[] public animals;

    // 步骤 1.1: 新增 AnimalToOwner 映射 (public)
    mapping (uint => address) public animalToOwner;

    // 步骤 1.2: 新增 ownerAnimalCount 映射
    mapping (address => uint) public ownerAnimalCount;


    // 步骤 1.3 和 6.4: 修改 _createAnimal 函数
    // (1) 属性从 'private' 修改为 'internal'，使其对子合约(AnimalFeeding)可见
    // (2) 增加所有权逻辑
    function _createAnimal(string _name, uint _dna) internal {
        uint id = animals.push(Animal(_name, _dna)) - 1;

        // 步骤 1.3.1: 更新 AnimalToOwner 映射, 记录主人是 msg.sender
        animalToOwner[id] = msg.sender;
        
        // 步骤 1.3.2: 更新主人的宠物计数
        ownerAnimalCount[msg.sender]++;

        // 触发事件
        NewAnimal(id, _name, _dna);
    }

    // (这个函数没有变化，保持 private)
    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaLength;
    }

    // 步骤 1.4: 修改 createRandomAnimal 函数
    function createRandomAnimal(string _name) public {
        
        // 步骤 1.4.1: 判断该用户是否是第一次调用 (宠物数为0)
        require(ownerAnimalCount[msg.sender] == 0);

        uint randDna = _generateRandomDna(_name);
        _createAnimal(_name, randDna);
    }

}