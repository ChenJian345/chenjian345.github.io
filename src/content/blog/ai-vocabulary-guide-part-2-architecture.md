---
title: "AI 常见词汇科普（二）：模型架构与训练方法"
pubDate: "2026-05-21"
slug: "ai-vocabulary-guide-part-2-architecture"
tags: ["AI", "科普", "大模型", "术语", "Transformer", "Attention", "Embedding", "Fine-tuning", "LoRA", "MoE", "Token", "Temperature"]
category: "技术"
excerpt: "搞懂基础概念后，是时候深入了解大模型的内部构造了。本文用工程师视角，讲清楚 Transformer、Attention 机制、Embedding、Fine-tuning、LoRA、MoE 等核心架构与训练术语。"
description: "AI 模型架构与训练方法科普：Transformer、Self-Attention、Embedding、预训练、Fine-tuning、LoRA、QLoRA、MoE、Token、Temperature、Top-p 等核心概念的通俗解读。"
---

第一篇我们搞懂了 AI、LLM、AIGC、Prompt、RAG、Agent 这些基础概念。但如果想真正理解大模型为什么能"猜字猜得这么准"，就必须深入到它的**内部架构**和**训练方法**。

这篇文章的目标：**把 Transformer、Attention、Embedding、Fine-tuning、LoRA 等架构和训练相关的核心术语，用工程师能理解的方式讲清楚**。不需要懂数学，不需要会推导，建立直觉就够了。

---

## 一、Transformer / 变换器

Transformer 是当今几乎所有大模型的**基石架构**。GPT、Claude、文心一言、通义千问，底层都是 Transformer。

**Transformer 是一种深度学习模型架构，2017 年由 Google 提出，核心特点是完全基于"注意力机制"（Attention），彻底抛弃了之前的循环神经网络（RNN）和卷积神经网络（CNN）。**

为什么叫"Transformer"？因为它能把输入序列"转换"成输出序列——比如把中文"你好"转换成英文"Hello"，或者把问题"什么是量子力学"转换成答案"量子力学是……"。

Transformer 的革命性在于：

- **并行计算**：RNN 必须一个字一个字地算，Transformer 可以一次性处理整个句子，速度提升数百倍
- **长距离依赖**：RNN 对长句子的记忆会衰减，Transformer 通过 Attention 可以直接"看到"句子中任意两个词的关系
- **可扩展性**：这个架构可以堆叠到上千层，参数规模可以扩展到万亿级别

**一句话记住：** Transformer 是大模型的"骨架"，没有它就没有今天的 ChatGPT。

---

## 二、Attention / 注意力机制

Attention 是 Transformer 最核心的创新，也是大模型"理解"语言的秘密武器。

**Attention 机制让模型在处理一个词时，能够"关注"到句子中其他相关的词，并根据相关性给它们分配不同的权重。**

举个直观的例子：

> 句子："猫坐在垫子上，因为它很温暖。"
>
> 问："它"指的是什么？

人类会立刻知道"它"指的是"垫子"（因为垫子温暖，猫不温暖）。Attention 机制让模型也能做到这一点——在处理"它"这个词时，模型会给"垫子"分配很高的注意力权重，给"猫"分配较低的权重。

### 2.1 Self-Attention（自注意力）

Self-Attention 是 Attention 的一种特殊形式，也是 Transformer 使用的版本。

**Self-Attention 让句子中的每个词都能"看到"其他所有词，并计算它们之间的关联强度。** 这个过程可以并行完成，不需要像 RNN 那样逐个处理。

具体实现上，每个词会被转换成三个向量：
- **Query（查询）**："我要找什么信息？"
- **Key（键）**："我有什么信息？"
- **Value（值）**："我的实际内容是什么？"

然后计算 Query 和 Key 的相似度，得到注意力权重，再用权重加权求和 Value，就得到了这个词的"上下文表示"。

### 2.2 Multi-Head Attention（多头注意力）

**Multi-Head Attention 是 Self-Attention 的升级版，让模型同时从多个角度关注不同的关系。**

比如"苹果"这个词：
- 一个注意力头可能关注"水果"这个语义
- 另一个注意力头可能关注"公司"这个语义
- 还有一个可能关注"颜色"（红色）

GPT-3 有 96 个注意力头，GPT-4 更多。每个头学习不同的语言模式，组合起来就形成了丰富的语义理解。

**一句话记住：** Attention 就是给每个词配了一个"聚光灯"，让它能照亮句子中最相关的其他词。

---

## 三、Embedding / 嵌入

计算机不懂文字，它只懂数字。Embedding 就是把文字转换成数字的桥梁。

**Embedding 是将离散的符号（如单词、字符）映射到连续向量空间的技术。** 每个词会被表示成一个高维向量（比如 768 维、1024 维、甚至 12288 维），向量中的每个数字代表这个词的某种语义特征。

### 3.1 为什么 Embedding 有效？

Embedding 有一个神奇的特性：**语义相近的词，在向量空间中的距离也相近。**

比如：
- "国王" - "男人" + "女人" ≈ "女王"
- "北京" 和 "中国首都" 的向量非常接近
- "开心" 和 "高兴" 的向量距离很近
- "开心" 和 "悲伤" 的向量距离很远

这不是人为设定的，而是模型在训练过程中自动学习到的。通过在海量文本上训练，模型发现"国王"和"女王"经常出现在相似的语境中，所以它们的向量表示也很相似。

### 3.2 Token Embedding

在大模型中，Embedding 的最小单位不是"字"或"词"，而是 **Token**。

**Token 是模型处理文本的最小单位**，可以是：
- 一个完整的英文单词（如 "the", "apple"）
- 一个中文字符（如 "苹"）
- 甚至是词的一部分（如 "unhappiness" 可能被拆成 "un", "happiness"）

GPT-4 的词汇表大约有 10 万个 token。中文通常 1-2 个字符对应 1 个 token，英文通常 1 个单词对应 1 个 token（常见词）或 0.75 个 token（平均）。

**一句话记住：** Embedding 是文字的"数字身份证"，语义相近的文字，身份证号也相近。

---

## 四、预训练（Pre-training）

预训练是大模型"学知识"的过程，也是整个训练中最耗资源、最耗时的阶段。

**预训练是在海量无标注文本上，让模型学习语言的统计规律和通用知识的过程。** 核心任务只有一个：预测下一个 token。

### 4.1 预测下一个字

预训练的过程简单粗暴：

1. 从互联网、书籍、论文、代码中收集数千亿 token 的文本
2. 随机遮住句子的一部分，让模型预测被遮住的部分是什么
3. 如果预测对了，奖励模型；预测错了，惩罚模型
4. 重复数万亿次

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

因为这只是第一步。预训练后的模型虽然能生成连贯的文本，但它不会"回答问题"，也不会"遵循指令"。它只是一个高级的"文本续写器"。

要让模型变成 ChatGPT 那样的助手，还需要后续的 **Fine-tuning（微调）** 和 **RLHF（人类反馈强化学习）**。

### 4.3 预训练产出了什么？

预训练结束后，你得到的不是"一个聪明的程序"，而是**一个巨大的权重文件**。

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

**一句话：训练产出的就是一个大文件，里面存着几百亿个数字。这些数字决定了模型看到"你好"时，会输出"你好"还是"今天天气不错"。**

**一句话记住：** 预训练就是给模型"读遍互联网"，让它学会语言的基本规律和常识。

---

## 五、Fine-tuning / 微调

预训练后的模型是"通才"，Fine-tuning 是把它变成"专才"的过程。

**Fine-tuning 是在预训练模型的基础上，用特定领域或特定任务的数据进行进一步训练，让模型适应特定场景的过程。**

### 5.1 什么时候需要 Fine-tuning？

- **领域适配**：让通用模型学会医学、法律、金融等专业术语和知识
- **风格调整**：让模型生成特定风格的文本（如客服话术、新闻报道、诗歌）
- **任务优化**：提升模型在特定任务上的表现（如代码生成、SQL 查询、情感分析）

### 5.2 Fine-tuning 的代价

Fine-tuning 需要：
- 准备高质量的标注数据（通常几千到几万条）
- 相当的算力（虽然比预训练少很多，但仍需要 GPU）
- 一定的技术门槛（超参数调优、过拟合防范）

对于个人开发者或小团队，**Prompt Engineering + RAG** 往往是更经济的选择。只有当业务场景非常特殊、对输出质量要求极高时，才值得投入 Fine-tuning。

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

下面这张图展示了从预训练到最终部署的完整训练链路：

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
      SFT + RLHF/DPO → 教礼仪、学对话 → 对话模型（如 Llama-3-8B-Instruct）
    </td>
  </tr>
  <tr><td colspan="2" style="height: 8px;"></td></tr>
  <tr>
    <td colspan="2" style="text-align: center; color: #94a3b8; font-size: 20px;">↓ 通用助手就绪</td>
  </tr>
  <tr><td colspan="2" style="height: 8px;"></td></tr>
  <tr>
    <td style="width: 50%; vertical-align: top; padding: 8px;">
      <div style="background: #fef3c7; border: 2px solid #f59e0b; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #92400e; margin-bottom: 8px; text-align: center;">🔧 Fine-tuning（全量微调）</div>
        <ul style="margin: 0; padding-left: 16px; color: #78350f; line-height: 1.8; font-size: 13px;">
          <li>修改全部参数</li>
          <li>需要：A100 GPU + 大量数据</li>
          <li>适合：大公司、核心场景</li>
        </ul>
      </div>
    </td>
    <td style="width: 50%; vertical-align: top; padding: 8px;">
      <div style="background: #e0e7ff; border: 2px solid #6366f1; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #3730a3; margin-bottom: 8px; text-align: center;">⚡ LoRA（低秩适配）</div>
        <ul style="margin: 0; padding-left: 16px; color: #312e81; line-height: 1.8; font-size: 13px;">
          <li>只训练新增小模块</li>
          <li>需要：RTX 4090 + 少量数据</li>
          <li>适合：个人开发者、快速实验</li>
        </ul>
      </div>
    </td>
  </tr>
  <tr><td colspan="2" style="height: 8px;"></td></tr>
  <tr>
    <td colspan="2" style="text-align: center; color: #94a3b8; font-size: 20px;">↓ 最终产物</td>
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
| **预训练** | 从零训练全部参数 | 数千亿 token | 数千张 GPU | 基础模型（Base） |
| **Post-training** | 全量微调 | 几十万~几百万条 | 几十~几百张 GPU | 对话模型（Instruct） |
| **Fine-tuning** | 全量微调 | 几千~几万条 | 1~8 张 A100 | 领域专用模型 |
| **LoRA** | 只训练新增模块 | 几百~几千条 | 1 张 RTX 4090 | LoRA 适配器文件 |

**关键理解：**
- **预训练**是"打地基"，决定了模型的知识储备和语言能力
- **Post-training**是"精装修"，决定了模型能否听懂人话、是否安全
- **Fine-tuning / LoRA**是"个性化定制"，让通用模型适应特定场景
- 越往后的阶段，**数据需求越少、算力需求越低、针对性越强**

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
- r = 8：适合简单任务，参数量最少
- r = 16：通用选择，平衡效果和效率
- r = 32+：复杂任务，效果接近全量微调

r 越小，训练的参数越少，但表达能力也受限。r 越大，越接近全量微调的效果。

**一句话：Low-Rank 就是"用少量关键信息代替全部信息"。LoRA 利用这个原理，用两个小子矩阵代替修改整个大矩阵，从而大幅降低微调成本。**

#### LoRA 直观对比图

<table style="width:100%; border-collapse: collapse; margin: 20px 0; font-size: 14px;">
  <tr>
    <td style="width: 50%; vertical-align: top; padding: 8px;">
      <div style="background: #fee2e2; border: 2px solid #ef4444; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #991b1b; margin-bottom: 8px; text-align: center;">❌ 全量 Fine-tuning</div>
        <ul style="margin: 0; padding-left: 16px; color: #7f1d1d; line-height: 1.8; font-size: 13px;">
          <li>修改全部 175B 参数</li>
          <li>需要 8×A100 GPU</li>
          <li>训练时间：数天</li>
          <li>存储：数百 GB</li>
          <li>💸 成本极高</li>
        </ul>
      </div>
    </td>
    <td style="width: 50%; vertical-align: top; padding: 8px;">
      <div style="background: #dcfce7; border: 2px solid #22c55e; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #166534; margin-bottom: 8px; text-align: center;">✅ LoRA</div>
        <ul style="margin: 0; padding-left: 16px; color: #14532d; line-height: 1.8; font-size: 13px;">
          <li>只训练 0.1% 新增参数</li>
          <li>1×RTX 4090 即可</li>
          <li>训练时间：几小时</li>
          <li>存储：几十 MB</li>
          <li>💰 成本极低</li>
        </ul>
      </div>
    </td>
  </tr>
</table>

**核心原理一句话：**  frozen W（冻结大矩阵） +  train A×B（训练小子矩阵） =  低成本微调大模型

### 6.2 LoRA 的优势

- **显存友好**：可以在消费级 GPU（如 RTX 4090）上微调大模型
- **训练速度快**：参数少，收敛快
- **模型体积小**：LoRA 权重通常只有几 MB 到几百 MB
- **可切换**：一个基础模型 + 多个 LoRA 权重，可以灵活切换不同任务

### 6.3 QLoRA

**QLoRA 是 LoRA 的升级版，进一步降低了显存需求。** 它把模型权重从 16 位浮点数压缩到 4 位（量化），然后再加 LoRA 适配层。这样可以在 24GB 显存的显卡上微调 70B 参数的模型。

**一句话记住：** LoRA 是"小改动大效果"的微调方法，用少量新增参数让大模型适应新任务，省钱又高效。

---

## 七、MoE / 混合专家模型（Mixture of Experts）

MoE 是 2024 年以来大模型领域最热门的架构创新之一。

**MoE 是一种模型架构，把一个大模型拆分成多个"专家"子网络，每次推理时只激活其中一部分专家，从而降低计算成本。**

### 7.1 为什么需要 MoE？

大模型的一个核心矛盾是：**模型越大效果越好，但推理成本也越高。** GPT-4 据说有 1.8 万亿参数，每次生成答案都需要进行数万亿次计算，成本极高。

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

GPT-4、Mixtral 8x7B、Qwen2-57B 都采用了 MoE 架构。比如 Mixtral 8x7B 有 8 个专家，总参数量 47B，但每次只激活 2 个专家（约 13B 参数），推理速度和 13B 模型相当，效果却接近 47B 模型。

**一句话记住：** MoE 是"按需激活"的架构，让大模型在保持能力的同时大幅降低推理成本。

### 7.3 MoE 直观对比图

<table style="width:100%; border-collapse: collapse; margin: 20px 0; font-size: 14px;">
  <tr>
    <td style="width: 50%; vertical-align: top; padding: 8px;">
      <div style="background: #fee2e2; border: 2px solid #ef4444; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #991b1b; margin-bottom: 8px; text-align: center;">❌ 传统 Dense 模型</div>
        <ul style="margin: 0; padding-left: 16px; color: #7f1d1d; line-height: 1.8; font-size: 13px;">
          <li>所有参数全部激活</li>
          <li>每次推理用 1.8T 参数</li>
          <li>成本高、速度慢</li>
          <li>像全科医生看所有病</li>
          <li>💸 推理成本极高</li>
        </ul>
      </div>
    </td>
    <td style="width: 50%; vertical-align: top; padding: 8px;">
      <div style="background: #dcfce7; border: 2px solid #22c55e; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #166534; margin-bottom: 8px; text-align: center;">✅ MoE 模型</div>
        <ul style="margin: 0; padding-left: 16px; color: #14532d; line-height: 1.8; font-size: 13px;">
          <li>只激活部分专家</li>
          <li>每次推理用 ~13B 参数</li>
          <li>成本低、速度快</li>
          <li>像专科医生按需会诊</li>
          <li>💰 推理成本大幅降低</li>
        </ul>
      </div>
    </td>
  </tr>
</table>

**核心原理一句话：**  门控网络（分诊台）→ 选择 2 个最相关专家 → 只计算这 2 个专家 → 输出结果

---

## 八、Temperature / Top-p / Top-k

这三个参数是控制模型输出"随机性"的旋钮，也是 Prompt Engineering 中经常调整的超参数。

### 8.1 Temperature（温度）

**Temperature 控制模型输出的随机程度。** 它是一个 0 到 2 之间的数值（通常用 0.0 - 1.0）。

- **Temperature = 0**：模型总是选择概率最高的词，输出最确定、最保守
- **Temperature = 0.7**：模型会在高概率词中随机选择，输出既有创意又保持合理（默认推荐值）
- **Temperature = 1.0+**：模型更倾向于选择低概率词，输出更有创意但也更可能胡说八道

类比：Temperature 就像厨师的"创意程度"。温度低 = 严格按照菜谱做；温度高 = 自由发挥，可能惊喜也可能翻车。

### 8.2 Top-p（Nucleus Sampling）

**Top-p 是另一种控制随机性的方法，它从累积概率达到 p 的最小词集合中采样。**

比如 Top-p = 0.9：
1. 模型预测下一个词的概率分布
2. 按概率从高到低排序
3. 选取累积概率达到 90% 的最小词集合
4. 只在这个集合中随机选择

Top-p 比 Temperature 更智能，因为它会根据当前语境动态调整候选词的数量。

### 8.3 Top-k

**Top-k 是最简单的采样方法，只从概率最高的 k 个词中随机选择。**

比如 Top-k = 50：只考虑概率最高的 50 个词，其他的全部忽略。

**一句话记住：** Temperature 控制"创意程度"，Top-p 控制"考虑范围"，两者配合可以让模型既有创意又不胡说八道。

### 8.4 Temperature 直观对比图

<table style="width:100%; border-collapse: collapse; margin: 20px 0; font-size: 14px;">
  <tr>
    <td style="width: 33%; vertical-align: top; padding: 8px;">
      <div style="background: #dbeafe; border: 2px solid #3b82f6; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #1e40af; margin-bottom: 8px; text-align: center;">🧊 Temperature = 0</div>
        <ul style="margin: 0; padding-left: 16px; color: #1e3a8a; line-height: 1.8; font-size: 13px;">
          <li>最确定、最保守</li>
          <li>每次输出都一样</li>
          <li>适合：代码生成、数学计算</li>
          <li>🤖 像严格执行的机器人</li>
        </ul>
      </div>
    </td>
    <td style="width: 33%; vertical-align: top; padding: 8px;">
      <div style="background: #dcfce7; border: 2px solid #22c55e; border-radius: 8px; padding: 12px; height: 100%;">
        <div style="font-weight: bold; color: #166534; margin-bottom: 8px; text-align: center;">🌡️ Temperature = 0.7（推荐）</div>
        <ul style="margin: 0; padding-left: 16px; color: #14532d; line-height: 1.8; font-size: 13px;">
          <li>既有创意又合理</li>
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
          <li>很有创意但可能胡说</li>
          <li>输出随机性很大</li>
          <li>适合：诗歌、创意写作</li>
          <li>🎨 像疯狂的艺术家</li>
        </ul>
      </div>
    </td>
  </tr>
</table>

**实际效果对比：**

| 温度 | 输入 | 输出 |
|------|------|------|
| **0** | "描述一只猫" | "猫是一种小型哺乳动物，属于猫科动物。" |
| **0.7** | "描述一只猫" | "一只橘色的猫咪正懒洋洋地躺在窗台上，尾巴轻轻摇晃。" |
| **1.2** | "描述一只猫" | "月光下，一只银灰色的猫影掠过屋顶，眼中闪烁着星辰的光芒。" |

**一句话：** Temperature 越低越"老实"，越高越"放飞"。日常用 0.7 最合适。

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
- 想了解工程落地？→ 关注本系列第三篇（即将发布）

---

*本系列持续更新中，第三篇将深入讲解工程落地与生态工具。*
