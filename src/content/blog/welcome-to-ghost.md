---
title: "Homebrew常用Cheatsheet"
pubDate: "2016-12-08"
slug: "welcome-to-ghost"
tags: ["技术", "工具"]
---

<h3 id="homebrew">安装Homebrew</h3>
<pre><code>ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
</code></pre>
<h3 id="">搜索</h3>
<pre><code>brew search &lt;target-name&gt;
</code></pre>
<pre><code>e.g. brew search mysql
</code></pre>
<h3 id="">查询软件列表</h3>
<pre><code>brew list		// 可列出可安装的软件列表, 可结合管道使用，查找需要的软件
</code></pre>
<h3 id="">安装软件</h3>
<pre><code>brew install &lt;target-name&gt;
</code></pre>
<h3 id="">删除软件</h3>
<pre><code>brew uninstall &lt;target-name&gt;
</code></pre>
<h3 id="">查询</h3>
<pre><code>brew info &lt;target-name&gt;
</code></pre>
<pre><code>e.g. brew search mysql
</code></pre>
<h3 id="homebrew">更新Homebrew信息</h3>
<pre><code>brew update		// 更新Homebrew信息，包括Homebrew自身以及包信息等；
</code></pre>
<h3 id="homebrew">Homebrew体检</h3>
<pre><code>brew doctor		// 会详细列出过期或者废弃的信息
</code></pre>
<h3 id="">升级软件</h3>
<pre><code>brew upgrade	// 通过Homebrew升级所有可以升级的软件们
</code></pre>
<h3 id="">清理</h3>
<pre><code>brew cleanup	// 清理不需要的版本、安装包、缓存等内容
</code></pre>
<h3 id="">查看升级信息</h3>
<pre><code>brew outdated	// 查看所有可升级的软件，aka. 知道哪些软件有新版本啦
</code></pre>
<h3 id="">软件定向升级</h3>
<pre><code>brew upgrade &lt;target-name&gt;		// 对某一软件进行针对性升级
</code></pre>
<p>ENJOY.</p>
<hr>
<p>Author: Mark C.J.	2016.6.15</p>
<p>Flight <strong>HU7711</strong>. From Beijing to Shenzhen.</p>