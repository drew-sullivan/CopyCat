//
//  ViewController.swift
//  CopyCat
//
//  Created by Drew Sullivan on 10/16/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit
import FirebaseMLVision

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var textRecognizer: VisionTextRecognizer!
    var ocrLines: [String]?
    
    @IBOutlet var imageView: UIImageView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let vision = Vision.vision()
        textRecognizer = vision.onDeviceTextRecognizer()
    }
    
    // MARK: - Actions
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Text Recognition
    func runTextRecognition(on image: UIImage) {
        let rotatedImage = image.rotate(radians: .pi * 2)
        let visionImage = VisionImage(image: rotatedImage!)
        textRecognizer.process(visionImage, completion: { (features, error) in
            let lines = self.extractLinesFromDocument(from: features, error: error)
            self.switchScreen(given: lines)
        })
    }
    
    //MARK: - Helpers
    func extractLinesFromDocument(from text: VisionText?, error: Error?) -> [String] {
        var lines: [String] = []
        guard let features = text else {
            return lines
        }
        
        for block in features.blocks {
//            print("\nBLOCK\n\(block.text)")
            for line in block.lines {
//                print("\nLINE\n\(line.text)")
                lines.append(line.text)
                for element in line.elements {
//                    print(element.text)
                }
            }
        }
        return lines
    }
    
    // MARK: - ImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        runTextRecognition(on: imageView.image!)
        dismiss(animated: true, completion: nil)
    }
    
    func switchScreen(given lines: [String]) {
        print(lines)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let newViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "CopyPasteTableViewController") as UIViewController
        self.present(newViewController, animated: true, completion: {
            print("newViewController")
        })
    }
}
