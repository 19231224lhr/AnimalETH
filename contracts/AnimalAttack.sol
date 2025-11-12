/*
* 文件名: AnimalAttack.sol
* (这是本实验的最终合约)
*/

pragma solidity ^0.4.19;

// 步骤 3.1: 导入 AnimalHelper_prc4.sol
// 注意：是导入 prc4 版本的文件
import "./AnimalHelper_prc4.sol";

// 步骤 3.1: 新建 AnimalAttack 继承 AnimalHelper
contract AnimalAttack is AnimalHelper {

    // 步骤 3.3: 新建 PetStates 结构体, 用于记录战绩
    struct PetStates {
        uint winCount;
        uint lossCount;
    }

    // 步骤 3.3: 新建映射来存储每个宠物的战斗状态
    mapping (uint => PetStates) public petStates;

    // 步骤 3 (Page 14, 附带的代码): 随机数函数
    // (我将其设为 internal view, 仅供合约内部调用)
    function random() internal view returns (uint) {
        // 随机生成 0-99 之间的整数
        // (原图是 % 101, 但 % 100 更容易计算 75% 的概率)
        uint randomNum = uint(keccak256(block.timestamp, block.difficulty)) % 100;
        return randomNum;
    }

    // 步骤 3.1 & 3.2: 战斗函数
    function attack(uint _myPetId, uint _opponentPetId) external {
        
        // 检查：必须是自己宠物的主人才能发起攻击
        require(msg.sender == animalToOwner[_myPetId]);

        // 检查：不能攻击自己
        require(_myPetId != _opponentPetId);

        // 获取一个 0-99 的随机数
        uint rand = random();

        // 步骤 3.2 & 3.4: 攻击者获胜 (75% 几率)
        // (rand < 75 意思是 0 到 74, 共 75 个数字)
        if (rand < 75) {
            // 步骤 3.4: 获胜，宠物 level 增加
            animals[_myPetId].level++;
            // 更新双方战绩
            petStates[_myPetId].winCount++;
            petStates[_opponentPetId].lossCount++;
        } 
        // 步骤 3.5: 攻击者失败 (25% 几率)
        else {
            // 步骤 3.5: 失败，只增加失败次数，等级不变
            petStates[_myPetId].lossCount++;
            // 更新对手战绩
            petStates[_opponentPetId].winCount++;
        }
    }
}