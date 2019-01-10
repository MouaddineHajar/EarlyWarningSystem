//
//  ViewController.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/22/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit
import TWMessageBarManager
import SVProgressHUD
import DLRadioButton
import Loki

class SignInController: BaseViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLanguageCode()
        // Do any additional setup after loading the view, typically from a nib.
        setUpTxtFields(txtF: txtEmail, img: UIImage(named: "emailIcon") ?? UIImage())
        setUpTxtFields(txtF: txtPass, img: UIImage(named: "password") ?? UIImage())
    }
    
    func setUpLanguageCode() {
        LKManager.add(LKLanguage(name: "English", code: English))
        LKManager.add(LKLanguage(name: "French", code: French))
    }
    
    func setUpTxtFields(txtF : UITextField , img : UIImage) {
        let image = UIImageView(image: img)
        txtF.leftView = image
    }

    @IBAction func signInBtn(_ sender: UIButton) {
        if !(txtEmail.text?.isEmpty)! && !(txtPass.text?.isEmpty)! {
            SVProgressHUD.show()
            FireBaseServices.shared.signIn(email: self.txtEmail.text!, pass: self.txtPass.text!) {
                (error) in
                if error == nil {
                    let ctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                    self.present(ctrl, animated: true, completion: nil)
                    SVProgressHUD.dismiss()
                    TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Success", comment: ""), description: NSLocalizedString("Loged In Successfully", comment: ""), type: .success, duration: 5)
                } else {
                    SVProgressHUD.dismiss()
                    TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: String(describing: error!.localizedDescription), type: .error, duration: 5)
                }
            }
           
        } else {
            TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Please fill in all required fields", comment: ""), type: .error, duration: 5)
        }
    }
    
    func changeLang() {
        if let flag = UserDefaults.standard.value(forKey: "Language") as? String{
            if flag == "fr" {
                if let item = LKManager.sharedInstance()?.languages[1] as? LKLanguage {
                    LKManager.sharedInstance()?.currentLanguage = item
                }
            }  else {
                if let item = LKManager.sharedInstance()?.languages[0] as? LKLanguage {
                    LKManager.sharedInstance()?.currentLanguage = item
                }
            }
        } else {
            if let item = LKManager.sharedInstance()?.languages[0] as? LKLanguage {
                LKManager.sharedInstance()?.currentLanguage = item
            }
        }
    }
    
    
    
    @IBAction func translationBtn(_ sender: UIButton) {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin * 4.0, height: 160)
        let customView = UIView(frame: rect)
        
        let engBtn = DLRadioButton(type: .custom)
        engBtn.frame = CGRect(x: 20, y: 20, width: customView.frame.size.width - 40, height: 40)
        engBtn.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 0.5)
        engBtn.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        engBtn.setTitle(NSLocalizedString("English", comment: ""), for: .normal)
        engBtn.layer.cornerRadius = 10
        
        let frBtn = DLRadioButton(type: .custom)
        frBtn.frame = CGRect(x: 20, y: 80, width: customView.frame.size.width - 40, height: 40)
        frBtn.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 0.5)
        frBtn.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        frBtn.setTitle(NSLocalizedString("French", comment: ""), for: .normal)
        frBtn.layer.cornerRadius = 10
        
        frBtn.otherButtons = [engBtn]
        engBtn.otherButtons = [frBtn]
        
        if let flag = UserDefaults.standard.value(forKey: "Language") as? String{
            if flag == "fr" {
                frBtn.isSelected = true
            } else {
                engBtn.isSelected = true
            }
        } else {
            engBtn.isSelected = true
        }
        
        customView.addSubview(engBtn)
        customView.addSubview(frBtn)
        
        alertController.view.addSubview(customView)
        
        let somethingAction = UIAlertAction(title: "Save Language", style: .destructive, handler: {(alert: UIAlertAction!) in
            
            if engBtn.isSelected {
                UserDefaults.standard.set("en", forKey: "Language")
            } else {
                UserDefaults.standard.set("fr", forKey: "Language")
            }
            
            self.changeLang()
            let storybaord = UIStoryboard(name: "Main", bundle: nil)
            UIApplication.shared.keyWindow?.rootViewController = storybaord.instantiateInitialViewController()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion:{})
    }
    
   
}

