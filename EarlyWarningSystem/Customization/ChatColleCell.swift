//
//  ChatColleCell.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/27/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit

class ChatColleCell: UICollectionViewCell {
    
    
    @IBOutlet weak var receivedMessView: UIView!
    @IBOutlet weak var receivedMessLbl: UILabel!
    
    @IBOutlet weak var SentMessView: UIView!
    @IBOutlet weak var sentMessLbl: UILabel!
    
    var isSent : Bool?
    var message : String?
    var timestamp : String?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        receivedMessView.isHidden = true
        SentMessView.isHidden = true
      
    }
    
    func prepareCell(sent : Bool, mess : String, time: String) {
        receivedMessView.isHidden = true
        SentMessView.isHidden = true
        self.isSent = sent
        self.message = mess
        self.timestamp = time
        showBubble()
    }
    
    func showBubble() {
        if isSent! {
            SentMessView.isHidden = false
            sentMessLbl.text = self.message!
        } else {
            receivedMessView.isHidden = false
            receivedMessLbl.text = self.message!
        }
    }
    
}
