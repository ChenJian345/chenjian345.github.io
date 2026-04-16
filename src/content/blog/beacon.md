---
title: "Beacon初识"
pubDate: "2018-01-30"
slug: "beacon"
tags: ["设计", "Beacon", "Ble"]
---

<p>文 · Mark</p>
<h2 id="beacon">什么是Beacon</h2>
<p>Beacon  ['biːk(ə)n] 这个单词的中文意思是<em>信号浮标、灯塔</em>，此文所说的Beacon其特点如下：</p>
<ul>
<li>采用BLE技术发射信号的小设备</li>
<li>运算能力几乎为零，但功耗很低，续航持久</li>
<li>有效范围几十厘米到几米</li>
<li>信号为单向发射，只能发射小数据包，例如128bit UUID</li>
<li>一般将智能手机作为接收方</li>
</ul>
<h2 id="">主流标准</h2>
<p>目前，在市场上Beacon类解决方案有哪些？</p>
<h4 id="ibeacon"><a href="https://developer.apple.com/ibeacon/">iBeacon</a></h4>
<p>iBeacon由Apple在WWDC13推出，其设计初衷也可以联想到，目前主要用来做室内定位标志物（至少需要两个iBeacon信标）</p>
<p>原理是利用低功耗BLE蓝牙技术，不断广播自己的特有ID，广播范围是有一定的区域限制，进入该范围的手机设备可以感知此信标的存在。通过读取广播中的ID，经过加工，满足业务需求。</p>
<p>该标准闭源，而且只兼容苹果公司的“i系列”产品；</p>
<h4 id="eddystone"><a href="https://developers.google.com/beacons/">Eddystone</a></h4>
<p>2015年，Google推出的开源低功耗BLE平台项目，名字来源于英国Eddystone灯塔，在iOS、Android平台上均可使用。</p>
<p>该项目的目标在于试图创建一个鲁棒、可扩展的Beacon标准，平台应用范围比iBeacon要广；</p>
<p>苹果的iBeacon和谷歌的<a href="https://google.github.io/physical-web/">The Physical Web</a>都只支持一种框架。而Eddystone支持通用唯一识别码（Universally Unique Identifier，UUID）、<strong>URL链接</strong>、临时标识（Ephemeral Identifiers，EID）以及遥测数据等四种框架类型。</p>
<p>当然，除了上述两种Beacon标准之外，还有一些开源标准，但目前还处于发展阶段，差异明显；</p>
<h2 id="">解决方案</h2>
<p>目前针对上述需求，可以满足的解决方案提供商有很多，但主流方向有以下几种：</p>
<h4 id="sensoro"><a href="https://www.sensoro.com/zh/case.html">SENSORO</a>等</h4>
<p>国内物联网解决方案提供商，初创公司，但已经为微软、Facebook提供过解决方案；</p>
<p>该类型公司国内外有很多，确定方案后，可以再做商业调研；</p>
<h4 id="vendor">Vendor合作</h4>
<p>自有或者vendor研发有自由定制优势，而且可以自定义私有协议，安全性方面有一定优势。但同时存在设计和生产成本高的问题，同时，沟通成本有可能升高。</p>
<h4 id="">自主研发</h4>
<p>优势是可定制性强，对于满足需求十分灵活，但缺点是成本较高，对软硬件生产均有要求。</p>
<h2 id="">无线测距</h2>
<p>通过BLE硬件，可以实现无线测距功能，该功能有一定的误差，所以，适用于对误差宽容度比较高的业务场景。</p>
<p>基本公式如下：</p>
<pre><code>Distance =10^((abs(RSSI) - A) / (10*n)
</code></pre>
<p>其中：</p>
<ul>
<li>Distance是计算距离</li>
<li>RSSI是信号强度，BLE设备均有此信息</li>
<li>A为发射点与接收端相隔1m时的信号强度</li>
<li>n是环境衰减银子，通常取经验值，该经验值需要调试确定</li>
</ul>
<h2 id="">参考文献</h2>
<ul>
<li><a href="https://developer.apple.com/ibeacon/Getting-Started-with-iBeacon.pdf">Apple - Getting Started with iBeacon</a></li>
<li><a href="https://developers.google.com/beacons/eddystone#beacon_manufacturers">Google - Eddystone</a></li>
</ul>