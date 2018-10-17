//
//  LineStore.swift
//  CopyCat
//
//  Created by Drew Sullivan on 10/17/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class LineStore {
    
    var lines = [String]()
    var count: Int {
        return lines.count
    }
    
    func addLine(_ line: String) {
        lines.append(line)
    }
    
}
