//
//  ViewController.swift
//  Monster
//
//  Created by Kevin Nguyen on 10/9/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit

class MonsterTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var monsters : [Monster] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        monsters = (UIApplication.shared.delegate as! AppDelegate).getData()!
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monsters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let monster = monsters[indexPath.row]
        
        cell.textLabel?.text = monster.name
        cell.detailTextLabel?.text = monster.emoji
        return cell;
    }
    
    // Delete record if cell editing style is enabled
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            let monster = monsters[indexPath.row]
            context.delete(monster)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                monsters = try context.fetch(Monster.fetchRequest())
            }
            catch { print("Fetching Monsters Failed") }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: monsters[indexPath.row])
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detail") {
            let dvc = segue.destination as! MonsterDetailViewController
            
            // Passes the selected Monster and index to detail view
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedMonster = monsters[indexPath.row]
                dvc.currentMonster = selectedMonster
                dvc.currentMonsterIndex = indexPath.row
            }
        }
    }
    
}

