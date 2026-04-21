---
title: "Apple Watch产品设计经验 FROM 去哪网"
pubDate: "2017-02-07"
slug: "guan-yu-apple-watchchan-pin-qu-na-wang-da-shen-fen-xiang"
tags: ["iOS", "Apple watchOS", "产品", "设计", "技术"]
category: "iOS"
excerpt: "在参与2016WWDC过程中，听取了【去哪网】某位从业人员的关于Apple Watch产品设计技术相关的分享，将要点整理如下，作为学习提纲之用，供参考 文中Apple WatchOS应该是基于WatchOS 2.0版本，但某些设计和产品经验..."
---

<blockquote>
<p>在参与2016WWDC过程中，听取了【去哪网】某位从业人员的关于Apple Watch产品设计技术相关的分享，将要点整理如下，作为学习提纲之用，供参考</p>
</blockquote>
<p>文中Apple WatchOS应该是基于WatchOS 2.0版本，但某些设计和产品经验同样适用于Apple WatchOS 3.0.</p>
<h5 id="">初识 &amp; 迷惘</h5>
<ul>
<li>Watch OS Glance？问题：状态展示？如何更新？有无用户交互？
<ul>
<li>只适合进行时间相关的内容展现</li>
<li>运营相关的内容意义不大，手表是效率工具</li>
<li>使用类似健身记录的圆环展示方式并不适用于第三方App,最大的Lower也只有XXX像素</li>
</ul>
</li>
<li>色彩略单调，watch lib;</li>
<li>人们不会一直使用某个App;</li>
<li>操作要简单，10-30s完成;</li>
<li>推送展现，只有watch在手上才会推送到watch上;</li>
<li>app group是什么鬼？现在常用于进行非实时简单数据通讯！</li>
</ul>
<h5 id="">产品层面</h5>
<ul>
<li>明亮色彩提升产品感受;</li>
<li>尽量减少滚动，一屏展示所表现的内容;</li>
</ul>
<h5 id="">技术层面</h5>
<ul>
<li>Phone &amp; Watch￼代码复用￼￼￼</li>
<li>URL Schema做跳转协议，使用Extension和App的交互接口相统一；</li>
<li>与iPhone App同步，使用MMWormhole触发，如退出登录等；</li>
</ul>
<h5 id="applewatchos20changes">Apple Watch OS 2.0 Changes</h5>
<ul>
<li>App无法与Watch Extension共享Framework；</li>
<li>不在要求运行Watch App时必须与手机处于联通状态；</li>
<li>MMWormhole仍然可用，但也可以使用WatchConnectivity替换（WatchConnectivity更推荐使用）；</li>
</ul>
<h5 id="">性能 &amp; 优化</h5>
<p><strong>Network优化点</strong></p>
<ul>
<li>使用压缩协议优化减少Request &amp; Response</li>
<li>隐藏不必要的JSON，需要什么给什么，不多不少</li>
<li>发送对应的Watch大小的图片，38" or 42"</li>
<li>对于List，针对Watch设定每一页的大小（经验值：5）</li>
<li>对于UI团队提供的图片资源，图片尺寸要恰好适配Watch
<ul>
<li>App中使用setImageNamed</li>
<li>Watch中使用setImageData <code>性能考虑</code></li>
</ul>
</li>
</ul>
<p><strong>UI性能</strong></p>
<ul>
<li>减少UI复杂度，大简至美</li>
<li>WKInterfaceTable第一次加载的行数不要太多</li>
<li>在RowController的willActivate方法中使用dispatch来请求图片</li>
</ul>
<p><strong>WatchOS 2.0 New Features</strong></p>
<ul>
<li>Digital Crown</li>
<li>ClockKit</li>
<li>Animation (还有很多局限)</li>
</ul>
<p><strong>WatchOS 3.0 New Features</strong></p>
<ul>
<li>The Dock</li>
<li>Stickiness</li>
<li>Gesture support</li>
<li>Direct access to the Digital Crown</li>
<li>Improved notification support</li>
<li>Extra large complications</li>
<li>Workout app improvements</li>
<li>Background App Refresh</li>
<li>Faster interactions</li>
</ul>
<h5 id="watchos">WatchOS开发中遇到的坑</h5>
<ul>
<li>证书签名： WatchApp没有Build Setting
<ul>
<li>解决办法： 手动修改project文件</li>
</ul>
</li>
<li>WKInterfaceMap在1.0版本中内存泄露
<ul>
<li>最终在第一版本中暂时去掉了Map</li>
</ul>
</li>
<li>XCode 6.2 中的CI（xcodebuild）不支持导出带有Watch的archive
<ul>
<li>XCode7解决了这个问题</li>
</ul>
</li>
</ul>
<p><code>建议使用XCode自动去管理证书</code></p>
<h5 id="watchos">Watch OS开发的优势</h5>
<ul>
<li>了解新技术，Watch会逼着你用StoryBoard</li>
<li>Share Framework使用；</li>
<li>Watch的一些新技术和架构，可以看出苹果对新技术的一些态度及思考
<ul>
<li>如WKInterfaceTable vs UITableView</li>
</ul>
</li>
</ul>
<h5 id="">参考链接</h5>
<ul>
<li><a href="https://developer.apple.com/watchos/human-interface-guidelines/overview/">watchOS Human Interface Guidelines</a></li>
</ul>
<p>ENJOY~</p>