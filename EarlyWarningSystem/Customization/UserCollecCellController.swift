//
//  CollectionCellController.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/23/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit
import TWMessageBarManager

class UserCollecCellController: UICollectionViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var NamelBL: UILabel!
    
    var userID : String?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        frame.size.height = 119
        imgView.layer.borderWidth = 3
        imgView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imgView.layer.cornerRadius = imgView.frame.size.width / 2
        imgView.clipsToBounds = true
    }
    
    func updateCell(img : UIImage?, name : String, id : String) {
        imgView.image = img ?? UIImage()
        NamelBL.text = name
        userID = id
    }
    
    @IBAction func addFriend(_ sender: UIButton) {
        guard let id = userID
            else {
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Error retreiving user's ID", comment: ""), type: .error, duration: 5)
                return
        }
        FireBaseServices.shared.addFriend(friendId: id) { (error) in
            if error == nil {
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Success", comment: ""), description: NSLocalizedString("The user has been added to your friend list successfully", comment: ""), type: .success, duration: 5)
            } else {
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("User couldn't be added to you friend list", comment: ""), type: .error, duration: 5)
            }
        }
    }
    
    
}
