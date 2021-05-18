//
//  UserWritingCommentViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/18.
//

import UIKit
import Alamofire
import SwiftyJSON

//커멘트를 받아오고, 그 커멘트의 이메일을 받아와서
//해당 이메일의 이미지 url을 받아서 이미지로 변환한 다음 cell에 넘긴다

class UserWritingCommentViewController: UIViewController {
    
    @IBOutlet weak var commentTableView: UITableView!
    
    
    var writingId: Int?
    var comments: [Comment]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}


extension UserWritingCommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.TABLE_VIEW_CELL_ID.commentCell, for: indexPath) as? UserCommentCell,
              let comments = self.comments else {return UITableViewCell()}
        
        let comment = comments[indexPath.row]
        
        cell.update(comment: comment)
        
        return cell
    }
    
}


class UserCommentCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    func update(comment: Comment){
        //이미지를 받아와서 업데이트 함
        
        userLabel.text = comment.commenter
        commentLabel.text = comment.comment
    }
    
}
