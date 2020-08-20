//
//  ViewController.swift
//  TotersTest
//
//  Created by Apple on 8/15/20.
//  Copyright © 2020 Sulyman. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    let firstNames = ["Liam","Noah","William","James", "Oliver","Benjamin","Elijah","Lucas","Mason","Logan","Alexander","Ethan","Jacob","Michael","Daniel","Henry","Jackson","Sebastian","Aiden","Matthew","Samuel","David","Joseph","Carter","Owen","Wyatt","John","Jack","Luke","Jayden","Dylan"]
    
    let lastNames = ["Pearson", "Adams", "Cole", "Francis", "Andrews", "Casey", "Gross", "Lane", "Thomas", "Patrick", "Strickland", "Nicolas", "Freeman"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.context = appDelegate.persistentContainer.viewContext
        self.context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        
        self.users = fetchFromCoreData()
        if users.count != 0{
            
        }
        else{
            while self.users.count != 200{
                saveToCoreData()
                self.users = fetchFromCoreData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.users = fetchFromCoreData()
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
        self.tableView.reloadData()
    }
    
    func generateName(fName: String, lName: String)->String{
        return fName + " " + lName
    }
    func generateNumber(inRange range: Int) -> Int{
        return Int.random(in: 0..<range)
    }

    func saveToCoreData(){
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        
        let newUser = User(entity: entity!, insertInto: context)
        let name = self.generateName(fName: self.firstNames[generateNumber(inRange: self.firstNames.count)], lName: self.lastNames[generateNumber(inRange: self.lastNames.count)])
        
        newUser.name = name
        newUser.image = "userImage"+"\(generateNumber(inRange: 4))"
        newUser.dateSpokenTo = Date()
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    func fetchFromCoreData()-> [User]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: "dateSpokenTo", ascending: false)]
        var users: [User] = []
        do {
            let result = try context.fetch(request)
            for data in result as! [User] {
                users.append(data)
                print(data.name ?? "")
            }
            
        } catch {
            
            print("Failed")
        }
        
        return users
    }
    
    //    -Generate a list of 200 random users (user names don’t need to be real, but duplicates are not allowed
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToChatSegue"{
            let destination = segue.destination as! ChatViewController
            destination.user = users[sender as! Int]
        }
    }
    
}
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse", for: indexPath) as! ChatUserTableViewCell
        cell.setData(withUser: self.users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("user Count is : \(users.count)")
        return users.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "ToChatSegue", sender: indexPath.row)
    }
}
