// 步骤 2: 指定 Solidity 编译器版本
pragma solidity ^0.4.19;

// 步骤 2: 建立一个基础合约 AnimalIncubators
contract AnimalIncubators {

    // 步骤 7: 定义一个 event 事件 NewAnimal
    event NewAnimal(uint AnimalId, string name, uint dna);

    // 步骤 3: 定义 dna 的位数
    uint dnaDigits = 16;

    // 步骤 4: 建立一个 uint 变量等于 10^16
    uint dnaLength = 10 ** dnaDigits;

    // 步骤 5: 建立一个名为 Animal 的宠物结构体
    struct Animal {
        string name;
        uint dna;
    }

    // 步骤 6: 创建一个 public 的 Animal 结构体数组
    // 当您在一个合约的状态变量（State Variable，即写在函数外面的变量，如 animals 数组）前面加上 public 关键字时，Solidity 就会自动为它创建一个同名的 "getter" 函数（访问器函数）
    Animal[] public animals;

    // 步骤 8: 定义一个 private 的孵化宠物函数
    function _createAnimal(string _name, uint _dna) private {
        
        uint id = animals.push(Animal(_name, _dna)) - 1;

        // (3) 函数结束时触发 NewAnimal 事件
        NewAnimal(id, _name, _dna);
    }

    // 步骤 9: 定义 DNA 生成函数 (私有函数)
    function _generateRandomDna(string _str) private view returns (uint) {
        
        uint rand = uint(keccak256(_str));
        
        return rand % dnaLength;
    }

    // 步骤 10: 定义一个公共函数来组合上面的功能
    function createRandomAnimal(string _name) public {
        
        uint randDna = _generateRandomDna(_name);

        _createAnimal(_name, randDna);
    }

}