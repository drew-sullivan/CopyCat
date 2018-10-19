//
//  UINavigationController.swift
//  CopyCat
//
//  Created by Drew Sullivan on 10/19/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func setToolbarHeight(_ height: CGFloat) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: height)
    }
}
