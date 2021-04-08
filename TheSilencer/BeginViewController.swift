//
//  ViewController.swift
//  TheSilencer
//
//  Created by Aaron Barlow on 4/7/21.
//  Copyright © 2021 Aaron Barlow. All rights reserved.
//

import UIKit

class BeginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.setToolbarHidden(true, animated: false)
    }

}

