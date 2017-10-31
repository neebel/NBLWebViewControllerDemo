# NBLWebViewController

NBLWebViewController is a delightful library for loading webpage ，it's based on WKWebView.

![NBLWebViewController](./NBLWebViewController.gif)

Usage：

pod 'NBLWebViewController', '~> 0.0.2'

Subclass NBLWebViewController, and implement methods:

1. registerMessageHandler

2. dealWithMessage:(WKScriptMessage *)message

In these methods, you can do your own logic


NBLWebViewController 是一个轻量化的网页加载组件，基于WKWebView，由于WKWebView支持的最低平台为iOS8，所以项目如果需要兼容iOS7，
就要自己使用UIWebView了。

NBLWebViewController提供了加载进度条、返回上一级页面和关闭WebView、JS和OC交互等功能。

如何使用：

pod 'NBLWebViewController', '~> 0.0.2'

新建类继承自 NBLWebViewController，重写registerMessageHandler 和 dealWithMessage:(WKScriptMessage *)message，在这两个方法中可以处理自己的业务逻辑，包括为JS提供原生方法，OC执行JS代码等。注意：在注册MessageHandler时的名称以及具体的参数名称要提前和JS约定好，不然会无法调用。

ps : 如果需要对基类做样式或者逻辑的大改动，你也可以不适用pod的方式集成，直接将项目源文件拖入工程修改使用即可