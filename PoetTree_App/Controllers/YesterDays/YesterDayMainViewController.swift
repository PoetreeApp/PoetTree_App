//
//  YesterDayMainViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/04/01.
//

import UIKit
import Alamofire
import SwiftyJSON


class YesterDayMainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var writings: [WritingGet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("yesterday viewdidload called")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        writings.removeAll()
        getWritings()
        tableView.reloadData()
    }
    
    func getWritings(){
        AF.request(K.API.WRITING_GET_POST, method: .get).responseJSON { [weak self] response in
            
            guard let self = self else {return}
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                for (index, json) in json {
                    if let title = json["title"].string,
                       let content = json["content"].string,
                       let views = json["views"].int,
                       let likes = json["likes"].int,
                       let hashtags = json["hashtags"].string,
                       let id = json["id"].int,
                       let email = json["UserEmail"].string,
                       let userName = json["name"].string,
                       let imageURL = json["imageURL"].string
                    {
                        
                        let data = try! Data(contentsOf: URL(string: imageURL)!)
                        print(data)
                        let image = UIImage(data: data)
                        
                        //리팩토링 필요한 부분
                        
                        self.writings.append(WritingGet(id: id, title: title, content: content, views: views, likes: likes, hashtags: hashtags, userEmail: email, userName: userName, image: image!))
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension YesterDayMainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        performSegue(withIdentifier: K.SEGUE_ID.toYesterdayWriting, sender: writings[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let writingVC = segue.destination as? YesterdaysWriting,
              let writing = sender as? WritingGet else {return}
            writingVC.writing = writing
    }
}

extension YesterDayMainViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return writings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.TABLE_VIEW_CELL_ID.postsCell) as? PostsCell else {
            return UITableViewCell()
        }
        cell.updateCell(writing: writings[indexPath.row])
        return cell
    }
}
