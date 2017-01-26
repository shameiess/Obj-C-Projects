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
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            // Create new Monster object
            var _: Monster = createMonster(name: nameTextField.text!, levelSet: 1, description: descriptionTextField.text!, ability: abilityTextField.text!, specialPower: specialTextField.text!, powerLevel: abilitySlider.value, specialPowerLevel: specialSlider.value)
            
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

extension AddMonsterViewController {
    public func createMonster(name: String, levelSet: Int16, description: String, ability: String, specialPower: String, powerLevel: Float, specialPowerLevel: Float) -> Monster {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let monster = Monster(context: context)
        monster.name = name
        monster.level = levelSet
        monster.emoji = description
        monster.ability = ability
        monster.special = specialPower
        monster.abilityPower = powerLevel
        monster.specialPower = specialPowerLevel
        return monster
    }
}
