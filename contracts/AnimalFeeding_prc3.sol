/*
* 文件名: AnimalFeeding_prc3.sol
* 编译器版本: 0.4.19
*/

pragma solidity ^0.4.19;

// 导入 prc3 版本的 AnimalIncubators
import "./AnimalIncubators_prc3.sol";

contract AnimalFeeding is AnimalIncubators {

    // (这个函数没有变化)
    function _catchFood(uint _name) internal pure returns (uint) {
        uint rand = uint(keccak256(_name));
        return rand;
    }

    // 步骤 4.3: 修改 feedAndGrow 函数
    // 步骤 4.3.a: 修改可见性为 internal
    function feedAndGrow(uint _AnimalId, uint _targetDna) internal {

        require(msg.sender == animalToOwner[_AnimalId]);
        Animal storage myAnimal = animals[_AnimalId];

        // 步骤 4.3.b: 检查该宠物是否已经冷却完毕 (当前时间 > 宠物的冷却截止时间)
        require(now >= myAnimal.readyTime);

        uint foodDna = _targetDna % dnaLength;
        uint newDna = (myAnimal.dna + foodDna) / 2;
        newDna = (newDna / 100) * 100 + 99;

        // 步骤 4.3.c: 重新设置该宠物的冷却周期 (表示捕食行为完成)
        myAnimal.readyTime = uint32(now + cooldownTime);

        _createAnimal("No-one", newDna);
    }

    // (这个函数没有变化, 它现在调用 internal 的 feedAndGrow)
    function feedOnFood(uint _AnimalId, uint _FoodId) public {
        
        uint foodDna = _catchFood(_FoodId);
        feedAndGrow(_AnimalId, foodDna);
    }

}