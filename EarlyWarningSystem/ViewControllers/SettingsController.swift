//
//  SettingsController.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/22/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit
import TWMessageBarManager
import SVProgressHUD
import Crashlytics

class SettingsController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOutBtn(_ sender: UIButton) {
        SVProgressHUD.show()
        FireBaseServices.shared.logOut { (error) in
            if error == nil {
                let ctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInController") as! SignInController
                SVProgressHUD.dismiss()
                UIApplication.shared.keyWindow?.rootViewController = ctrl
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Success", comment: ""), description: NSLocalizedString("You have been logged out Successfully", comment: ""), type: .success, duration: 5)
            } else {
                SVProgressHUD.dismiss()
                TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: String(describing: error!.localizedDescription), type: .success, duration: 5)
            }
        }
    }
    
}
