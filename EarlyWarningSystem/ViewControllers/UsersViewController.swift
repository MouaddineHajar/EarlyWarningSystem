//
//  UsersViewController.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/23/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit
import TWMessageBarManager
import SVProgressHUD

class UsersViewController: BaseViewController {

    @IBOutlet weak var usersCV: UICollectionView!
    var data = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usersCV.delegate = self
        usersCV.dataSource = self
        getUsers()
    }
    
    func getUsers() {
        SVProgressHUD.show()
        FireBaseServices.shared.getUsers { (usersArr) in
            guard let users = usersArr
                else {
                    SVProgressHUD.dismiss()
                    TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Coundn't retrieve Users Information", comment: ""), type: .error, duration : 5)
                    return
            }
            
            self.data = users
            SVProgressHUD.dismiss()
            if self.data.count == 0 {
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Info", comment: ""), description: NSLocalizedString("No user Found", comment: ""), type: .info, duration: 5)
            } else {
                self.usersCV.reloadData()
            }
        }
    }

}

extension UsersViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserCollecCellController
        cell.updateCell(img: data[indexPath.row].image, name: "\(data[indexPath.row].fname) \(data[indexPath.row].lname)", id : data[indexPath.row].userID!)
        return cell
    }
    
    
}
