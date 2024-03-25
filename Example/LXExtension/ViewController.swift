//
//  ViewController.swift
//  LXExtension
//
//  Created by Aliffter on 03/21/2024.
//  Copyright (c) 2024 Aliffter. All rights reserved.
//

import UIKit
import LXExtension
import MBProgressHUD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        MBProgressHUD.showSuccess("成功了")
    }

}

