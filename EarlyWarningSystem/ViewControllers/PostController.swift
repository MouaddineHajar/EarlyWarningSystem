//
//  PostController.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/26/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit
import TWMessageBarManager
import  SVProgressHUD

class PostController: BaseViewController {
    
    let imgPickerCtrl = UIImagePickerController()

    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var postDescib: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePicker()
    }
    
    func setupImagePicker() {
        imgPickerCtrl.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imgPickerCtrl.sourceType = .camera
        } else {
            imgPickerCtrl.sourceType = .photoLibrary
        }
        imgPickerCtrl.allowsEditing = true
    }
 
    @IBAction func uploadPhoto(_ sender: UIButton) {
        self.present(imgPickerCtrl, animated: true, completion: nil)
    }
    
    @IBAction func postBtn(_ sender: UIButton) {
        addPost()
    }
    
    func addPost() {
        if postImgView.image == nil {
            TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Please upload a picture before posting", comment: ""), type: .error)
        } else {
            SVProgressHUD.show()
            FireBaseServices.shared.addPost(img: postImgView.image!, postdesc: postDescib.text) { (error) in
                if error == nil {
                    SVProgressHUD.dismiss()
                    TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Success", comment: ""), description: NSLocalizedString("Post added Successfully!", comment: ""), type: .success)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    SVProgressHUD.dismiss()
                    TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("A problem occured!", comment: ""), type: .error)
                }
            }
        }
    }
}

extension PostController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let fetchedImage = info[.editedImage] as? UIImage
            else {
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Image Not Found", comment: ""), type: .error, duration: 5)
                return
        }
        
        self.postImgView.image = fetchedImage
        self.imgPickerCtrl.dismiss(animated: true, completion: nil)
    }
    
}
