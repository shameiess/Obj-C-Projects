//
//  AddMonsterViewController.swift
//  Monster
//
//  Created by Kevin Nguyen on 10/9/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit

class AddMonsterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var abilityTextField: UITextField!
    @IBOutlet weak var abilitySlider: UISlider!
    
    @IBOutlet weak var specialTextField: UITextField!
    @IBOutlet weak var specialSlider: UISlider!
    
    
    @IBAction func addMonsterButton(_ sender: AnyObject) {
        if (nameTextField.text!.isEmpty) || (descriptionTextField.text!.isEmpty) || (abilityTextField.text!.isEmpty) || (specialTextField.text!.isEmpty) {
            displayAlert(title: "😭", message: "Please fill in all the required fields. Thanks!")
        }
        else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            // Create new Monster object
            let monster = Monster(context: context)
            monster.name = nameTextField.text!
            monster.level = 1
            monster.emoji = descriptionTextField.text!
            monster.ability = abilityTextField.text!
            monster.special = specialTextField.text!
            monster.abilityPower = Float(abilitySlider.value)
            monster.specialPower = Float(specialSlider.value)
            
            // Saves to Core Data
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            navigationController!.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
}
