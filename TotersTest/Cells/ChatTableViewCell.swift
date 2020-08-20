//
//  ChatTableViewCell.swift
//  TotersTest
//
//  Created by Apple on 8/18/20.
//  Copyright © 2020 Sulyman. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
    }
    
    private func setIsMyMessage(){
        
        self.container.semanticContentAttribute = .forceLeftToRight
        self.container.backgroundColor = .lightGray
    }
    private func setisNotMyMessage(){
        
        self.container.backgroundColor = .systemBlue
        self.container.semanticContentAttribute = .forceRightToLeft
    }
    func setData(withMessage message: Message){
        
        self.container.layer.cornerRadius = 15
        self.container.clipsToBounds = true
        
        self.titleLabel.text = message.text
        switch message.isMyMessage{
            
        case false:
            setisNotMyMessage()
            break
            
        case true:
            setIsMyMessage()
            break
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
