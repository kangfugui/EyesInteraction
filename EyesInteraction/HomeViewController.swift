//
//  HomeViewController.swift
//  EyesInteraction
//
//  Created by hb on 2019/4/14.
//  Copyright © 2019 ky. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func button1DidTap(_ sender: Any) {
        
        let web = WebViewController()
        navigationController?.pushViewController(web, animated: true)
    }
    
}
