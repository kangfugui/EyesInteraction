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
        webView.load(request)
    }
}
