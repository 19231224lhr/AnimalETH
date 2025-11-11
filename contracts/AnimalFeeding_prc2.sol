/*
* 文件名: AnimalFeeding_prc2.sol
* 编译器版本: 0.4.19
*/

pragma solidity ^0.4.19;

// 步骤 1.5: 导入基础合约
import "./AnimalIncubators_prc2.sol";

// 步骤 1.5: 建立 AnimalFeeding 合约, 继承 AnimalIncubators
contract AnimalFeeding is AnimalIncubators {

    // 步骤 7: 增加 _catchFood 函数
    function _catchFood(uint _name) internal pure returns (uint) {
        uint rand = uint(keccak256(_name));
        return rand;
    }

    // 步骤 1.6 & 6: 增加 feedAndGrow 函数
    function feedAndGrow(uint _AnimalId, uint _targetDna) public {

        // 步骤 1.6.2: 只有宠物的主人才能喂食
        require(msg.sender == animalToOwner[_AnimalId]);

        // 步骤 1.6.3: 声明一个指向 animals 数组中宠物的 storage 指针
        Animal storage myAnimal = animals[_AnimalId];

        // 步骤 6.1: 取得 _targetDna 的后 dnaDigits (16) 位
        uint foodDna = _targetDna % dnaLength;

        // 步骤 6.2: 计算宠物与食物 DNA 的平均值
        uint newDna = (myAnimal.dna + foodDna) / 2;

        // 步骤 6.3: 将新 DNA 最后两位改为 "99"
        newDna = (newDna / 100) * 100 + 99;

        // 步骤 6.4: 调用 _createAnimal (现在是 internal, 可以调用了)
        // 新宠物名字为 "No-one"
        _createAnimal("No-one", newDna);
    }

    // 步骤 8: 增加 feedOnFood 函数 (组合功能)
    function feedOnFood(uint _AnimalId, uint _FoodId) public {
        
        // 步骤 8.2: 调用 _catchFood, 传入 _FoodId 获得食物 DNA
        uint foodDna = _catchFood(_FoodId);

        // 步骤 8.3: 调用 feedAndGrow, 传入宠物Id 和 食物Dna
        feedAndGrow(_AnimalId, foodDna);
    }

}