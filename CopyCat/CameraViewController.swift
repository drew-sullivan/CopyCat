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
    
    var mediaChoice: UIImagePickerController.SourceType!
    var lineStore = LineStore()
    var textRecognizer: VisionTextRecognizer!
    var isFirstTime: Bool = true
    
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var photoGalleryButton: UIBarButtonItem!
    
    
    //MARK: - Actions
    @IBAction func takePicture(_ sender: Any) {
        resetSettings()
        mediaChoice = .camera
        getPicture()
    }
    
    @IBAction func getPictureFromPhotoGallery(_ sender: Any) {
        resetSettings()
        mediaChoice = .photoLibrary
        getPicture()
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vision = Vision.vision()
        textRecognizer = vision.onDeviceTextRecognizer()
        
        tableView.rowHeight = 65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        getPicture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    //MARK: - Text Recognition
    func runTextRecognition(on image: UIImage) {
        let rotatedImage = image.rotate(radians: .pi * 2)
        let visionImage = VisionImage(image: rotatedImage!)
        textRecognizer.process(visionImage, completion: { (features, error) in
            self.extractLinesFromDocument(from: features, error: error)
            self.tableView.reloadData()
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
    func getPicture() {
        if !isFirstTime {
            return
        }
        let imagePicker = UIImagePickerController()
        if mediaChoice == .camera {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
            } else {
                imagePicker.sourceType = .photoLibrary
            }
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        isFirstTime = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        runTextRecognition(on: image)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineStore.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LineCell", for: indexPath)
        cell.textLabel!.text = "\(lineStore.lines[indexPath.row])"
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    // MARK: - Rotate Device
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }
    
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showLine"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let text = lineStore.lines[row]
                let lineDetailViewController = segue.destination as! LineDetailViewController
                lineDetailViewController.lineText = text
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    fileprivate func resetSettings() {
        lineStore.lines = []
        isFirstTime = true
    }
    
}
