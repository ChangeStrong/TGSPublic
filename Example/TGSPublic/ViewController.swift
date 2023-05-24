//
//  ViewController.swift
//  TGSPublic
//
//  Created by ChangeStrong on 05/23/2023.
//  Copyright (c) 2023 ChangeStrong. All rights reserved.
//

import UIKit
import TGSPublic
class ViewController: TGBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if TGAppEnviroment == 1{
            let tempStr = "".urlEncodeOnlyUTF8()
           
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

