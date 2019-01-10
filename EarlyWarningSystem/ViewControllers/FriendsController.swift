//
//  FriendsController.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/24/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit
import TWMessageBarManager
import SVProgressHUD

class FriendsController: BaseViewController, FriendDelegate {
    
    @IBOutlet weak var friendsCollecView: UICollectionView!
    var data = [UserModel]()
    var locations = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsCollecView.delegate = self
        friendsCollecView.dataSource = self
        getFriends()
    }
    
    func removeFriend(index: Int) {
        data.remove(at: index)
        friendsCollecView.reloadData()
    }
    
    func presentView(ctrl: UIViewController) {
        self.present(ctrl, animated: true, completion: nil)
    }
   
    func getFriends() {
        SVProgressHUD.show()
        FireBaseServices.shared.getFriends { (usersArr) in
            guard let users = usersArr
                else {
                    SVProgressHUD.dismiss()
                    TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Coundn't retrieve Friends Information", comment: ""), type: .error, duration : 5)
                    return
            }
            
            self.data = users
            SVProgressHUD.dismiss()
            if self.data.count == 0 {
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Info", comment: ""), description: NSLocalizedString("No Friend Found", comment: ""), type: .info, duration: 5)
            } else {
                self.friendsCollecView.reloadData()
            }
        }
    }
    
    @IBAction func reloadData(_ sender: UIButton) {
        getFriends()
    }
    
    @IBAction func mapBtn(_ sender: UIButton) {
        let ctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MAPController") as! MAPController
        ctrl.locations = locations
        navigationController?.pushViewController(ctrl, animated: true)
    }
    
}

extension FriendsController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FriendCollecCell
        cell.delegate = self
        cell.updateCell(img: data[indexPath.row].image, name: "\(data[indexPath.row].fname) \(data[indexPath.row].lname)", id : data[indexPath.row].userID!, index : indexPath.row)
        locations.append(["latitude" : data[indexPath.row].latitude!, "longitude" : data[indexPath.row].longitude! , "icon" : data[indexPath.row].image!])
        return cell
    }
    
}
