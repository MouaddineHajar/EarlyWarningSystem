//
//  PostCollecCell.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/26/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit

class PostCollecCell: UICollectionViewCell {
    
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var commentTxt: UILabel!
    
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        userImgView.layer.borderWidth = 3
        userImgView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        userImgView.layer.cornerRadius = userImgView.frame.size.width / 2
        userImgView.clipsToBounds = true
        postImgView.clipsToBounds = true
    }
    
    func updateCell(userImg : UIImage, postImg : UIImage, userName : String, comment : String) {
       self.userImgView.image = userImg
       self.postImgView.image = postImg
       self.userNameLbl.text = userName
       self.commentTxt.text = comment
    }
    
}
