# NBLWebViewController

NBLWebViewController is a delightful library for loading webpage .

![NBLWebViewController](./NBLWebViewController.gif)

Usage：

pod 'NBLWebViewController', '~> 0.0.2'

Subclass NBLWebViewController, and implement methods:

1. registerMessageHandler

2. dealWithMessage:(WKScriptMessage *)message

In these methods, you can do your own logic