//
//  BaseViewController.swift
//  SwiftDemoJsonParsing
//
//  Created by Lucky  on 5/5/17.
//  Copyright © 2017 Lucky . All rights reserved.
//

import UIKit
class BaseViewController: UIViewController {

    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.title = ""
        //self.navigationItem.leftBarButtonItem = nil;
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton;
        setupNavigationWithColor(UIColor.white)
    }
   
    func setupNavigationWithColor(_ color: UIColor) {
        let font = UIFont.boldSystemFont(ofSize: 20);
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font : font as Any]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = color
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
