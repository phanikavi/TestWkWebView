//
//  ViewController.swift
//  TestWkWebView
//
//  Created by Phani Yarlagadda on 1/20/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    private(set) var webview: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        webview = WKWebView(frame: .zero, configuration: config)

        webview?.navigationDelegate = self
        view = webview

        webview?.load(URLRequest(url: URL(string: "https://janus.conf.meetecho.com/videocalltest.html")!))
    }


}

