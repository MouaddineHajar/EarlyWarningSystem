//
//  FriendCollecCell.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/25/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit
import TWMessageBarManager
import SVProgressHUD


@objc protocol FriendDelegate {
    @objc optional func removeFriend(index : Int)
    @objc optional func presentView(ctrl : UIViewController)
}

class FriendCollecCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var NamelbL: UILabel!
    
    var userID : String?
    var index : Int?
    var delegate : FriendDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.borderWidth = 3
        imgView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imgView.layer.cornerRadius = imgView.frame.size.width / 2
        imgView.clipsToBounds = true
    }
    
    func updateCell(img : UIImage?, name : String, id : String, index : Int) {
        imgView.image = img ?? UIImage()
        NamelbL.text = name
        userID = id
        self.index = index
    }
    
    @IBAction func removeFriend(_ sender: UIButton) {
        guard let id = userID
            else {
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Error retreiving user's ID", comment: ""), type: .error, duration: 5)
                return
        }
        FireBaseServices.shared.removeFriend(friendId: id) { (error) in
            if error == nil {
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Success", comment: ""), description: NSLocalizedString("The user has been removed successfully", comment: ""), type: .success, duration: 5)
                guard let row = self.index else {return}
                self.delegate?.removeFriend!(index : row)
            } else {
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("User couldn't be removed from your friend list", comment: ""), type: .error, duration: 5)
            }
        }
    }
    
    @IBAction func chatBtn(_ sender: UIButton) {
        guard let id = userID
            else {
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Error retreiving user's ID", comment: ""), type: .error, duration: 5)
                return
        }
        let ctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatController") as! ChatController
        ctrl.prepareScreen(image: imgView.image, friendname: NamelbL.text, friendID: id)
        delegate?.presentView!(ctrl: ctrl)
    }
}
