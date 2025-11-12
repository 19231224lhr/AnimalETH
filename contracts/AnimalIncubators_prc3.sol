/*
* 文件名: AnimalIncubators_prc3.sol
* 编译器版本: 0.4.19
*/

pragma solidity ^0.4.19;

// 步骤 1: 导入 ownable.sol
import "./ownable.sol";

// 步骤 1: 让 AnimalIncubators 继承 Ownable
contract AnimalIncubators is Ownable {

    event NewAnimal(uint AnimalId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaLength = 10 ** dnaDigits;

    // 步骤 3.1: 声明 "冷却周期" 为 60 秒
    uint cooldownTime = 60 seconds;

    // 步骤 2: 给宠物 struct 增加 level 和 readyTime 属性
    struct Animal {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime; // 喂食的冷却截止时间
    }

    Animal[] public animals;

    mapping (uint => address) public animalToOwner;
    mapping (address => uint) public ownerAnimalCount;


    // 步骤 3.2: 修改 _createAnimal 函数
    function _createAnimal(string _name, uint _dna) internal {
        
        // 步骤 3.2: 新建宠物时，增加冷却周期
        // 注意：新宠物的 level 默认初始化为 0
        //       readyTime 被设置为 (当前时间 + 冷却时间)
        uint32 ready = uint32(now + cooldownTime);
        
        uint id = animals.push(Animal(_name, _dna, 0, ready)) - 1;

        animalToOwner[id] = msg.sender;
        ownerAnimalCount[msg.sender]++;

        NewAnimal(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaLength;
    }

    function createRandomAnimal(string _name) public {
        
        // 步骤 2.1 (来自 image_630b83.png): 暂时注释掉 require 语句
        // require(ownerAnimalCount[msg.sender] == 0);

        uint randDna = _generateRandomDna(_name);
        _createAnimal(_name, randDna);
    }

}