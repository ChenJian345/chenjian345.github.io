---
title: "iOS端查看PDF文档实现方案"
pubDate: "2018-03-21"
slug: "iosduan-cha-kan-pdfwen-dang-shi-xian-fang-an"
tags: []
category: "技术"
excerpt: "文 · Mark 在不同端查看一些文档时，往往会展现出千奇百怪的格式，呈现给用户的也是不同的展示效果。为了保持原始文稿的格式，保证展现效果的统一，PDF文稿可以很好解决格式在不同端文稿展现格式差异，保持原始文稿的展现效果。 对于移动端的开发..."
---

<p>文 · Mark</p>
<p>在不同端查看一些文档时，往往会展现出千奇百怪的格式，呈现给用户的也是不同的展示效果。为了保持原始文稿的格式，保证展现效果的统一，PDF文稿可以很好解决格式在不同端文稿展现格式差异，保持原始文稿的展现效果。</p>
<p>对于移动端的开发工作中，查看PDF也是常见的需求，本文针对iOS端查看PDF文档给出实现方案，包括通过网络端读取和本地读取两种方式查看PDF文档。</p>
<p><strong>读取方式</strong></p>
<ul>
<li>网络读取</li>
<li>本地读取</li>
</ul>
<p><strong>测试文稿样本</strong></p>
<ul>
<li><a href="https://i.loli.net/2018/03/21/5ab1fe2b4e3e5.png">Accessory Design Guidelines for Apple Devices</a></li>
<li>作者：Apple Inc.</li>
<li>分辨率：612 * 792 px</li>
<li>大小： 22.1 MB</li>
<li>页数： 177</li>
</ul>
<h3 id="">实现方式</h3>
<p>经过调研，目前针对网络读取，可以使用UIWebView进行PDF文档加载及展示；针对本地PDF文档读取，可以通过QLPreviewController进行读取并展示。</p>
<h4 id="uiwebview">UIWebView展现</h4>
<p>本方法用于在线展示云端PDF文档;</p>
<p>关键代码如下：</p>
<pre><code class="language-objective-c">self.webViewPDFViewer = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_AND_STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_AND_STATUS_BAR_HEIGHT)];
self.webViewPDFViewer.delegate = self;
[self.view addSubview:self.webViewPDFViewer];

// Load the PDF document online
NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:PDF_FILE_URL]];
[self.webViewPDFViewer loadRequest:urlRequest];
</code></pre>
<p>展现截图：</p>
<img src="https://i.loli.net/2018/03/21/5ab1fe2b4e3e5.png" style="zoom:0.5">
<p><em><strong>注意</strong></em></p>
<ul>
<li>通过WebView加载网络端过程中会有等待情况，建议增加Loading提示</li>
</ul>
<h4 id="qlpreviewcontroller">QLPreviewController展现</h4>
<p><a href="https://developer.apple.com/documentation/quicklook/qlpreviewcontroller">该方式</a>可查看多种文件类型，主要适用于本地文件读取展示，包括：</p>
<ul>
<li>iWork documents</li>
<li>Microsoft Office documents (Office ‘97 and newer)</li>
<li>Rich Text Format (RTF) documents</li>
<li>PDF files</li>
<li>Images</li>
<li>Text files whose uniform type identifier (UTI) conforms to the <code>public.text</code> type (see <a href="https://developer.apple.com/library/content/documentation/Miscellaneous/Reference/UTIRef/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009257">Uniform Type Identifiers Reference</a>)</li>
<li>Comma-separated value (csv) files</li>
</ul>
<p><strong>关键代码</strong></p>
<pre><code class="language-objective-c">/*!
 * @abstract Returns the item that the preview controller should preview.
 * @param panel The Preview Controller.
 * @param index The index of the item to preview.
 * @result An item conforming to the QLPreviewItem protocol.
 */
- (id &lt;QLPreviewItem&gt;)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    NSString *pdfFilePath = [[NSBundle mainBundle] pathForResource:@"Accessory-Design-Guidelines" ofType:@"pdf"];
    return [NSURL fileURLWithPath:pdfFilePath];
}
</code></pre>
<p><strong>注意</strong></p>
<p>在iOS11.2 系统上，查看云端PDF文档会出现如下错误：</p>
<pre><code>... : [default] Couldn't issue file extension for url: https://developer.apple.com/accessories/Accessory-Design-Guidelines.pdf #PreviewItem
</code></pre>
<p><a href="https://forums.developer.apple.com/thread/91835">相关链接及解决方法</a></p>
<p>若使用该方法查看PDF文档，建议先将文件进行下载，保存到App的Document某一目录，再进行文件展示。</p>
<h4 id="pdfkit">PDFKit展现</h4>
<p>该方式是iOS11.0 SDK添加，支持PDF文件读取和写入。</p>
<p>考虑到此API版本需要的系统版本较高，本文暂不调研，后续会进行专门补充。</p>