//
//  WebViewController.swift
//  EyesInteraction
//
//  Created by hb on 2019/4/14.
//  Copyright © 2019 ky. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest(url: URL(string: "https://www.qq.com/?fromdefault")!)
        webView.navigationDelegate = self
        webView.load(request)
        
        
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
//        let script = "var element = document.elementFromPoint(150, 200); element.style.backgroundColor = 'lightgreen'; element.click();"
        
//        webView.evaluateJavaScript(script) { (result, err) in
//            print(result ?? "no result")
//            print(err ?? "no err")
//        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        print(error)
    }
}
