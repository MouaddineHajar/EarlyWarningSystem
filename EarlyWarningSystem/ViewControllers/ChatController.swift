//
//  ChatController.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/27/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit
import TWMessageBarManager
import SVProgressHUD

class ChatController: BaseViewController , UITextViewDelegate {

    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var friendNameLbl: UILabel!
    @IBOutlet weak var friendImg: UIImageView!
    @IBOutlet weak var messageTxt: UITextView!
    @IBOutlet weak var convoCollecView: UICollectionView!
    
    var receiverID : String?
    var image : UIImage?
    var name : String?
    var data = [Conversation]()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        convoCollecView.delegate = self
        convoCollecView.dataSource = self
        
        messageTxt.delegate = self
        
        sendBtn.isEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(setUpChat), userInfo: nil, repeats: true)
        
        setUpImgView()
        setUpScreen()
        SVProgressHUD.show()
        setUpChat()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        if !(messageTxt.text.isEmpty) {
            sendBtn.isEnabled = true
        } else {
            sendBtn.isEnabled = false
            messageTxt.resignFirstResponder()
        }
    }
    
    @objc func setUpChat() {
       
        FireBaseServices.shared.getConvo(friendID: receiverID!) { (conversations) in
            if conversations != nil {
                self.data = conversations!.sorted(by: {$0.time < $1.time} )
                self.convoCollecView.reloadData()
                
                self.convoCollecView.scrollToItem(at: IndexPath(row: self.data.endIndex-1, section: 0) , at: .centeredVertically, animated: true)
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func setUpImgView() {
        friendImg.layer.borderWidth = 3
        friendImg.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        friendImg.layer.cornerRadius = friendImg.frame.size.width / 2
        friendImg.clipsToBounds = true
    }
    
    func setUpScreen() {
        friendImg.image = image
        friendNameLbl.text = name
    }
    
    func prepareScreen(image : UIImage?, friendname : String?, friendID : String) {
        self.image = image ?? UIImage()
        self.name = friendname ?? ""
        receiverID = friendID
    }
 
    @IBAction func dismissChat(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendTextBtn(_ sender: UIButton) {
        FireBaseServices.shared.sendText(message: messageTxt.text, friendID: receiverID!) { (error) in
            if error == nil {
                //add to data and reload view
                let convo = Conversation(message: self.messageTxt.text, receiverID: self.receiverID!, time: "\(Int(NSDate().timeIntervalSince1970))")
                self.data.append(convo)
                self.convoCollecView.reloadData()
                self.messageTxt.text = ""
                self.convoCollecView.scrollToItem(at: IndexPath(row: self.data.endIndex-1, section: 0) , at: .centeredVertically, animated: true)
            } else {
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Message couldn't be sent!", comment: ""), type: .error, duration: 5)
            }
        }
    }
}

extension ChatController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChatColleCell
        if receiverID! == data[indexPath.row].receiverID {
            cell.prepareCell(sent: true, mess: data[indexPath.row].message, time: data[indexPath.row].time)
        } else {
            cell.prepareCell(sent: false, mess: data[indexPath.row].message, time: data[indexPath.row].time)
        }
        return cell
    }
    
}

extension ChatController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let aproximateWitdhOfText = convoCollecView.frame.width - 124
        let size = CGSize(width: aproximateWitdhOfText, height: 2000)
        let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize : 17)]
        let estimatedFrame = String(data[indexPath.row].message).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return CGSize(width: convoCollecView.frame.size.width, height: estimatedFrame.height
        + 25)
    }
}

