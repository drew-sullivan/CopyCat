//
//  CopyPasteTableViewController.swift
//  CopyCat
//
//  Created by Drew Sullivan on 10/16/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class LinesViewController : UITableViewController {
    
    var lineStore: LineStore!
    
    @IBOutlet var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("copyPasteTableViewController")
        print(lineStore.lines)
    }
    
}
