//
//  YesterdayPhotoMainViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/19.
//

import UIKit
import Alamofire
import SwiftyJSON
import FSPagerView

class YesterdayPhotoMainViewController: UIViewController {
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet{
            
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            
            self.pagerView.itemSize = FSPagerView.automaticSize
            
            self.pagerView.isInfinite = true
            
            self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
        }
    }
    
    
    
    var images: [Image] = []
    var uiImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pagerView.dataSource = self
        pagerView.delegate = self
        setUI()
        
    }
    
    fileprivate func setUI(){
        getPhoto { images in
            let url = images[0].imageURL
            let data = try! Data(contentsOf: URL(string: url)!)
            let image = UIImage(data: data)
            
            let filteredImages: [UIImage] = images.map{ image in
                
                let url = image.imageURL
                let data = try! Data(contentsOf: URL(string: url)!)
                let image = UIImage(data: data)
                print("filtered images done")
                return image!
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.images = images
                self.uiImages = filteredImages
                print("dispatch que done\(self.uiImages)")
                self.pagerView.reloadData()
            }
        }
    }
    
    
    fileprivate func getPhoto(completion: @escaping (([Image]) -> Void) ){
        
        AF.request(K.API.PAST_IMAGES, method: .get).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                var historis: [Image] = []
                
                for (index, json) in json {
                    guard let id = json["id"].int,
                          let imageURL = json["imageURL"].string,
                          let uploadDate = json["uploadDate"].string else {return}
                    let image = Image(id: id, imageURL: imageURL, uploadDate: uploadDate)
                    historis.append(image)
                }
                
                completion(historis)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}

extension YesterdayPhotoMainViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        print("number of items called")
        return self.uiImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = self.uiImages[index]
        cell.imageView?.contentMode = .scaleAspectFit
        print("cell called")
        return cell
    }
    
}
