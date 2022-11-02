//
//  AddViewController.swift
//  IOS_2022
//
//  Created by Albina on 2.11.22.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var docField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    public var completion: ((String, String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))

    }
    
    @objc func didTapSaveButton(){
        if let titleText = titleField.text, !titleText.isEmpty,
           let docText = docField.text, !docText.isEmpty,
           let bodyText = bodyField.text, !bodyText.isEmpty{
            
            let targetDate = datePicker.date
            
            completion?(titleText, docText, bodyText, targetDate)
        }
    }

}
