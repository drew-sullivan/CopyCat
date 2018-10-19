//
//  HomePageViewController.swift
//  CopyCat
//
//  Created by Drew Sullivan on 10/19/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    var choice: UIImagePickerController.SourceType?
    
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var cameraRollButton: UIButton!
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        choice = .camera
    }
    
    @IBAction func cameraRollButtonTapped(_ sender: Any) {
        choice = .photoLibrary
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showLinesViewController"?:
            let cameraViewController = segue.destination as! CameraViewController
            cameraViewController.mediaChoice = choice
        default:
            preconditionFailure("Unexpected segue identifier")        }
    }
    
}
