//
//  ChatViewController.swift
//  TotersTest
//
//  Created by Apple on 8/17/20.
//  Copyright © 2020 Sulyman. All rights reserved.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var user: User!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.context = appDelegate.persistentContainer.viewContext
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        
        self.navigationController?.navigationBar.backgroundColor = .white
        self.title = user.name
        
        self.textField.delegate = self
        
        self.backgroundImageView.contentMode = .scaleToFill
        
        sendButton.addTarget(self, action: #selector(sendButtonPressed(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.sendButton.isEnabled = false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.container.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.container.frame.origin.y != (self.view.frame.maxY - self.container.frame.height) {
            self.container.frame.origin.y = (self.view.frame.maxY - self.container.frame.height)
        }
    }
    @objc func sendButtonPressed(_ sender: UIButton){
        if textField.text != ""{
            let text = textField.text!
            textField.text = ""
            saveToCoreData(with: text, isMyMessage: true)
            fetchFromCoreData()
            
            let delay = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay)) {
                self.saveToCoreData(with: text, isMyMessage: false)
                self.saveToCoreData(with: text, isMyMessage: false)
                self.fetchFromCoreData()
            }
        }
        
    }
    func saveToCoreData(with text: String, isMyMessage: Bool){
        
        let messageEntity = NSEntityDescription.entity(forEntityName: "Message", in: context)
        
        let newMessage = Message(entity: messageEntity!, insertInto: context)
        
        newMessage.text = text
        newMessage.date = Date()
        newMessage.isMyMessage = isMyMessage
        user.addToMessages(newMessage)
        user.dateSpokenTo = Date()
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    func fetchFromCoreData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        let result = context.object(with: self.user.objectID)
        self.user = result as? User
        self.tableView.reloadData()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //    2. Chat page: Sending a message to the random user would echo the same message twice after a randomized delay of 0.5 seconds. Persist all messages. UI is composed of:
    //    1. A back button that takes you back to 1.
    //    2. Name of person we’re talking to in the title.
    //    3. Content layout, shows all chats that’ve been sent back and forth previously.
    //    4. Text input and send button.
    
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseChat", for: indexPath) as! ChatTableViewCell
        cell.layer.backgroundColor = UIColor.clear.cgColor
        let array = user.messages?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) as! [Message]
        cell.setData(withMessage: array[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.messages?.allObjects.count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension ChatViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.sendButton.isEnabled = true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            self.sendButton.isEnabled = false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
