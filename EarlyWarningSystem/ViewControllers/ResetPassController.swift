//
//  ResetPassController.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/22/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit
import TWMessageBarManager
import SVProgressHUD

class ResetPassController: BaseViewController {

    @IBOutlet weak var txtOldPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func resetBtn(_ sender: UIButton) {
        if !(txtOldPass.text?.isEmpty)! && !(txtNewPass.text?.isEmpty)! {
            SVProgressHUD.show()
            FireBaseServices.shared.updatePassword(newPass: txtNewPass.text!, oldPass: txtOldPass.text!) { (error) in
                if error == nil {
                    TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Success", comment: ""), description: NSLocalizedString("Password updated Successfully", comment: ""), type: .success, duration: 5)
                    SVProgressHUD.dismiss()
                    self.navigationController?.popViewController(animated: true)
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
