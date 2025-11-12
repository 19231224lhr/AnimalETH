/*
* 文件名: AnimalHelper_prc3.sol
* 编译器版本: 0.4.19
*/

pragma solidity ^0.4.19;

// 步骤 5.1: 导入 AnimalFeeding_prc3.sol
import "./AnimalFeeding_prc3.sol";

// 步骤 5.1: 定义 AnimalHelper 继承 AnimalFeeding
contract AnimalHelper is AnimalFeeding {

    // 步骤 5.2: 创建一个名为 aboveLevel 的 modifier
    modifier aboveLevel(uint _level, uint _animalId) {
        // 步骤 5.2.a: 检查宠物的 level 是否大于等于 _level
        require(animals[_animalId].level >= _level);
        // 步骤 5.2.b: 执行函数余下的部分
        _;
    }

    // 步骤 6.1: 创建 changeName 函数
    function changeName(uint _AnimalId, string _newName) 
        external 
        aboveLevel(2, _AnimalId) // 只有 level 2 才能调用
    {
        // 检查 msg.sender 是否是宠物主人
        require(msg.sender == animalToOwner[_AnimalId]);
        // 修改名字
        animals[_AnimalId].name = _newName;
    }

    // 步骤 6.2: 创建 changeDna 函数
    function changeDna(uint _AnimalId, uint _newDna) 
        external 
        aboveLevel(20, _AnimalId) // 只有 level 20 才能调用
    {
        // (根据 "与 changeName 几乎相同" 的描述，添加主人检查)
        require(msg.sender == animalToOwner[_AnimalId]);
        // 修改 DNA
        animals[_AnimalId].dna = _newDna;
    }


    // 步骤 7: 创建 getAnimalsByOwner 函数
    function getAnimalsByOwner(address _owner) 
        external 
        view 
        returns (uint[]) 
    {
        // 步骤 7.2: 声明一个内存数组, 长度为该 'owner' 拥有的宠物数量
        uint[] memory result = new uint[](ownerAnimalCount[_owner]);
        
        uint counter = 0;

        // 步骤 7.3: 使用 for 循环遍历所有 'animals'
        for (uint i = 0; i < animals.length; i++) {
            // 将主人为 '_owner' 的宠物 ID 添加到 result
            if (animalToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }

        // 步骤 7.4: 返回 result
        return result;
    }

}