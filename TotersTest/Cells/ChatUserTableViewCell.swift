//
//  ChatUserTableViewCell.swift
//  TotersTest
//
//  Created by Apple on 8/15/20.
//  Copyright © 2020 Sulyman. All rights reserved.
//

import UIKit

class ChatUserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(withUser user: User){
        
        self.userImageView.image = UIImage(named: user.image ?? "")
        self.userImageView.layer.cornerRadius = self.userImageView.frame.width/2
        self.nameLabel.text = user.name
        
        guard user.messages!.count > 0 else {
            self.lastMessageLabel.text = ""
            self.dateTimeLabel.text = ""
            return
        }
        let userMessages = user.messages?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) as! [Message]
        self.lastMessageLabel.text = (userMessages.last)?.text!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        let calendar = Calendar(identifier: .gregorian)
        if calendar.component(.day, from: Date()) == calendar.component(.day, from: ((user.messages?.allObjects.last as? Message)?.date!)!){
            dateFormatter.dateFormat = "hh:mm"
        }
        let dateString = dateFormatter.string(from: ((user.messages?.allObjects.last as? Message)?.date!)!)
        self.dateTimeLabel.text = dateString
        
    }
    
}
