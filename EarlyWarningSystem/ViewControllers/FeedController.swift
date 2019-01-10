//
//  FeedController.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/26/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit
import TWMessageBarManager
import SVProgressHUD

class FeedController: BaseViewController {

    @IBOutlet weak var feedCollecView: UICollectionView!
    
    var data = [[String:Any]]()
    var refresher : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(getPosts), for: .valueChanged)
        
        feedCollecView.delegate = self
        feedCollecView.dataSource = self
        feedCollecView.addSubview(refresher)
        
        SVProgressHUD.show()
        getPosts()
        
    }
    
    @objc func getPosts() {
        
        FireBaseServices.shared.getPosts { (posts) in
            if posts != nil {
                self.data = posts!
                self.feedCollecView.reloadData()
                SVProgressHUD.dismiss()
                self.refresher.endRefreshing()
            } else {
                SVProgressHUD.dismiss()
                self.refresher.endRefreshing()
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Couldn't retreive Posts", comment: ""), type: .error, duration: 5)
            }
        }
        
    }
 
}

extension FeedController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PostCollecCell
        let user = data[indexPath.row]["user"] as! UserModel?
        let postImg = data[indexPath.row]["postImg"] as! UIImage?
        let comment = data[indexPath.row]["comment"] as! String
        var userImg : UIImage?
        var userName : String?
        if user != nil {
            userImg = user!.image!
            userName = "\(user!.fname) \(user!.lname)"
            cell.updateCell(userImg: userImg!, postImg: postImg ?? UIImage(), userName: userName!, comment: comment)
        }
        
        return cell
    }
    
    
}
