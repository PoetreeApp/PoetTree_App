//
//  YesterDayMainViewController.swift
//  PoetTree_App
//
//  Created by κΉλν on 2021/04/01.
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
      
        MyAlamofireManager.shared.getWritings { result in
            
            switch result {
            case .success(let writings):
                self.writings = writings
                print(self.writings)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let myError):
                print(myError.rawValue)
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
