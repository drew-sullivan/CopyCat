//
//  HomePageViewController.swift
//  CopyCat
//
//  Created by Drew Sullivan on 10/19/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    var mediaChoice: UIImagePickerController.SourceType?
    
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var photoLibraryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        mediaChoice = .camera
    }
    
    @IBAction func photoLibraryButtonTapped(_ sender: Any) {
        mediaChoice = .photoLibrary
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showLinesTableViewController"?:
            let cameraViewController = segue.destination as! CameraViewController
            cameraViewController.mediaChoice = mediaChoice
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
}
