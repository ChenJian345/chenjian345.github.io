---
title: "Apple Siri接入开发（一）"
pubDate: "2017-02-07"
slug: "apple-sirijie-ru-kai-fa-yi"
tags: ["iOS", "技术", "技术调研", "Siri"]
category: "iOS"
excerpt: "随着iOS10.0发布脚步的临近，作为开发者，相信很多人也和我一样，可以提前体验一些新系统的新功能，也更关注新版iOS系统带来的技术开发方面的新特性。 对新事物，尤其是软件开发新技术的好奇心驱使我最近尝试了一些iOS10.0推出的新特性的开..."
---

<blockquote>
<p>随着iOS10.0发布脚步的临近，作为开发者，相信很多人也和我一样，可以提前体验一些新系统的新功能，也更关注新版iOS系统带来的技术开发方面的新特性。</p>
</blockquote>
<p>对新事物，尤其是软件开发新技术的好奇心驱使我最近尝试了一些iOS10.0推出的新特性的开发，其中就包括本次iOS系统更新开发的SiriKit接入。下面，我就详细讲述一下SiriKit接入的相关开发过程及注意事项，个人见解，如有错误，欢迎大家交流指正。</p>
<h3 id="sirikit">关于SiriKit</h3>
<p>SiriKit是Apple历经4年时间，不断打磨优化，第一次开发给开发者的一份关于Siri功能的礼物。利用SiriKit，第三方开发者可以像一些系统应用一样，通过语音完成第三方应用希望完成的一些功能，比如用户可以直接通过语音直接告诉Siri打车、锻炼、寻找美食、寻找相册中的照片、甚至付给朋友AA的账单费用，以及控制家里智能家居等。</p>
<h3 id="">概念概览</h3>
<ul>
<li>Domain - 被苹果划分的不同业务领域，每个领域中可以执行不同的任务</li>
<li>Intent - 领域中的任务或意图指令</li>
</ul>
<h3 id="">实现机制</h3>
<p>和Android的语音接入Service类似，SiriKit中，将不同的类型的需求统一汇总为若干个Domain，然后在每个Domain中再次细分为不同的Intent。系统通过语音识别获取到的Domain信息以及Intent信息，下发到已注册的Domain中进行处理，然后用户解析处理不同的Intent，来实现自定义的操作。</p>
<p>SiriKit的接入方式和Watch OS的接入有相似之处，都是以Extension形式存在，该Extension会声明本应用所能处理的Domain内容及Intent种类，告知Siri该应用所能处理的功能范畴.这样，即便你的应用当前并没有打开或在后台运行，通过Siri也可以唤醒你的应用，处理相关逻辑。</p>
<h4 id="domains">Domains</h4>
<ul>
<li>VoIP Calling - 语音通信相关，如微信、Facebook Messager、Line等;</li>
<li>Payments - 适用于支付类应用，如PayPal、支付宝等；</li>
<li>Photo - 与图库相关应用，如Instagram等；</li>
<li>Workouts - 运动健康类应用，如Strava、NikeRun、野兽骑行等；</li>
<li>Ride booking - 适用于出行类应用，如Uber、滴滴打车等；</li>
<li>CarPlay（automotive vendors only）- 车载及自动驾驶相关，尚不明晰</li>
<li>Restarurant reservations(Requires addtional support from Apple) - 酒店服务类，具体需求上不明晰</li>
</ul>
<h4 id="intents">Intents</h4>
<ul>
<li>
<p>VoIP Calling</p>
<ul>
<li>Start an audio call -开始语音通话</li>
<li>Start a video call - 开始视频通话</li>
<li>Search the user’s call history -搜寻通话历史</li>
</ul>
</li>
<li>
<p>Messaging</p>
<ul>
<li>Send a message</li>
<li>Search for messages</li>
<li>Set attributes on a message</li>
</ul>
</li>
<li>
<p>Photos</p>
<ul>
<li>Search for photos</li>
<li>Play a photo slideshow</li>
</ul>
</li>
<li>
<p>Payments</p>
<ul>
<li>Send a payment to another user</li>
<li>Request a payment from another user</li>
</ul>
</li>
<li>
<p>Workouts</p>
<ul>
<li>Start a workout</li>
<li>Pause a workout</li>
<li>Resume a workout</li>
<li>End a workout</li>
<li>Cancel a workout</li>
</ul>
</li>
<li>
<p>Ride Booking</p>
<ul>
<li>Get a list of available rides (Maps only)</li>
<li>Book a ride</li>
<li>Get the status of a booked ride</li>
</ul>
</li>
<li>
<p>CarPlay</p>
<ul>
<li>Change the audio source</li>
<li>Change the climate control settings</li>
<li>Change the defroster settings</li>
<li>Saving vehicle settings to a profile</li>
<li>Restoring vehicle settings from a profile</li>
<li>Change the seat temperature</li>
<li>Change the radio station</li>
</ul>
</li>
<li>
<p>Restaurant Reservations</p>
<ul>
<li>Get the user’s current restaurant reservations</li>
<li>Get information about the user to associate with a booking.</li>
<li>Get default values to use when requesting reservation times.</li>
<li>Get the reservation times that are currently available.</li>
<li>Book a reservation for the user.</li>
</ul>
</li>
</ul>
<p>注意，经过开发实践，每种Domain及Intents都有固定或相似的语法形式，为增加识别度，可以参考官网说明，按照说明中自然语言语法形式唤起相应的Siri功能，例如：”用XXX开始跑步“ 要比仅仅说 “XXX开始跑步”能更好的识别出应用XXX。</p>
<p>由于Siri所使用的识别技术及语言模型是在云端训练并完成数据解析，可能还有些不完善。在我们刚开始开发时，就遇到了这样的问题，中文普通话的有些Intent会有支持不完整的情况，导致语音识别不出来，无法完成语义解析，相关回调方法不被调用等问题，如有大家也遇到了类似问题，建议使用英文进行测试。</p>
<p>对于此问题，也已经向Apple Siri开发团队反应，相关训练任务已经在进行中，很惊喜的是，在之后的开发中，有些之前不支持的Intent语义识别也已经可以使用了。</p>
<h3 id="">开发流程</h3>
<p>上面简述了SiriKit的一些背景知识及实现机制，下面简单介绍一下我在接入SiriKit时使用的开发流程.</p>
<h3 id="">开发环境</h3>
<ul>
<li>MacbookPro. OSX EI Capitan 10.11.6</li>
<li>xCode 8.0 beta6(8S201h)</li>
<li>iPhone6 iOS10.0 beta6</li>
<li>iTerms2, git, etc.</li>
</ul>
<h3 id="">支持类型</h3>
<p>对于向现有iOS应用中加入对Siri的支持有两种形式，一种是Intents Extension，另一种是Intents UI Extension，前者没有UI界面，类似一个后台逻辑处理服务，这项Extension是必选的。</p>
<p>而Siri UI Extensions是可选内容，用于展示一些确认信息等操作。经负责该功能的Apple SiriKit工程师确认，UI Siri Extensions的声明周期比较短，部分应用可根据实际需要采用，但Workout类应用目前试用范围较宅，本例中未采用。</p>
<h3 id="">接入步骤</h3>
<p>本次接入SiriKit开发中，采用Workout类应用，此处Workout并不是Apple WatchOS 3.0中新增的Workout App, 而是指一类运动锻炼相关应用，例如，Strava, Nike Run一类。由于Apple SiriKit中限制了7类不同的Domain，如果需要接入其他类别的应用，如天气，支付等，可以参考官方接入指南进行相关开发。</p>
<h4 id="step1siricapability">Step1. 打开应用的Siri Capability</h4>
<p>在Xcode8中，选中应用Target，选择Capability标签，打开Siri Capability打开，如图所示：<br>
<img src="http://okzqhpqwj.bkt.clouddn.com/201702072461357c303f4ab644135ea06285a.png" alt="201702072461357c303f4ab644135ea06285a.png"></p>
<p>打开该属性后，工程文件的Entitlements文件会增加如下内容：<br>
<img src="http://okzqhpqwj.bkt.clouddn.com/201702071729357c303f4ab644135ea06285b.png" alt="201702071729357c303f4ab644135ea06285b.png"></p>
<h4 id="step2siriintentsextension">Step2:  创建支持Siri的Intents Extension</h4>
<p>首先选中App工程，为该App添加对Siri的Intents Extension支持的Target，如图：<br>
<img src="http://okzqhpqwj.bkt.clouddn.com/201702075782857c303f4ab644135ea062857.png" alt="201702075782857c303f4ab644135ea062857.png"></p>
<p>选择Intents Extension<br>
<img src="http://okzqhpqwj.bkt.clouddn.com/201702076878357c303f4ab644135ea062858.png" alt="201702076878357c303f4ab644135ea062858.png"></p>
<p>命名并选择是否UI Extension，可根据自我业务需求确定，本例中，对UI Extension不进行支持。<br>
<img src="http://okzqhpqwj.bkt.clouddn.com/20170207372957c303f4ab644135ea062859.png" alt="20170207372957c303f4ab644135ea062859.png"></p>
<p>创建完成后，Siri Intents Extension的target会显示在Target列表中。</p>
<h3 id="step3intent">Step3: 定义所支持的Intent</h3>
<p>该步骤相当于告诉Siri及iOS系统，本应用中所支持的Domain和Intents都有哪些，这样iOS系统及Siri就知道你的应用可以处理哪些请求，不能处理哪些请求。<br>
打开Siri Intents Extension工程中的Info.plist文件，选中NSExtension，修改所支持的Intent类型，具体类型字符串可以查询开发文档，添加后的内容如下：<br>
<img src="http://okzqhpqwj.bkt.clouddn.com/201702076763357c30921ab644133ed0638de.png" alt="201702076763357c30921ab644133ed0638de.png"></p>
<p>IntentsRestrictedWhileLocked是可选项，用来控制锁屏状态下，对不同命令的响应行为。</p>
<h4 id="step4siri">Step4：添加对主应用Siri权限支持</h4>
<p>在主应用Info.plist文件中添加NSSiriUsageDescription Key，该key用来标记应用与Extension所沟通的数据类型，用于告知用户，你的应用为何要支持Siri的描述信息，比如Workout类应用，我可以这么写：“健身锻炼的信息会发送到Siri，更快捷的记录健身数据”</p>
<p>仅仅添加NSSiriUsageDescription这个Key到Info.plist文件中是不够的，当应用第一次启动时，我们需要用户打开应用的Siri支持权限，默认情况下，这个权限是关闭的，所以，需要我们通过调用INPreferences的类方法equestSiriAuthorization: 来通知用户打开Siri权限支持。</p>
<h4 id="step5">Step5. 添加逻辑</h4>
<p>OK，到此为止，我们已经把所有接入Siri Intents Extension的前期准备工作都已经完成，现在我们要进入正题，实现相应的逻辑处理代码编写工作。<br>
修改IntentHandling.swift文件，根据需要，修改所需要实现的协议内容：</p>

```objc

class  IntentHandler:INExtension,INStartWorkoutIntentHandling,INPauseWorkoutIntentHandling,INResumeWorkoutIntentHandling,INEndWorkoutIntentHandling{
	...
}

```

<p>OK，到此为止，我们已经把所有接入Siri Intents Extension的前期准备工作都已经完成，现在我们要进入正题，实现相应的逻辑处理代码编写工作。<br>
修改IntentHandling.swift文件，根据需要，修改所需要实现的协议内容：</p>

```objc

class IntentHandler:INExtension,INStartWorkoutIntentHandling
    ,INPauseWorkoutIntentHandling,INResumeWorkoutIntentHandling
    ,INEndWorkoutIntentHandling{
	...
}

```

<p>修改所需要实现的﻿不同场景下的逻辑回调部分，调用所在iOS App的相关业务逻辑，满足产品需求，例如</p>
<p>开始锻炼</p>

```

/*!
@briefhandlingmethod
@abstractExecutethetaskrepresentedbytheINStartWorkoutIntentthat
    'spassedin
@discussionThismethodiscalledtoactuallyexecutetheintent
    .Theappmustreturnaresponseforthisintent.
@paramstartWorkoutIntentTheinputintent
@paramcompletionTheresponsehandlingblocktakesaINStartWorkoutIn
    tentResponsecontainingthedetailsoftheresultofhavingexecutedthe
    intent
@seeINStartWorkoutIntentResponse
*/
public func handle(startWorkoutintent:INStartWorkoutIntent,completion
    :@escaping(INStartWorkoutIntentResponse)->Swift.Void){
	print("HereisStartworkoutcalledbySiri");
}

```

<p>暂停锻炼</p>

```

//MARK:-INPauseWorkoutIntentHandling
/*!
@briefhandlingmethod
@abstractExecutethetaskrepresentedbytheINPauseWorkoutIntentthat
    'spassedin
@discussionThismethodiscalledtoactuallyexecutetheintent
    .Theappmustreturnaresponseforthisintent.
@parampauseWorkoutIntentTheinputintent
@paramcompletionTheresponsehandlingblocktakesaINPauseWorkoutIn
    tentResponsecontainingthedetailsoftheresultofhavingexecutedthe
    intent
@seeINPauseWorkoutIntentResponse
*/
public func handle(pauseWorkoutintent:INPauseWorkoutIntent,completion
    :@escaping(INPauseWorkoutIntentResponse)->Swift.Void){
	print("HereisPauseworkoutcalledbySiri");
}

```

<p>恢复锻炼</p>

```

//MARK:-INResumeWorkoutIntentHandling
/*!
@briefhandlingmethod
@abstractExecutethetaskrepresentedbytheINResumeWorkoutIntenttha
    t'spassedin
@discussionThismethodiscalledtoactuallyexecutetheintent
    .Theappmustreturnaresponseforthisintent.
@paramresumeWorkoutIntentTheinputintent
@paramcompletionTheresponsehandlingblocktakesaINResumeWorkoutI
    ntentResponsecontainingthedetailsoftheresultofhavingexecutedth
    eintent
@seeINResumeWorkoutIntentResponse
*/
public func handle(resumeWorkoutintent:INResumeWorkoutIntent
    ,completion:@escaping(INResumeWorkoutIntentResponse)->Swift.Void){
	print("HereisResumeworkoutcalledbySiri");
}

```

<p>结束锻炼</p>

```

//MARK:-INEndWorkoutIntentHandling
/*!
@briefhandlingmethod
@abstractExecutethetaskrepresentedbytheINEndWorkoutIntentthat's
    passedin
@discussionThismethodiscalledtoactuallyexecutetheintent
    .Theappmustreturnaresponseforthisintent.
@paramendWorkoutIntentTheinputintent
@paramcompletionTheresponsehandlingblocktakesaINEndWorkoutInte
    ntResponsecontainingthedetailsoftheresultofhavingexecutedthei
    ntent
@seeINEndWorkoutIntentResponse
*/
public func handle(endWorkoutintent:INEndWorkoutIntent,completion
    :@escaping(INEndWorkoutIntentResponse)->Swift.Void){
	print("HereisEndworkoutcalledbySiri");
}

```

<h3 id="">总结</h3>
<p>以上就完成了所有接入SiriKit的工作，剩余的应用就是测试成果，此处有一些技巧，</p>
<ul>
<li>技巧一：由于SiriKit首次发布，有些语言支持尚不完善，建议使用英文进行测试，这样可以避开一些Intent在不同语言中支持不完整的问题。</li>
<li>技巧二：iPhone6s及以后设备已经支持了通过“Hey, Siri”语音唤醒的特性，所以用iPhone6s可以方便的不用按住Home就可进行测试，很方便，对于iPhone6 &amp; iPhone6P，插入数据线，连接电脑，也可以通过“Hey, Siri”唤醒，直接进行相应业务需求测试。</li>
</ul>
<p>以上就是接入SiriKit的背景知识点以及基本流程，在接入过程中，与Apple SiriKit开发团队接触过程中，发现了若干问题，也收获了许多知识，在后续文章中，我会单独抽出一篇来与大家分享。文章中间如有错误之处，欢迎大家批评指正，共同成长。</p>
<p>Enjoy your Siri trip.</p>
<p>参考文献</p>
<ul>
<li><a href="https://developer.apple.com/library/prerelease/content/documentation/Intents/Conceptual/SiriIntegrationGuide/">Apple SiriKit Programming Guide</a></li>
</ul>