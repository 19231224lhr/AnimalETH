/*
* 文件名: AnimalHelper_prc4.sol
* (这是 prc3 的升级版, 继承自 AnimalFeeding_prc3)
*/

pragma solidity ^0.4.19;

// 导入 prc3 的 AnimalFeeding
import "./AnimalFeeding_prc3.sol";

// AnimalHelper 继承 AnimalFeeding
// (它自动拥有了 prc3 合约中的 'onlyOwner' 和 'animals' 等)
contract AnimalHelper is AnimalFeeding {

    // --- START: 来自 prc3 的代码 ---
    // (我们把 prc3 的功能复制过来)

    modifier aboveLevel(uint _level, uint _animalId) {
        require(animals[_animalId].level >= _level);
        _;
    }

    function changeName(uint _AnimalId, string _newName) 
        external 
        aboveLevel(2, _AnimalId)
    {
        require(msg.sender == animalToOwner[_AnimalId]);
        animals[_AnimalId].name = _newName;
    }

    function changeDna(uint _AnimalId, uint _newDna) 
        external 
        aboveLevel(20, _AnimalId)
    {
        require(msg.sender == animalToOwner[_AnimalId]);
        animals[_AnimalId].dna = _newDna;
    }

    function getAnimalsByOwner(address _owner) 
        external 
        view 
        returns (uint[]) 
    {
        uint[] memory result = new uint[](ownerAnimalCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < animals.length; i++) {
            if (animalToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
    // --- END: 来自 prc3 的代码 ---


    // --- START: prc4 的新增代码 ---

    // 步骤 1.1 (Page 12): 定义 powerUpFee 变量, 设为 0.001 ether
    // 'public' 关键字让我们可以在 Remix 中直接查看它的值
    uint public powerUpFee = 0.001 ether;

    // 步骤 1.2 (Page 12): 定义 powerUp 函数
    // 'payable' 关键字允许此函数接收 ETH
    function powerUp(uint _animalId) external payable {
        
        // 步骤 1.3: 确保支付的 ETH (msg.value) 等于 powerUpFee
        require(msg.value == powerUpFee);
        
        // (额外检查: 确保是宠物主人才能升级)
        require(msg.sender == animalToOwner[_animalId]);

        // 步骤 1.4: 增加宠物 level
        animals[_animalId].level++;
    }

    // 步骤 2.1 (Page 13): 创建 withdraw 函数
    // (这个函数将合约中的所有 ETH 提现给 'owner')
    // 'onlyOwner' 修饰符继承自 Ownable -> AnimalIncubators
    function withdraw() external onlyOwner {
        // 'owner' 是从 'Ownable' 合约中继承来的
        owner.transfer(address(this).balance);
    }

    // 步骤 2.3 (Page 13): 创建 setPowerUpFee 函数
    function setPowerUpFee(uint _fee) external onlyOwner {
        // 步骤 2.4: 将 powerUpFee 等于 _fee
        // (注意: _fee 的单位是 wei。 1 ETH = 1e18 wei)
        powerUpFee = _fee;
    }
    // --- END: prc4 的新增代码 ---
}