//
//  UserLikedWritingsViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/16.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserLikedWritingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var likedWritings: [UserWriting] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likedWritings.removeAll()
        getWritings()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SEGUE_ID.toDetailLikedWriting {
            
            guard let vc = segue.destination as? UserLikedDetailWritingViewController else {return}
            
            guard let selectedIndex = tableView.indexPathForSelectedRow?.row else {return}
            
            let writing = likedWritings[selectedIndex]
            
            vc.userWriting = writing
            
        }
    }
    
    
    func getWritings(){
        
        AF.request(K.API.LIKED_WRITINGS, method: .get, interceptor: RequestInterceptor()).responseJSON { [weak self] response in
            
            guard let self = self else {return}

            switch response.result {
            case .success(let value):
                let json = JSON(value)
              
                for (index, post) in json {
               
                    if let title = post["title"].string,
                       let content = post["content"].string,
                       let views = post["views"].int,
                       let id = post["id"].int,
                       let imageURL = post["imageURL"].string,
                       let name = post["name"].string{
                  
                        let data = try! Data(contentsOf: URL(string: imageURL)!)
                        print(data)
                        let image = UIImage(data: data)
                        
                        self.likedWritings.append(UserWriting(id: id, title: title, content: content, views: views, image: image!, name: name))
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension UserLikedWritingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.likedWritings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LikedCell", for: indexPath) as? LikedWritingsCell else {return UITableViewCell()}
        
        let writing = self.likedWritings[indexPath.row]
        
        cell.updateCell(writing: writing)
        
        return cell
    }
    
}

class LikedWritingsCell: UITableViewCell {
    
    @IBOutlet weak var likedImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    
    fileprivate func updateCell(writing: UserWriting) {
        
        likedImage.image = writing.image
        titleLabel.text = writing.title
        viewsLabel.text = "Views: \(writing.views)"
        writerLabel.text = "by. \(writing.name)"
    }
}
