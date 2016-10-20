//
//  MonsterDetailViewController.swift
//  Monster
//
//  Created by Kevin Nguyen on 10/10/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit
import CoreData
import SpriteKit

class MonsterDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var abilityTextField: UITextField!
    @IBOutlet weak var abilitySlider: UISlider!
    @IBOutlet weak var specialTextField: UITextField!
    @IBOutlet weak var specialSlider: UISlider!
    
    @IBAction func saveButton(_ sender: AnyObject) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let monsters = try context.fetch(Monster.fetchRequest()) as! [Monster]
            print(monsters[currentMonsterIndex!])
            monsters[currentMonsterIndex!].name = nameTextField.text!
            monsters[currentMonsterIndex!].emoji = descriptionTextField.text!
            monsters[currentMonsterIndex!].ability = abilityTextField.text!
            monsters[currentMonsterIndex!].abilityPower = abilitySlider.value
            monsters[currentMonsterIndex!].special = specialTextField.text!
            monsters[currentMonsterIndex!].specialPower = specialSlider.value
        } catch { print("Fetching Monsters Failed") }
        
        // Saves to Core Data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    var currentMonster : Monster?
    var currentMonsterIndex : Int?
    var opponentMonster : Monster?
    var opponentMonsterIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameTextField.text = currentMonster?.name
        descriptionTextField.text = currentMonster?.emoji
        levelLabel.text =  "Level: " + String(describing: currentMonster!.level)
        abilityTextField.text = currentMonster?.ability
        abilitySlider.value = (currentMonster?.abilityPower)!
        specialTextField.text = currentMonster?.special
        specialSlider.value = (currentMonster?.specialPower)!
    }
    
    @IBAction func fightRandomMonster(_ sender: AnyObject) {
        
        if ((UIApplication.shared.delegate as! AppDelegate).getData()!.count <= 1) {
            displayAlert(title: "😋", message: "You need at least 2 monsters to fight. Please add one more!")
        }
        
        else {
        self.currentMonster = getCurrentMonster(atIndex: currentMonsterIndex)
        // Gets random monster
        self.opponentMonster = getRandomMonster().monster
        self.opponentMonsterIndex = getRandomMonster().index
        print("player ====  \(currentMonster)")
        print("opponent ==== \(opponentMonster)")
        }
    }
    
    func getCurrentMonster(atIndex: Int?) -> Monster? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let monsters = try context.fetch(Monster.fetchRequest()) as! [Monster]
            let currentMonster = monsters[atIndex!]
            return currentMonster
        }
        catch { print("Fetching Monsters Failed") }
        return nil
    }
    
    // Gets random monster aside from the current monster. Recursively calls back if the two monsters match.
    func getRandomMonster() -> (monster: Monster?, index: Int?) {
        // Gets random monster
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let monsters = try context.fetch(Monster.fetchRequest())
            let randomIndex = Int(arc4random_uniform(UInt32(monsters.count)))
            if randomIndex != currentMonsterIndex {
                let opponent = monsters[randomIndex] as! Monster
                self.opponentMonster = opponent

                return (opponent, randomIndex)
            }
        }
        catch { print("Fetching Monsters Failed") }
        return getRandomMonster()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fight") {
            let dvc = segue.destination as! FightView
            dvc.player = currentMonster
            dvc.playerIndex = currentMonsterIndex
            dvc.opponent = opponentMonster
            dvc.opponentIndex = opponentMonsterIndex
        }
    }
    
}
