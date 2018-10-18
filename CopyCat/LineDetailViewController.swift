//
//  LineDetailViewController.swift
//  CopyCat
//
//  Created by Drew Sullivan on 10/18/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class LineDetailViewController: UIViewController {
    
    @IBOutlet var lineTextField: UITextField!
    var lineText: String!
    
    @IBAction func copyToClipboard(_ sender: Any) {
        print("tapped")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lineTextField.text = lineText
    }
}
