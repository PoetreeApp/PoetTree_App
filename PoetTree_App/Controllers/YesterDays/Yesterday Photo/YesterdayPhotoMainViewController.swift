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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var images: [Image] = []
    var uiImages: [UIImage] = []
    var selectedPhotoIndex: Int = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        pagerView.dataSource = self
        pagerView.delegate = self
        setUI()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //소스아이디를 넘겨줌
        
        if segue.identifier == "toPhotoWriting" {
            
            guard let vc = segue.destination as? YesterdayPhotoWritingListViewController else {return}
            
            //선택한 셀의 아이템 번호를 받아옴
            
            guard let index = sender as? Int else {return}
            
            print(self.uiImages[index])
            
            vc.image = self.uiImages[index]
            vc.sourceId = self.images[index].id
            
        }
    }
    
    fileprivate func setUI(){
        
        getPhoto { images in
            
            let filteredImages: [UIImage] = images.map{ image in
                
                let url = image.imageURL
                let data = try! Data(contentsOf: URL(string: url)!)
                let image = UIImage(data: data)
                return image!
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.images = images
                self.uiImages = filteredImages
                self.dateLabel.text = self.images[0].uploadDate
                self.pagerView.reloadData()
                self.collectionView.reloadData()
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
    
    @IBAction func leftBtnTapped(_ sender: UIButton) {
        
        if self.selectedPhotoIndex == 0 {
            return
        }
        
        self.selectedPhotoIndex -= 1
        self.dateLabel.text = self.images[self.selectedPhotoIndex].uploadDate
        self.pagerView.scrollToItem(at: selectedPhotoIndex, animated: true)
    }
    
    @IBAction func rightBtnTapped(_ sender: UIButton) {
        
        
        if(self.selectedPhotoIndex == self.uiImages.count - 1){
            self.selectedPhotoIndex = 0
        } else {
            self.selectedPhotoIndex = self.selectedPhotoIndex + 1
        }
        
        self.dateLabel.text = self.images[self.selectedPhotoIndex].uploadDate
        
        self.pagerView.scrollToItem(at: selectedPhotoIndex, animated: true)
    }
    
}

extension YesterdayPhotoMainViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
      
        return self.uiImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = self.uiImages[index]
        cell.imageView?.contentMode = .scaleAspectFit
     
        return cell
    }
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
      
        let date = self.images[targetIndex].uploadDate
        self.dateLabel.text = date
        
        selectedPhotoIndex = targetIndex
       
        
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        
    }
    
}

extension YesterdayPhotoMainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? YesterDayPhotoCollectionViewCell else {return UICollectionViewCell()}
        
        let image = self.uiImages[indexPath.item]
        
        cell.updateUI(image: image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 110, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        performSegue(withIdentifier: "toPhotoWriting", sender: indexPath.item)
        
    }
    
}

class YesterDayPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.layer.cornerRadius = 3
    }
    
    func updateUI(image: UIImage){
        photoImageView.image = image
    }
}
