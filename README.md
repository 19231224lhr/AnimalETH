# 🐾 Solidity 宠物孵化器 (Crypto-Pet Incubator)

这是一个基于 Solidity `^0.4.19` 版本的智能合约实验项目，旨在模拟一个“加密宠物”孵化、养成、升级和战斗的游戏。

项目从最基础的宠物创建开始，通过多层合约的**继承**，逐步迭代，最终实现了一个包含所有权、喂食冷却、`payable` 升级、管理员提现和宠物战斗功能的 DApp 后端。

## 🚀 主要功能

本项目实现的核心功能包括：

* **宠物创建:**
    * 使用 `keccak256` 基于宠物名字生成一个伪随机的 `uint` 作为宠物 DNA。
    * 每只新创建的宠物都会被添加到一个 `Animal` 结构体数组中。

* **所有权系统:**
    * 使用两个 `mapping` 来追踪宠物的所有权：
        * `animalToOwner (uint => address)`: 记录宠物 ID 对应的主人地址。
        * `ownerAnimalCount (address => uint)`: 记录每个地址拥有的宠物数量。

* **宠物交互 (喂食 & 冷却):**
    * 宠物可以“喂食” (`feedAndGrow`)，喂食后会根据宠物和食物的 DNA 生成一只新宠物（名为 "No-one"）。
    * 引入了 `readyTime` (冷却截止时间) 状态，宠物两次喂食之间必须等待 60 秒，否则交易将 `revert`。

* **等级与升级 (Payable):**
    * 宠物拥有 `level` 属性，初始为 `0`。
    * 用户可以支付 `powerUpFee`（默认为 0.001 ETH）来调用 `payable` 函数 `powerUp`，使宠物等级 `level++`。

* **访问控制 (Modifier):**
    * **`onlyOwner`**: 继承自 `Ownable` 合约，用于保护 `withdraw` 和 `setPowerUpFee` 等关键的管理员函数，确保只有合约的部署者才能调用。
    * **`aboveLevel`**: 自定义修饰符，用于限制特定功能（如 `changeName` 需要 2 级，`changeDna` 需要 20 级）必须在宠物达到一定等级后才能使用。

* **战斗系统:**
    * `AnimalAttack` 合约实现了 `attack` 功能，允许玩家选择自己的宠物和对手的宠物进行战斗。
    * 攻击方有 75% 的几率获胜（基于 `block.timestamp` 生成的伪随机数）。
    * 获胜方的宠物等级 `level++`，并使用 `PetStates` 结构体记录双方的 `winCount` (胜利) 和 `lossCount` (失败) 次数。

* **合约盈利与提现:**
    * 合约所有者（Owner）可以通过 `withdraw` 函数提取合约中因 `powerUp` 而累积的所有 ETH 余额。
    * 所有者也可以通过 `setPowerUpFee` 函数来动态调整升级所需的费用。

## 📂 文件结构

本项目由 5 个合约文件组成，它们之间通过 `import` 和 `inheritance`（继承）关联：

1.  `ownable.sol`:
    * 基础合约，提供了 `owner` 状态变量和 `onlyOwner` 修饰符，用于管理合约所有权。

2.  `AnimalIncubators_prc3.sol`:
    * 继承自 `Ownable`。
    * 定义了 `Animal` 结构体（包含 `dna`, `level`, `readyTime` 等）。
    * 实现了 `createRandomAnimal` 基础创建功能。

3.  `AnimalFeeding_prc3.sol`:
    * 继承自 `AnimalIncubators`。
    * 实现了 `feedAndGrow` 和 `feedOnFood` 功能，并增加了喂食的**冷却时间**逻辑。

4.  `AnimalHelper_prc4.sol`:
    * 继承自 `AnimalFeeding`。
    * 增加了 **`payable`** 升级函数 `powerUp`。
    * 增加了管理员函数 `withdraw` 和 `setPowerUpFee`。
    * 增加了 `aboveLevel` 修饰符和 `getAnimalsByOwner`（查询功能）。

5.  `AnimalAttack.sol`:
    * 继承自 `AnimalHelper`。
    * **这是本项目的最终合约。**
    * 实现了 `attack` 战斗系统和 `PetStates` 战绩记录。

## 🛠️ 如何运行 (使用 Remix)

1.  **创建文件**: 在 Remix IDE 中创建上述全部 5 个 `.sol` 文件，并确保它们在同一个工作区（文件夹）中。
2.  **选择编译器**:
    * 转到 "Solidity Compiler" (  ) 选项卡。
    * 设置 "Compiler" 版本为 `0.4.19` (或任何 `^0.4.19` 兼容的版本)。
3.  **选择合约进行编译**:
    * 在 "CONTRACT" 下拉菜单中，**选择 `AnimalAttack`**。
    * 点击 "Compile" (编译)。
4.  **部署合约**:
    * 切换到 "Deploy & Run" (  ) 选项卡。
    * 在 "CONTRACT" 下拉菜单中，**再次确保选择的是 `AnimalAttack`**（它继承了其他所有合约的功能）。
5.  **开始交互**:
    * 点击 "Deploy" 部署合约。
    * 在下方的 "Deployed Contracts" 面板中，您可以看到所有 `public` 和 `external` 函数，可以开始创建、喂食、升级和战斗您的宠物。