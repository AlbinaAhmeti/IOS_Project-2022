//
//  AddViewController.swift
//  IOS_2022
//
//  Created by Albina on 2.11.22.
//

import UIKit

class AddViewController: UIViewController {

    //UI Components
    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    //Function which takes a parameter and return to void
    public var completion: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Create save button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))

    }
    
    //Function for sava button and validate
    @objc func didTapSaveButton(){
        if let titleText = titleField.text, !titleText.isEmpty,
           let bodyText = bodyField.text, !bodyText.isEmpty{
            
            //Get the actual date from the date picker
            let targetDate = datePicker.date
            //Pass title, body, data
            completion?(titleText, bodyText, targetDate)
        }
    }
}
