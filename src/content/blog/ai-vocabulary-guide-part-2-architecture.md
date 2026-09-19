---
title: "AI 常见词汇科普（二）：模型架构与训练方法"
pubDate: "2026-05-22T08:23:00+08:00"
slug: "ai-vocabulary-guide-part-2-architecture"
tags: ["AI", "科普", "大模型", "术语", "Transformer", "Attention", "Embedding", "Fine-tuning", "LoRA", "MoE", "Token", "Temperature"]
category: "技术"
excerpt: "搞懂基础概念后，是时候深入了解大模型的内部构造了。本文用工程师视角，讲清楚 Transformer、Attention 机制、Embedding、Fine-tuning、LoRA、MoE 等核心架构与训练术语。"
description: "AI 模型架构与训练方法科普：Transformer、Self-Attention、Embedding、预训练、Fine-tuning、LoRA、QLoRA、MoE、Token、Temperature、Top-p 等核心概念的通俗解读。"
---

第一篇我们搞懂了 AI、LLM、AIGC、Prompt、RAG、Agent 这些基础概念。但如果想真正理解大模型为什么能"猜字猜得这么准"，就必须深入到它的**内部架构**和**训练方法**。

这篇文章的目标：**把 Transformer、Attention、Embedding、Fine-tuning、LoRA 等架构和训练相关的核心术语，用工程师能理解的方式讲清楚**。不需要懂数学，不需要会推导，建立直觉就够了。

![大模型知识定位图：Embedding 解决输入表示，Transformer 和 Attention 是模型骨架，预训练和微调决定能力来源，采样参数影响输出风格](/images/ai-vocabulary/ai-transformer-flow.svg)

---

## 一、Transformer / 变换器

Transformer 是当今几乎所有大模型的**基石架构**。GPT、Claude、文心一言、通义千问，底层都是 Transformer。

**Transformer 是一种深度学习模型架构，2017 年由 Google 提出，核心特点是完全基于"注意力机制"（Attention），彻底抛弃了之前的循环神经网络（RNN）和卷积神经网络（CNN）。**

为什么叫"Transformer"？因为它能把输入序列"转换"成输出序列——比如把中文"你好"转换成英文"Hello"，或者把问题"什么是量子力学"转换成答案"量子力学是……"。

Transformer 的革命性在于：

- **并行计算**：训练时，Transformer 能并行处理序列中的多个位置；但聊天时生成回答通常仍要逐 token 进行，不能据此推断固定的提速倍数
- **长距离依赖**：RNN 对长句子的记忆会衰减，Transformer 通过 Attention 可以直接"看到"句子中任意两个词的关系
- **可扩展性**：可以通过增加层数、宽度和训练数据扩大模型规模，但成本也会随之上升

**一句话记住：** Transformer 是大模型的"骨架"，没有它就没有今天的 ChatGPT。

---

## 二、Attention / 注意力机制

Attention 是 Transformer 最核心的创新，也是大模型"理解"语言的秘密武器。

**Attention 机制让模型在处理一个词时，能够"关注"到句子中其他相关的词，并根据相关性给它们分配不同的权重。**

举个直观的例子：

> 句子："猫坐在垫子上，因为它很温暖。"
>
> 问："它"指的是什么？

在这个语境里，“它”可能指垫子；换个上下文也可能指猫。注意力机制让模型结合上下文中的词计算表示，但不能只看某个注意力权重，就断言模型已经正确理解指代。

### 2.1 Self-Attention（自注意力）

Self-Attention 是 Attention 的一种特殊形式，也是 Transformer 使用的版本。

**Self-Attention 让序列中的位置参考其他允许访问的位置，并计算它们之间的关联。** 在生成式模型里，因果掩码会阻止当前位置看到未来的 token；训练时仍可并行计算多个位置。

具体实现上，每个词会被转换成三个向量：
- **Query（查询）**："我要找什么信息？"
- **Key（键）**："我有什么信息？"
- **Value（值）**："我的实际内容是什么？"

然后计算 Query 和 Key 的相似度，得到注意力权重，再用权重加权求和 Value，就得到了这个词的"上下文表示"。

### 2.2 Multi-Head Attention（多头注意力）

**Multi-Head Attention 是 Self-Attention 的升级版，让模型同时从多个角度关注不同的关系。**

比如“苹果”出现在“削皮吃”和“发布新手机”两个句子里，模型需要结合不同上下文判断含义。多个注意力头提供不同的表示子空间，但每个头并没有预先指定“水果”“公司”等固定职责，也不能保证一个头只对应一种可解释的语义。

**一句话记住：** Attention 就是给每个词配了一个"聚光灯"，让它能照亮句子中最相关的其他词。

---

## 三、Embedding / 嵌入

计算机不懂文字，它只懂数字。Embedding 就是把文字转换成数字的桥梁。

**Embedding 是将离散符号或整段文本表示为连续向量的技术。** 在语言模型的输入层，通常是把 token 映射为高维向量；经过 Transformer 后，这些向量会结合上下文变化。向量中的单个数字一般不能直接解释成某个具体语义特征。

### 3.1 为什么 Embedding 有效？

专门为语义检索训练的 Embedding，通常会让语义相近的文本在向量空间中更接近；但这不是所有模型内部向量都保证具备的性质。

例如，用专门的文本检索模型给“北京”和“中国首都”两段文字生成向量，目标是让相关文本更容易被找出来。“开心”和“高兴”也可能比“开心”和“悲伤”更接近，但具体距离取决于模型与训练任务。

这些关系由训练目标和数据分布共同塑造。它适合帮助理解检索 embedding 的直觉，但不能把某个内部 token 向量直接当成可解释的“语义坐标”。

### 3.2 Token Embedding

在大模型中，Embedding 的最小单位不是"字"或"词"，而是 **Token**。

**Token 是模型处理文本的最小单位**，可以是：
- 一个完整的英文单词（如 "the", "apple"）
- 一个中文字符（如 "苹"）
- 甚至是词的一部分（如 "unhappiness" 可能被拆成 "un", "happiness"）

切分方式取决于模型使用的 tokenizer，同一段中文或英文在不同模型中可能得到不同数量的 token。输入层的 token embedding 和用于搜索整段文本的检索 embedding 用途不同。

**一句话记住：** Embedding 是文本的向量表示；模型输入中的 token 向量与检索用的文本向量要分开理解。

---

## 四、预训练（Pre-training）

预训练是大模型"学知识"的过程，也是整个训练中最耗资源、最耗时的阶段。

**预训练是在大量文本上，让模型学习语言模式和通用能力的过程。** 对 GPT 一类自回归 LLM，常见目标是预测下一个 token；BERT 等编码器模型采用遮住部分内容再预测的掩码语言模型目标，两者不是同一流程。

### 4.1 预测下一个字

预训练的过程简单粗暴：

1. 从互联网、书籍、论文、代码中收集数千亿 token 的文本
2. 把前文作为条件，让模型预测下一个 token
3. 根据预测误差更新参数，让正确答案的概率更高
4. 在大量文本上重复训练

比如：
> 输入："中国的首都是__"
> 模型预测："北"
> 正确答案："北"
> → 模型获得正反馈，强化这个模式

通过这种方式，模型逐渐学会了：
- 语法规则（主谓宾结构、时态变化）
- 常识知识（北京是中国首都、水是 H2O）
- 逻辑关系（因果关系、对比关系）
- 甚至某种程度的推理能力

### 4.2 为什么叫"预"训练？

因为这通常只是第一步。预训练后的基础模型已经可能回答部分问题，但通常还不擅长稳定遵循对话指令。

要把基础模型训练成更会遵循指令的助手，通常还会经过后训练：例如用示例做监督微调（SFT），再按人类偏好优化（如 RLHF 或 DPO）。具体步骤因模型而异。

### 4.3 预训练产出了什么？

预训练结束后，主要产物是**模型权重**；要实际运行，还需要模型结构、分词器和推理程序等配套信息。

**这个文件本质上是什么？**

想象一下，你有一个超级厚的字典（词汇表），里面每个词后面都跟着几百到几千个数字：

```
词汇表（10 万个 token）
├── "我" → [0.023, -0.015, 0.008, ...]     （768 个数字）
├── "喜欢" → [-0.003, 0.012, -0.009, ...]  （768 个数字）
├── "苹果" → [0.2, -0.5, 0.8, ...]         （768 个数字）
├── ...
└── "量子力学" → [0.1, 0.3, -0.2, ...]      （768 个数字）
```

这个"词 → 数字向量"的映射表，就是 **Embedding 层**，它是权重文件的一部分。

除此之外，文件里还有：
- **Attention 层的权重**：决定"聚光灯"怎么打
- **前馈网络的权重**：决定如何进一步加工信息
- **输出层的权重**：决定最终预测哪个 token

**文件有多大？**

| 模型 | 参数量 | 文件大小 |
|------|--------|---------|
| GPT-3 | 1750 亿 | 约 350 GB（FP16） |
| Llama-3-8B | 80 亿 | 约 16 GB |
| Llama-3-70B | 700 亿 | 约 140 GB |

**存储格式：**
- `.bin`（PyTorch 格式）
- `.safetensors`（Hugging Face 安全格式）
- `.gguf`（量化压缩格式，适合本地部署）

**一句话：训练产物包含大量权重数值；实际输出还取决于输入上下文、模型配置和解码方式。**

**一句话记住：** 预训练就是给模型"读遍互联网"，让它学会语言的基本规律和常识。

---

## 五、Fine-tuning / 微调

预训练后的模型是"通才"，Fine-tuning 是把它变成"专才"的过程。

**Fine-tuning（微调）是在已有模型基础上继续训练，让它适应某项任务或某个领域。** 按训练方式，可分为更新全部参数的全量微调，以及只训练少量参数的高效微调（如 LoRA）。后训练中的 SFT 也属于微调；“后训练”描述训练阶段，“微调”描述训练方式，两者不是前后相继的两步。

### 5.1 什么时候需要 Fine-tuning？

- **领域适配**：让通用模型学会医学、法律、金融等专业术语和知识
- **风格调整**：让模型生成特定风格的文本（如客服话术、新闻报道、诗歌）
- **任务优化**：提升模型在特定任务上的表现（如代码生成、SQL 查询、情感分析）

### 5.2 Fine-tuning 的代价

Fine-tuning 需要：
- 准备与任务匹配的数据；数据量因任务而异
- 与模型规模和微调方式匹配的算力
- 一定的技术门槛（超参数调优、过拟合防范）

对于只需要接入新资料的场景，可以先试 Prompt 或 RAG；如果需要模型稳定学习特定输出形式或任务行为，再评估微调。具体取舍应以效果测试为准。

**一句话记住：** Fine-tuning 是给通才模型上"专业课"，让它在特定领域表现更好。

### 5.3 过拟合（Overfitting）

**过拟合是机器学习中一个核心问题，指模型"死记硬背"训练数据，而不是学习通用规律。**

#### 通俗理解

想象一个学生准备考试：

- **正常学习** = 理解知识点，能应对各种变体题目
- **过拟合** = 只背下了练习题答案，题目换个数字就不会了

模型也一样：
- **正常训练** = 学到"猫有四条腿、会喵喵叫"的通用特征
- **过拟合** = 只记住了训练集中的那 1000 张猫的照片，遇到新照片就认不出来

#### 为什么会过拟合？

1. **训练数据太少**：模型把有限的数据当成了全部世界
2. **训练轮次太多**：模型把训练集中的噪声和特例也当成了规律
3. **模型太复杂**：参数太多，有足够的能力去"背诵"每一个训练样本

#### 具体例子

**例子 1：图像识别**

你训练一个模型识别"猫"：
- 训练集：1000 张猫的照片，其中 80% 是橘猫
- 过拟合的模型：认为"橘色 = 猫"，看到橘色的狐狸也认为是猫
- 正常的模型：学到"尖耳朵、胡须、肉垫"等通用特征

**例子 2：语言模型微调**

你用 500 条客服对话微调模型：
- 训练数据中所有好评回复都以"感谢您的支持！"结尾
- 过拟合的模型：无论用户说什么，结尾都加"感谢您的支持！"
- 正常的模型：学会根据语境选择合适的结束语

**例子 3：学生成绩预测**

用历史数据预测学生期末成绩：
- 训练数据中发现"穿红色衣服的学生成绩更好"
- 过拟合的模型：把"红色衣服"当成预测特征
- 正常的模型：发现真正相关的是"出勤率"和"作业完成度"

#### 如何发现和防止过拟合？

**发现方法：**

把数据分成两部分：
- **训练集**（80%）：用来训练模型
- **验证集**（20%）：用来测试模型表现

如果模型在训练集上表现很好（准确率 95%），但在验证集上表现很差（准确率 60%），就是过拟合了。

**防止方法：**

| 方法 | 原理 | 类比 |
|------|------|------|
| **早停（Early Stopping）** | 验证集性能不再提升时就停止训练 | 不要复习到大脑麻木 |
| **增加数据** | 让模型看到更多样化的样本 | 多做不同类型的练习题 |
| **Dropout** | 随机忽略一部分神经元，防止依赖特定路径 | 考试时不能带小抄 |
| **正则化** | 惩罚过大的参数值，让模型保持简单 | 不要想得太复杂 |
| **降低模型复杂度** | 用更小的模型 | 小学生不要学大学课程 |

**一句话记住：** 过拟合就是模型"背答案"而不是"学方法"，遇到新题目就露馅。

### 5.4 各种 Training 的关系图

下面这张图展示一条常见的助手模型训练路径；全量微调和 LoRA 是可用于 SFT 或其他微调任务的两种实现方式，不是后训练结束后必经的独立阶段。

<table style="width:100%; border-collapse: collapse; margin: 20px 0; font-size: 14px;">
  <tr>
    <td colspan="2" style="text-align: center; padding: 12px; background: #1e40af; color: white; border-radius: 8px; font-weight: bold; font-size: 16px;">
      📚 预训练（Pre-training）
    </td>
  </tr>
  <tr><td colspan="2" style="height: 4px;"></td></tr>
  <tr>
    <td colspan="2" style="padding: 10px; background: #eff6ff; border-radius: 6px; text-align: center; color: #1e40af; font-size: 13px;">
      海量无标注文本 → 预测下一个 token → 基础权重文件（如 Llama-3-8B-base）
    </td>
  </tr>
  <tr><td colspan="2" style="height: 8px;"></td></tr>
  <tr>
    <td colspan="2" style="text-align: center; color: #94a3b8; font-size: 20px;">↓ 基础模型诞生</td>
  </tr>
  <tr><td colspan="2" style="height: 8px;"></td></tr>
  <tr>
    <td colspan="2" style="text-align: center; padding: 12px; background: #166534; color: white; border-radius: 8px; font-weight: bold; font-size: 16px;">
      🎓 Post-training（后训练）
    </td>
  </tr>
  <tr><td colspan="2" style="height: 4px;"></td></tr>
  <tr>
    <td colspan="2" style="padding: 10px; background: #f0fdf4; border-radius: 6px; text-align: center; color: #166534; font-size: 13px;">
      SFT（监督微调，可用全量或 LoRA）→ 可选的偏好优化（如 RLHF / DPO）→ 助手模型
    </td>
  </tr>
  <tr><td colspan="2" style="height: 8px;"></td></tr>
  <tr>
    <td colspan="2" style="text-align: center; color: #94a3b8; font-size: 16px;">方法说明：SFT 或后续任务适配可选择全量微调或 LoRA</td>
  </tr>
  <tr><td colspan="2" style="height: 8px;"></td></tr>
  <tr>
    <td style="width: 50%; vertical-align: top; padding: 8px;">
      <div style="background: #fef3c7; border: 2px solid #f59e0b; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #92400e; margin-bottom: 8px; text-align: center;">🔧 全量微调</div>
        <ul style="margin: 0; padding-left: 16px; color: #78350f; line-height: 1.8; font-size: 13px;">
          <li>修改全部参数</li>
          <li>显存和算力需求通常更高</li>
          <li>可用于 SFT 或领域适配</li>
        </ul>
      </div>
    </td>
    <td style="width: 50%; vertical-align: top; padding: 8px;">
      <div style="background: #e0e7ff; border: 2px solid #6366f1; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #3730a3; margin-bottom: 8px; text-align: center;">⚡ LoRA（低秩适配）</div>
        <ul style="margin: 0; padding-left: 16px; color: #312e81; line-height: 1.8; font-size: 13px;">
          <li>只训练新增小模块</li>
          <li>硬件需求取决于模型和配置</li>
          <li>也可用于 SFT 或领域适配</li>
        </ul>
      </div>
    </td>
  </tr>
  <tr><td colspan="2" style="height: 8px;"></td></tr>
  <tr>
    <td colspan="2" style="text-align: center; color: #94a3b8; font-size: 20px;">↓ 得到模型权重或适配器</td>
  </tr>
  <tr><td colspan="2" style="height: 8px;"></td></tr>
  <tr>
    <td colspan="2" style="text-align: center; padding: 12px; background: #1e293b; color: white; border-radius: 8px; font-weight: bold; font-size: 16px;">
      🚀 部署到生产环境（API 服务 / 本地运行 / 边缘设备）
    </td>
  </tr>
</table>

**关系总结：**

| 训练类型 | 修改范围 | 数据需求 | 算力需求 | 最终产物 |
|---------|---------|---------|---------|---------|
| **预训练** | 从头训练模型参数 | 大量数据 | 通常很高 | 基础模型（Base） |
| **Post-training** | 预训练后的阶段，可包含 SFT、偏好优化等 | 视目标而定 | 视模型与方法而定 | 助手或任务模型 |
| **Fine-tuning** | 对已有模型继续训练；SFT 是其中一种 | 视任务而定 | 视模型与策略而定 | 更新后的模型或适配器 |
| **LoRA** | 微调的一种参数高效实现，可用于 SFT | 视任务而定 | 通常降低显存需求，仍需按模型估算 | LoRA 适配器文件 |

**关键理解：**
- **预训练**是"打地基"，决定了模型的知识储备和语言能力
- **Post-training**是预训练后的训练阶段，通常包含 SFT，也可能包含偏好优化
- **Fine-tuning**是继续训练已有模型的方法；**LoRA** 是其中一种实现方式
- 数据和算力需求取决于模型规模、训练目标与实现方式，没有固定的递减规律

---

## 六、LoRA / 低秩适配（Low-Rank Adaptation）

Fine-tuning 的一个主要问题是：需要调整的参数太多了。GPT-3 有 1750 亿参数，全量微调需要巨大的显存和算力。

**LoRA 是一种参数高效的微调方法，它只训练少量新增参数，而不是修改模型原有的参数。**

### 6.1 LoRA 的原理

#### 什么是 Low-Rank（低秩）？

**Rank（秩）是线性代数中的一个概念，描述一个矩阵包含多少"独立信息"。**

举个直观的例子：

**高秩矩阵**（信息丰富）：
```
┌───┬───┬───┐
│ 1 │ 2 │ 3 │    每一行都是独立的，无法互相推导
├───┼───┼───┤
│ 4 │ 5 │ 6 │    秩 = 2（有2行独立信息）
├───┼───┼───┤
│ 7 │ 8 │ 9 │
└───┴───┴───┘
```

**低秩矩阵**（信息冗余）：
```
┌───┬───┬───┐
│ 1 │ 2 │ 3 │    第2行 = 第1行 × 2
├───┼───┼───┤
│ 2 │ 4 │ 6 │    第3行 = 第1行 × 3
├───┼───┼───┤    虽然看起来有9个数字，但本质只有1行信息
│ 3 │ 6 │ 9 │    秩 = 1（只有1行独立信息）
└───┴───┴───┘
```

**关键洞察**：低秩矩阵可以用两个更小的矩阵相乘来表示。

比如上面的 3×3 低秩矩阵，可以拆成：
```
┌───┬───┬───┐   ┌───┐   ┌───┬───┬───┐
│ 1 │ 2 │ 3 │   │ 1 │   │ 1 │ 2 │ 3 │
├───┼───┼───┤ = │ 2 │ × │   │   │   │
│ 2 │ 4 │ 6 │   │ 3 │   └───┴───┴───┘
├───┼───┼───┤   └───┘
│ 3 │ 6 │ 9 │
└───┴───┴───┘
  (3×3)        (3×1)      (1×3)
```

原来需要存 9 个数字，现在只需要存 3 + 3 = 6 个数字。

#### LoRA 如何利用低秩？

LoRA 的核心假设：**模型参数的变化（ΔW）是低秩的**。

也就是说，当你微调一个模型时，参数的实际变化不需要修改全部数百亿个数字——只需要一个"低秩近似"就够了。

**具体实现：**

```
原始权重矩阵 W（比如 4096×4096 = 1600万参数）
    ↓
冻结 W，不修改
    ↓
新增两个小子矩阵：
  - A: 4096 × r  （r 通常 = 8 或 16）
  - B: r × 4096
    ↓
只训练 A 和 B，总共只需要训练 4096×8 + 8×4096 = 65536 参数
    ↓
推理时：新输出 = W×输入 + A×B×输入
```

**r（秩）的选择：**
- r 较小：可训练参数更少，表达空间也更有限
- r 较大：可训练参数更多，但显存和计算开销随之增加

r 需要根据目标模块、数据与效果测试选择；调大 r 不保证效果一定接近全量微调。

**一句话：Low-Rank 就是"用少量关键信息代替全部信息"。LoRA 利用这个原理，用两个小子矩阵代替修改整个大矩阵，从而大幅降低微调成本。**

#### LoRA 直观对比图

<table style="width:100%; border-collapse: collapse; margin: 20px 0; font-size: 14px;">
  <tr>
    <td style="width: 50%; vertical-align: top; padding: 8px;">
      <div style="background: #fee2e2; border: 2px solid #ef4444; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #991b1b; margin-bottom: 8px; text-align: center;">❌ 全量 Fine-tuning</div>
        <ul style="margin: 0; padding-left: 16px; color: #7f1d1d; line-height: 1.8; font-size: 13px;">
          <li>更新全部模型参数</li>
          <li>显存与算力需求很高</li>
          <li>训练时长取决于模型和数据</li>
          <li>通常要保存完整模型权重</li>
          <li>资源开销通常较大</li>
        </ul>
      </div>
    </td>
    <td style="width: 50%; vertical-align: top; padding: 8px;">
      <div style="background: #dcfce7; border: 2px solid #22c55e; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #166534; margin-bottom: 8px; text-align: center;">✅ LoRA</div>
        <ul style="margin: 0; padding-left: 16px; color: #14532d; line-height: 1.8; font-size: 13px;">
          <li>只训练少量新增参数</li>
          <li>通常显著降低显存需求</li>
          <li>具体配置取决于模型和量化</li>
          <li>适配器通常比完整模型小</li>
          <li>仍需加载基础模型</li>
        </ul>
      </div>
    </td>
  </tr>
</table>

**核心原理一句话：**  frozen W（冻结大矩阵） +  train A×B（训练小子矩阵） =  低成本微调大模型

### 6.2 LoRA 的优势

- **显存友好**：训练参数较少，但能否在消费级 GPU 上运行取决于基础模型大小、量化、序列长度等配置
- **训练开销较低**：可训练参数少，但训练总时长和收敛效果仍取决于任务
- **模型体积小**：LoRA 权重通常只有几 MB 到几百 MB
- **可切换**：一个基础模型 + 多个 LoRA 权重，可以灵活切换不同任务

### 6.3 QLoRA

**QLoRA 是 LoRA 的一种量化训练方案，进一步降低了显存需求。** 它以低比特量化加载基础模型，再训练 LoRA 适配层。具体能微调多大的模型取决于量化方式、上下文长度、batch、优化器和硬件；应先按实际配置做显存估算。

**一句话记住：** LoRA 是"小改动大效果"的微调方法，用少量新增参数让大模型适应新任务，省钱又高效。

---

## 七、MoE / 混合专家模型（Mixture of Experts）

MoE 并非近年才出现，但随着大模型发展再次受到关注。

**MoE 是一种模型架构，在部分网络层设置多个“专家”子网络，每个 token 通常只由选中的一部分专家处理，以减少相对于全部专家都参与计算时的计算量。** 共享层仍会参与计算。

### 7.1 为什么需要 MoE？

扩大模型规模有时能提升能力，但通常也会增加训练、存储或推理成本。闭源模型的具体架构与参数规模若未公开，不宜据传闻下结论。

MoE 的解决方案：不激活全部参数，只激活最相关的部分。

### 7.2 MoE 的工作方式

想象一个医院：
- 传统大模型 = 每个病人都看全科医生（所有参数都参与计算）
- MoE = 病人先被分诊到相关科室，只看对应的专科医生（只激活相关专家）

具体实现：
1. 模型被分成多个"专家"子网络（比如 8 个或 16 个）
2. 输入数据先经过一个"门控网络"（Gating Network），决定激活哪些专家
3. 只有被选中的专家参与计算，其他专家休眠
4. 最后把选中专家的输出加权组合

Mixtral 等公开模型采用了 MoE 架构。以 Mixtral 8x7B 为例，它有 8 个专家、每个 token 选择其中 2 个；实际速度仍会受到路由、通信、显存与实现方式影响，不能简单等同于某个稠密模型。

**一句话记住：** MoE 通过按 token 选择专家，减少每次计算所用的专家参数；实际速度和成本仍取决于实现与硬件。

### 7.3 MoE 直观对比图

<table style="width:100%; border-collapse: collapse; margin: 20px 0; font-size: 14px;">
  <tr>
    <td style="width: 50%; vertical-align: top; padding: 8px;">
      <div style="background: #fee2e2; border: 2px solid #ef4444; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #991b1b; margin-bottom: 8px; text-align: center;">❌ 传统 Dense 模型</div>
        <ul style="margin: 0; padding-left: 16px; color: #7f1d1d; line-height: 1.8; font-size: 13px;">
          <li>所有参数全部激活</li>
          <li>每次推理使用全部参数</li>
          <li>与同规模 MoE 的成本不能直接比较</li>
          <li>像全科医生看所有病</li>
          <li>具体开销取决于模型规模</li>
        </ul>
      </div>
    </td>
    <td style="width: 50%; vertical-align: top; padding: 8px;">
      <div style="background: #dcfce7; border: 2px solid #22c55e; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #166534; margin-bottom: 8px; text-align: center;">✅ MoE 模型</div>
        <ul style="margin: 0; padding-left: 16px; color: #14532d; line-height: 1.8; font-size: 13px;">
          <li>只激活部分专家</li>
          <li>每个 token 选中部分专家</li>
          <li>计算量减少，但路由与访存仍有成本</li>
          <li>像专科医生按需会诊</li>
          <li>实际收益取决于部署条件</li>
        </ul>
      </div>
    </td>
  </tr>
</table>

**以 Mixtral 8x7B 为例：** 门控网络为每个 token 选择 2 个专家，再结合它们的输出；其他 MoE 模型选中的专家数量可能不同。

---

## 八、Temperature / Top-p / Top-k

这三个参数是控制模型输出"随机性"的旋钮，也是 Prompt Engineering 中经常调整的超参数。

### 8.1 Temperature（温度）

**Temperature 调整下一个 token 的概率分布，影响采样时的随机程度。** 可用范围由模型或 API 决定，不存在统一的 0 到 2 限制。

- **Temperature = 0**：通常采用贪心选取，随机性较低；具体实现仍可能产生不同输出
- **Temperature = 0.7**：一种中等随机性的常见起点；不同模型和任务应通过测试确定
- **Temperature 较高**：低概率词被采样的机会增加，输出可能更发散

类比：Temperature 就像厨师的"创意程度"。温度低 = 严格按照菜谱做；温度高 = 自由发挥，可能惊喜也可能翻车。

### 8.2 Top-p（Nucleus Sampling）

**Top-p 是另一种控制随机性的方法，它从累积概率达到 p 的最小词集合中采样。**

比如 Top-p = 0.9：
1. 模型预测下一个词的概率分布
2. 按概率从高到低排序
3. 选取累积概率达到 90% 的最小词集合
4. 只在这个集合中随机选择

Top-p 会随概率分布调整候选集合大小；它与 Temperature 作用不同，不能简单说哪一个“更智能”。

### 8.3 Top-k

**Top-k 是最简单的采样方法，只从概率最高的 k 个词中随机选择。**

比如 Top-k = 50：只考虑概率最高的 50 个词，其他的全部忽略。

**一句话记住：** Temperature、Top-p 和 Top-k 只是在调节采样分布；事实可靠性仍要靠检索、验证与评估，而不是靠某个“万能参数”。

### 8.4 Temperature 直观对比图

<table style="width:100%; border-collapse: collapse; margin: 20px 0; font-size: 14px;">
  <tr>
    <td style="width: 33%; vertical-align: top; padding: 8px;">
      <div style="background: #dbeafe; border: 2px solid #3b82f6; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #1e40af; margin-bottom: 8px; text-align: center;">🧊 Temperature = 0</div>
        <ul style="margin: 0; padding-left: 16px; color: #1e3a8a; line-height: 1.8; font-size: 13px;">
          <li>采样随机性较低</li>
          <li>输出仍可能因服务实现而变化</li>
          <li>适合需要稳定格式的任务</li>
          <li>🤖 像严格执行的机器人</li>
        </ul>
      </div>
    </td>
    <td style="width: 33%; vertical-align: top; padding: 8px;">
      <div style="background: #dcfce7; border: 2px solid #22c55e; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #166534; margin-bottom: 8px; text-align: center;">🌡️ Temperature = 0.7（常见起点）</div>
        <ul style="margin: 0; padding-left: 16px; color: #14532d; line-height: 1.8; font-size: 13px;">
          <li>候选词选择更有变化</li>
          <li>每次输出略有不同</li>
          <li>适合：对话、写作、头脑风暴</li>
          <li>👨‍🍳 像有经验的厨师</li>
        </ul>
      </div>
    </td>
    <td style="width: 33%; vertical-align: top; padding: 8px;">
      <div style="background: #fef3c7; border: 2px solid #f59e0b; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #92400e; margin-bottom: 8px; text-align: center;">🔥 Temperature = 1.0+</div>
        <ul style="margin: 0; padding-left: 16px; color: #78350f; line-height: 1.8; font-size: 13px;">
          <li>更容易选到低概率词</li>
          <li>输出随机性很大</li>
          <li>适合：诗歌、创意写作</li>
          <li>🎨 像疯狂的艺术家</li>
        </ul>
      </div>
    </td>
  </tr>
</table>

**示意输出（仅说明可能的风格变化，不代表调参必然得到这些答案）：**

| 温度 | 输入 | 输出 |
|------|------|------|
| **0** | "描述一只猫" | "猫是一种小型哺乳动物，属于猫科动物。" |
| **0.7** | "描述一只猫" | "一只橘色的猫咪正懒洋洋地躺在窗台上，尾巴轻轻摇晃。" |
| **1.2** | "描述一只猫" | "月光下，一只银灰色的猫影掠过屋顶，眼中闪烁着星辰的光芒。" |

**一句话：** Temperature 主要影响采样随机性；数值应按任务测试，低温也不能保证事实正确。

---

## 九、Epoch / Batch / Learning Rate

这三个是训练过程中的基础概念，理解它们有助于调优模型训练。

### 9.1 Epoch（轮次）

**Epoch 指把整个训练数据集完整过一遍。**

比如训练数据有 10 万条，Epoch = 3 表示每条数据被模型看了 3 遍。Epoch 太少模型学不够，太多会过拟合。

### 9.2 Batch（批次）

**Batch 是每次更新模型参数时使用的数据量。**

比如 Batch Size = 32，表示模型每次看 32 条数据，计算平均梯度，然后更新一次参数。

- Batch 太小：训练不稳定，收敛慢
- Batch 太大：显存不够，泛化能力下降

### 9.3 Learning Rate（学习率）

**Learning Rate 控制每次参数更新的步长。**

- 学习率太高：模型"步子太大"，可能跳过最优解，甚至发散
- 学习率太低：模型"步子太小"，训练极慢，可能陷入局部最优

现代训练通常使用"学习率预热 + 衰减"策略：开始慢慢升温，中间保持高速，最后逐渐降温。

**一句话记住：** Epoch 是"学几遍"，Batch 是"一次学多少"，Learning Rate 是"每次迈多大步"。

---

## 小结

把这九个概念串起来，你就理解了大模型的"内部构造"：

| 概念 | 定位 | 一句话 |
|------|------|--------|
| **Transformer** | 基础架构 | 大模型的骨架 |
| **Attention** | 核心机制 | 给每个词配聚光灯 |
| **Embedding** | 表示方法 | 文字的身份证号 |
| **预训练** | 学习过程 | 读遍互联网 |
| **Fine-tuning** | 适配方法 | 上专业课 |
| **LoRA** | 高效微调 | 小改动大效果 |
| **MoE** | 架构优化 | 按需激活专家 |
| **Temperature** | 输出控制 | 调节创意程度 |
| **Epoch/Batch/LR** | 训练参数 | 学几遍、学多少、迈多大步 |

**推荐阅读：**

- 还没看第一篇？→ 《[AI 常见词汇科普（一）：基础概念篇](/blog/ai-vocabulary-guide-part-1-basics)》
- 想了解工程落地？→ 《[AI 常见词汇科普（三）：工程落地与生态工具](/blog/ai-vocabulary-guide-part-3-engineering)》

---

*继续阅读：[第三篇：工程落地与生态工具](/blog/ai-vocabulary-guide-part-3-engineering)，以及[第四篇：上下文、工具调用与 MCP](/blog/ai-vocabulary-guide-part-4-context-tools)。*
