//
//  ViewController.swift
//  clima
//
//  Created by Jayz Walker on 11/10/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDelegation()
        
    }
    
    func setDelegation() {
        searchTextfield.delegate = self
    }
    
    @IBAction func onSearchButtonPressed(_ sender: UIButton) {
        searchTextfield.endEditing(true)
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text != "") {
            return true
        }
        textField.placeholder = "Please type something!"
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
        textField.placeholder = "Search"
        
    }
    
}
