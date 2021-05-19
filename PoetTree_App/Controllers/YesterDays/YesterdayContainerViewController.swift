//
//  YesterdayContainerViewController.swift
//  PoetTree_App
//
//  Created by 김동환 on 2021/05/19.
//

import UIKit
import Parchment

class YesterdayContainerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let vc1 = storyboard.instantiateViewController(identifier: "PhotoCollection")
        let vc2 = storyboard.instantiateViewController(identifier: "WritingList")
        
        let pagingViewController = PagingViewController(viewControllers: [
            vc1,
            vc2,
        ])

        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
          pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        
    }
    
}
