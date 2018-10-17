//
//  ViewController.swift
//  CopyCat
//
//  Created by Drew Sullivan on 10/16/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit
import FirebaseMLVision

class CameraViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var lineStore = LineStore()
    var textRecognizer: VisionTextRecognizer!
    var isFirstTime: Bool = true

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let vision = Vision.vision()
        textRecognizer = vision.onDeviceTextRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        presentCamera()
    }
    
    func presentCamera() {
        if !isFirstTime {
            return
        }
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        isFirstTime = false
    }
    
    //MARK: - Text Recognition
    func runTextRecognition(on image: UIImage) {
        let rotatedImage = image.rotate(radians: .pi * 2)
        let visionImage = VisionImage(image: rotatedImage!)
        textRecognizer.process(visionImage, completion: { (features, error) in
            self.extractLinesFromDocument(from: features, error: error)
            self.presentLinesTableView()
        })
    }
    
    func extractLinesFromDocument(from text: VisionText?, error: Error?) {
        guard let features = text else {
            return
        }
        for block in features.blocks {
            for line in block.lines {
                lineStore.addLine(line.text)
            }
        }
    }
    
    // MARK: - ImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        runTextRecognition(on: image)
        dismiss(animated: true, completion: nil)
    }
    
    func presentLinesTableView() {
//        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
//        let displayWidth: CGFloat = self.view.frame.width
//        let displayHeight: CGFloat = self.view.frame.height
        
//        lineTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
//        lineTableView.register(UITableViewCell.self, forCellReuseIdentifier: "LineCell")
//        lineTableView.dataSource = self
//        lineTableView.delegate = self
//        lineTableView.rowHeight = 55
//        self.view.addSubview(lineTableView)
        
//        self.navigationController?.pushViewController(lineTableView, animated: true)
    }
    
    // MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineStore.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel!.text = "\(lineStore.lines[indexPath.row])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("LINE: \(lineStore.lines[indexPath.row])")
    }
    
}
