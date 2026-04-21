---
title: "iOS-LZMA类压缩算法使用"
pubDate: "2016-12-18"
slug: "ios-lzmalei-ya-suo-suan-fa-shi-yong"
tags: ["iOS", "技术", "技术调研"]
category: "iOS"
excerpt: "LZMA（Lempel-Ziv-Markov chain-Algorithm的缩写）是2001年以来得到发展的一个数据压缩算法，它用于7-Zip归档工具中的7z格式和 Unix-like 下的 xz 格式。它使用类似于LZ77的字典编码机制..."
---

<blockquote>
<p><strong>LZMA</strong>（<a href="https://zh.wikipedia.org/w/index.php?title=Abraham_Lempel&amp;action=edit&amp;redlink=1">Lempel</a>-<a href="https://zh.wikipedia.org/w/index.php?title=Jacob_Ziv&amp;action=edit&amp;redlink=1">Ziv</a>-<a href="https://zh.wikipedia.org/wiki/%E9%A9%AC%E5%B0%94%E5%8F%AF%E5%A4%AB%E9%93%BE">Markov chain</a>-<a href="https://zh.wikipedia.org/wiki/%E7%AE%97%E6%B3%95">Algorithm</a>的缩写）是2001年以来得到发展的一个<a href="https://zh.wikipedia.org/wiki/%E6%95%B0%E6%8D%AE%E5%8E%8B%E7%BC%A9">数据压缩</a>算法，它用于<a href="https://zh.wikipedia.org/wiki/7-Zip">7-Zip</a>归档工具中的<a href="https://zh.wikipedia.org/wiki/7z">7z</a>格式和 <a href="https://zh.wikipedia.org/wiki/Unix-like">Unix-like</a> 下的 <a href="https://zh.wikipedia.org/wiki/Xz">xz</a> 格式。它使用类似于<a href="https://zh.wikipedia.org/wiki/LZ77%E4%B8%8ELZ78">LZ77</a>的<a href="https://zh.wikipedia.org/w/index.php?title=%E5%AD%97%E5%85%B8%E7%BC%96%E7%A0%81&amp;action=edit&amp;redlink=1">字典编码</a>机制，在一般的情况下压缩率比<a href="https://zh.wikipedia.org/wiki/Bzip2">bzip2</a>为高，用于压缩的字典文件大小可达4GB。</p>
<p><a href="https://zh.wikipedia.org/wiki/C%2B%2B">C++</a>语言写成的LZMA<a href="https://zh.wikipedia.org/wiki/%E5%BC%80%E6%94%BE%E6%BA%90%E7%A0%81">开放源码</a>压缩库使用了<a href="https://zh.wikipedia.org/wiki/%E5%8C%BA%E9%97%B4%E7%BC%96%E7%A0%81">区间编码</a>支持的<a href="https://zh.wikipedia.org/wiki/LZ77%E4%B8%8ELZ78">LZ77</a>改进压缩算法以及特殊的用于二进制的预处理程序。LZMA 对数据流、重复序列大小以及重续序列位置单独进行了压缩。LZMA支持几种<a href="https://zh.wikipedia.org/w/index.php?title=%E6%95%A3%E5%88%97%E9%93%BE&amp;action=edit&amp;redlink=1">散列链</a>变体、<a href="https://zh.wikipedia.org/wiki/%E4%BA%8C%E5%8F%89%E6%A0%91">二叉树</a>以及<a href="https://zh.wikipedia.org/wiki/%E5%9F%BA%E6%95%B0%E6%A0%91">基数树</a>作为它的字典查找算法基础。</p>
</blockquote>
<h2 id="lzma">LZMA算法引入</h2>
<p>对于数据传输，传输时间和传输质量是主要的两个参考维度。对于传输时间的压缩，数据压缩又是一个很好地可选项。目前正在处理蓝牙BLE（<strong>Bluetooth low energy</strong> (<strong>Bluetooth LE</strong>, <strong>BLE</strong>, marketed as <strong>Bluetooth Smart</strong>[<a href="https://en.wikipedia.org/wiki/Bluetooth_low_energy#cite_note-1">1]</a>)）调试，其中数据传输过程中，发现由于速度限制，传输时间较长，为了缩短传输时间，想利用压缩算法对所要传输的数据进行压缩处理后再进行传输，压缩完成之后再进行传输，以提高传输效率及节省传输时间。经过查阅各种资料，初步使用LZMA压缩算法进行压缩。</p>
<p>之所以选择<a href="https://zh.wikipedia.org/wiki/LZMA">LZMA</a>算法进行压缩处理，原因有以下几点：</p>
<ul>
<li>开源</li>
<li>iOS &amp; Android平台均支持，可夸平台使用</li>
<li>使用广泛稳定，7zip即采用该算法及衍生算法</li>
<li>压缩效率较高</li>
<li>多线程支持</li>
</ul>
<h2 id="ioslzma">iOS引入使用LZMA压缩算法方法</h2>
<h4 id="1lzma">选项1. 利用系统默认支持的LZMA压缩算法</h4>
<blockquote>
<p>The libcompression library provides an API for two styles of data compression:</p>
<ul>
<li>Block compression, where all of the input data is compressed or decompressed by one call to the compression or decompression function.</li>
<li>Streaming compression, where the compression or decompression function is called repeatedly to compress or decompress data from a source buffer to a destination buffer. Between calls, processed data is moved out of the destination buffer and new data is loaded into the source buffer.</li>
</ul>
</blockquote>
<p>Apple提供了一套通用的无损压缩算法，其中就支持LZMA、LZMA2压缩.</p>
<h5 id="">支持的压缩类型</h5>
<ul>
<li>Block Compression</li>
<li>Stream Compression</li>
</ul>
<h5 id="">支持的平台如下：</h5>
<ul>
<li>iOS 9.0+</li>
<li>macOS 10.11+</li>
<li>tvOS 9.0+</li>
<li>watchOS 2.0+</li>
</ul>
<h5 id="">支持的压缩算法</h5>
<ul>
<li>COMPRESSION_LZ4</li>
<li>COMPRESSION_ZLIB</li>
<li>COMPRESSION_LZMA</li>
<li>COMPRESSION_LZFSE</li>
</ul>
<p>提供的代码调用很简单，我根据我的需要，所使用的方法如下：</p>
<p><a href="https://developer.apple.com/reference/compression/1480986-compression_encode_buffer">压缩算法</a></p>
<pre><code class="language-c">size_t compression_encode_buffer(uint8_t *restrict dst_buffer, size_t dst_size, const uint8_t *restrict src_buffer, size_t src_size, void *restrict scratch_buffer, compression_algorithm algorithm);
</code></pre>
<p><a href="https://developer.apple.com/reference/compression/1481000-compression_decode_buffer?language=objc">解压方法</a></p>
<pre><code class="language-c">size_t compression_decode_buffer(uint8_t *restrict dst_buffer, size_t dst_size, const uint8_t *restrict src_buffer, size_t src_size, void *restrict scratch_buffer, compression_algorithm algorithm);
</code></pre>
<p>详细的调用代码如下</p>
<pre><code class="language-objective-c">- (void)testLZMA {
	// Data source file path.
	NSString *sourceFilePath = [NSString stringWithFormat:@"%@/source_data.txt", SYSTEM_DOCUMENT_PATH];
	// Compressed file path.
	NSString *zipFilePath = [NSString stringWithFormat:@"%@/compressed_data.7z", SYSTEM_DOCUMENT_PATH];
    
    NSData *fileData = [NSData dataWithContentsOfFile:sourceFilePath];
    DDLogDebug(@"Before compress: %ld bytes", fileData.length);
    
    uint8_t dstBuffer[fileData.length];
    memset(dstBuffer, 0, fileData.length);
    
    size_t compressResultLength = compression_encode_buffer(dstBuffer, fileData.length, [fileData bytes], fileData.length, NULL, COMPRESSION_LZMA);
    if(compressResultLength &gt; 0) {
        NSData *dataAfterCompress = [NSData dataWithBytes:dstBuffer length:compressResultLength];
        DDLogDebug(@"Compress successfully. After compress：%ld bytes", dataAfterCompress.length;
        // Write compressed data into file.
        [dataAfterCompress writeToFile:zipFilePath atomically:YES];
    } else {
        DDLogError(@"Compress FAILED!!!");
    }
}
</code></pre>
<p>该方法集成使用起来非常简单，对于基本的压缩需求足够可以满足，且不会对App的大小造成太大影响，不会很大增加，如果没有特殊需求，该方法是首选。</p>
<h4 id="2lzmasdkojbcframework">选项2. 集成第三方库<a href="https://github.com/ChenJian345/LzmaSDKOjbcFramework">LzmaSDKOjbcFramework</a></h4>
<p>这是我最先走的一条路，通过查阅相关资料，引入相关的开源库，自己实现了一个支持LZMA压缩算法的iOS工程用于Build Framework，现已开源到Github上，即<a href="https://github.com/ChenJian345/LzmaSDKOjbcFramework">LzmaSDKOjbcFramework</a>。</p>
<p>虽然最终采用的方案一，但在制作<a href="https://github.com/ChenJian345/LzmaSDKOjbcFramework">LzmaSDKOjbcFramework</a>过程中，也有一些收获，现分享给大家，愿对大家有些帮助。</p>
<p>最初找到的LZMA的iOS支持库是 <a href="https://github.com/OlehKulykov/LzmaSDKObjC">LzmaSDKObjC</a>，但是这个库在引入开发工程中过程中，由于使用的cocoaPods， 必须使用<code>use_frameworks!</code> 才可以使用，但是由于podfile中存在其他引入的第三方库，这些库不适用<code>use_frameworks! </code>限制。</p>
<p>此时陷入两难境地，使用<code>use_frameworks! </code>导致其他不支持framework的库不可用，如果不使用，LzmaSDKObjC则会报如下错误:</p>
<pre><code>Codec was not compiled in or stripped by static linking. 
Make sure you are using 'use_frameworks!' and/or dynamic linking ...
</code></pre>
<p>而CocoaPods又不支持针对某一第三方库来规定使用<code>use_frameworks! </code></p>
<p>既然这样，我打算自己创建一个iOS Framework工程开源，供团队内部及所有人方便使用。</p>
<h4 id="">使用步骤</h4>
<h5 id="step1">Step1</h5>
<p>在<a href="https://github.com/ChenJian345/LzmaSDKOjbcFramework">LzmaSDKOjbcFramework</a>工程目录下，由于工程需要<code>Inlineobjc</code>库，所以使用CocoaPods进行安装，命令行执行如下命令：</p>
<pre><code>$ pod install
</code></pre>
<h5 id="step2">Step2</h5>
<p>打开workspace工程文件，xCode中看到的内容如下：</p>
<p><a href="https://camo.githubusercontent.com/184a2b2cee82d0a9ccb5e542ad7d7c2ab131e25c/687474703a2f2f7777312e73696e61696d672e636e2f6c617267652f303036744e6337396a773166613135326c626d316e6a333069653074716163702e6a7067"><img src="https://camo.githubusercontent.com/184a2b2cee82d0a9ccb5e542ad7d7c2ab131e25c/687474703a2f2f7777312e73696e61696d672e636e2f6c617267652f303036744e6337396a773166613135326c626d316e6a333069653074716163702e6a7067" alt="img"></a></p>
<h5 id="step3">Step3</h5>
<p>Archive工程并导出<code>LzmaSDKObjC.framework</code>文件到所需的工程路径下使用，使用如下：</p>
<pre><code class="language-objc">- (void)testLZMA {
	NSString *sourceFilePath = [NSString stringWithFormat:@"%@/source_data.txt", SYSTEM_DOCUMENT_PATH];
    NSString *zipFilePath = [NSString stringWithFormat:@"%@/compressed_data.7z", SYSTEM_DOCUMENT_PATH];
	DDLogDebug(@"\n\n ********** LZMA ********** \nSrc File: %@\n7Zip File:%@\n\n", sourceFilePath, zipFilePath);
    // Create writer
    LzmaSDKObjCWriter * writer = [[LzmaSDKObjCWriter alloc] initWithFileURL:[NSURL fileURLWithPath:zipFilePath]];
    
    // Add file data's or paths
//    [writer addData:[NSData ...] forPath:@"MyArchiveFileName.txt"]; // Add file data
    [writer addPath:sourceFilePath forPath:@"."]; // Add file at path
//    [writer addPath:@"/Path/SomeDirectory" forPath:@"SomeDirectory"]; // Recursively add directory with all contents
    
    // Setup writer
    writer.delegate = self; // Track progress
//    writer.passwordGetter = ^NSString*(void) { // Password getter
//        return @"1234";
//    };
    
    // Optional settings
    writer.method = LzmaSDKObjCMethodLZMA; // or LzmaSDKObjCMethodLZMA
    writer.solid = YES;
    writer.compressionLevel = 7;
    writer.encodeContent = YES;
    writer.encodeHeader = YES;
    writer.compressHeader = YES;
    writer.compressHeaderFull = YES;
    writer.writeModificationTime = NO;
    writer.writeCreationTime = NO;
    writer.writeAccessTime = NO;
    
    // Open archive file
    NSError * error = nil;
    [writer open:&amp;error];
    
    // Write archive within current thread
    [writer write];
}
</code></pre>
<p>该方式的优点是支持的可选项较广，可以广泛的定制各种参数，但缺点是导入库后会导致应用包的体积变大，所以需要根据自身需求来选择。</p>
<p>ENJOY.</p>