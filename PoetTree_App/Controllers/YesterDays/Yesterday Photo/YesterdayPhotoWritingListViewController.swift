//
//  YesterdayPhotoWritingListViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/19.
//

import UIKit
import Alamofire
import SwiftyJSON

class YesterdayPhotoWritingListViewController: UIViewController {
    
    
    @IBOutlet weak var writingListTableView: UITableView!
    
    var image: UIImage?
    var sourceId: Int?
    var writings: [WritingGet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI { writings in
            
            self.writings = writings
            
            DispatchQueue.main.async {
                self.writingListTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectedWriting" {
            
            guard let vc = segue.destination as? YesterdayPhotoSelectedWritingViewController else {return}
            
            guard let index = self.writingListTableView.indexPathForSelectedRow?.row else {return}
            
            vc.writing = self.writings[index]
            
        }
    }
    
    
    fileprivate func setupUI(completion: @escaping (([WritingGet]) -> Void)){
        
        guard let id = self.sourceId else {return}
        
        AF.request(K.API.PHOTO_WRITING + "\(id)", method: .get).responseJSON { response in
            
            debugPrint(response)
            
            switch response.result {
            
            case .success(let value):
                
                let json = JSON(value)
     
                var writings: [WritingGet] = []
                for (index, json) in json {
                    
                    guard let id = json["id"].int,
                          let title = json["title"].string,
                          let content = json["content"].string,
                          let views = json["views"].int,
                          let likes = json["likes"].int,
                          let hashtags = json["hashtags"].string,
                          let userEmail = json["UserEmail"].string,
                          let userName = json["name"].string
                          else { return
                    }
                    
                    print(id)
                    
                    guard let image = self.image else {return}
                    
                  let writing = WritingGet(id: id, title: title, content: content, views: views, likes: likes, hashtags: hashtags, userEmail: userEmail, userName: userName, image: image)
                    
                      writings.append(writing)
                }
                
                completion(writings)
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension YesterdayPhotoWritingListViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.writings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell") as? PostsCell else {return UITableViewCell()}
        
        let writing = self.writings[indexPath.row]
        
        cell.updateCell(writing: writing)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}
