//
//  EditProfileController.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/22/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit
import TWMessageBarManager
import SVProgressHUD

class EditProfileController: BaseViewController {
    
    let imgPickerCtrl = UIImagePickerController()

    @IBOutlet weak var imgContainerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Mark-SetUp UI
        setUpProfileImgView()
        setupImagePicker()
        //Mark-GetUserData
        SVProgressHUD.show()
        getUserImg()
        getUserInfo()
        SVProgressHUD.dismiss()
    }
    
    func setUpProfileImgView() {
        imgContainerView.layer.borderWidth = 5
        imgContainerView.layer.borderColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        imgContainerView.layer.cornerRadius = imgContainerView.frame.size.width / 2
        imgContainerView.clipsToBounds = true
        imgView.layer.cornerRadius = imgView.frame.size.width / 2
        imgView.clipsToBounds = true
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
    
    func getUserImg() {
        FireBaseServices.shared.getUserImg { (data, error) in
            if error == nil {
                self.imgView.image = UIImage(data: data!)
            } else {
                SVProgressHUD.dismiss()
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Reminder", comment: ""), description: NSLocalizedString("Your profile picture is not set yet or couldn't be found", comment: ""), type: .info, duration: 5)
            }
        }
    }
    
    func getUserInfo() {
        FireBaseServices.shared.getUser { (user) in
            if user == nil {
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Couldn't retreive user information", comment: ""), type: .error, duration: 5)
            } else {
                self.txtFname.text = user!.fname
                self.txtLname.text = user!.lname
                self.txtEmail.text = user!.email
                self.txtEmail.isEnabled = false
                self.txtAddress.text = user!.address
                self.txtPhone.text = user!.phone
            }
        }
    }
    
    @IBAction func editImg(_ sender: UIButton) {
        self.present(imgPickerCtrl, animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        if !(txtFname.text?.isEmpty)! && !(txtLname.text?.isEmpty)! && !(txtAddress.text?.isEmpty)! && !(txtPhone.text?.isEmpty)! {
            SVProgressHUD.show()
            let user = UserModel(userID: nil, fname: txtFname.text!, lname: txtLname.text!, email: txtEmail.text!, address: txtAddress.text!, phone: txtPhone.text!, password: nil, image: nil, latitude: nil, longitude: nil)
            FireBaseServices.shared.updateData(use: user) { (error) in
                if error == nil {
                    SVProgressHUD.dismiss()
                    TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Success", comment: ""), description: NSLocalizedString("Profile information Updated successfully", comment: ""), type: .success, duration: 5)
                } else {
                    SVProgressHUD.dismiss()
                    TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: String(describing: error!.localizedDescription), type: .error, duration: 5)
                }
            }
        } else {
            TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Please fill in all required fields", comment: ""), type: .error, duration: 5)
        }
        
    }
    
}

extension EditProfileController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let fetchedImage = info[.editedImage] as? UIImage
            else {
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Image Not Found", comment: ""), type: .error, duration: 5)
                return
        }
        SVProgressHUD.show()
        FireBaseServices.shared.saveUserImg(img: fetchedImage) { (error) in
            if error == nil {
                SVProgressHUD.dismiss()
                self.imgView.image = fetchedImage
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Success", comment: ""), description: NSLocalizedString("Image Updated Successfully", comment: ""), type: .success, duration: 5)
            } else {
                SVProgressHUD.dismiss()
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: String(describing: error!.localizedDescription), type: .error, duration: 5)
            }
        }
        self.imgPickerCtrl.dismiss(animated: true, completion: nil)
    }
    
}
