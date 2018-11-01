//
//  LineDetailViewController.swift
//  CopyCat
//
//  Created by Drew Sullivan on 10/18/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class LineDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var lineTextField: UITextField!
    var lineText: String!
    
    @IBAction func copyToClipboard(_ sender: Any) {
        UIPasteboard.general.string = lineText
        toast(message: "Text added to clipboard!")
    }
    
    @IBAction func lowercaseText(_ sender: Any) {
        lineTextField.text = lineTextField.text?.lowercased()
    }
    
    @IBAction func uppercaseText(_ sender: Any) {
        lineTextField.text = lineTextField.text?.uppercased()
    }
    
    @IBAction func titleCaseText(_ sender: Any) {
        lineTextField.text = lineTextField.text?.capitalized
    }
    
    @IBAction func email(_ sender: Any) {
        let str = "mailto:\(lineTextField.text!)"
        navigateTo(str)
    }
    
    @IBAction func call(_ sender: Any) {
        let scrubbedNum = getScrubbedNum()
        let number = "tel://\(scrubbedNum)"
        navigateTo(number)
    }
    
    @IBAction func visitURL(_ sender: Any) {
        var stringToURL = lineTextField.text!
        let httpPrefix = "http://www."
        if !lineTextField.text!.hasPrefix(httpPrefix) {
            stringToURL = httpPrefix + stringToURL
        }
        navigateTo(stringToURL)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lineTextField.text = lineText
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    fileprivate func getScrubbedNum() -> String {
        let charsToRemove = Set<Character>(arrayLiteral: "+", "(", ")", " ")
        var scrubbedNum = ""
        for char in lineTextField.text! {
            if charsToRemove.contains(char) {
                continue
            }
            scrubbedNum += "\(char)"
        }
        return scrubbedNum
    }
    
    fileprivate func navigateTo(_ str: String) {
        if let url = URL(string: str) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
