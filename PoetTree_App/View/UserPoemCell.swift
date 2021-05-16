//
//  UserPoemCell.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/01.
//

import UIKit

class UserPoemCell: UITableViewCell {

    
    @IBOutlet weak var daysImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    
    func updateCell(userWriting: UserWriting){
        
        daysImage.image = userWriting.image
        title.text = userWriting.title
        viewsLabel.text = "View: \(userWriting.views)"
    }
    
}
