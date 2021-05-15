//
//  PostsCell.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/06.
//

import UIKit

class PostsCell: UITableViewCell {
    
    
    @IBOutlet weak var daysImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    
    func updateCell(writing: WritingGet){
        
        daysImage.image = writing.image
        titleLabel.text = writing.title
        likesLabel.text = "❤️: \(writing.likes)"
        writerLabel.text = "by. \(writing.userName)"
        
    }
    
}
