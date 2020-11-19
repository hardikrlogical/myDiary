//
//  UIViewController.swift
//  DemoTestTask
//
//  Created by rlogical-dev-35 on 18/11/20.
//  Copyright © 2020 rlogical-dev-35. All rights reserved.
//

import UIKit
import Foundation
//import SideMenu

enum NavigationType: Int { case clearNavigationType = 0, whiteNavigation = 1}
enum LeftButtonType: Int { case none = 0, newback = 1}

extension UIViewController {
    
    func setNavigationBar(_ typeNavigation: NavigationType, Menu isMenu: LeftButtonType) {
        

        if typeNavigation == NavigationType.clearNavigationType {
            self.navigationController!.navigationBar.isTranslucent = true
          //  self.navigationController!.navigationBar.barStyle = UIBarStyle.default
            
            self.navigationController!.navigationBar.barTintColor = UIColor.white
            self.navigationController!.navigationBar.tintColor = UIColor.white
            self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController!.navigationBar.shadowImage = UIImage()
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            self.navigationController!.navigationBar.isTranslucent = false
           // self.navigationController!.navigationBar.barStyle = UIBarStyle.default
            self.navigationController!.navigationBar.barTintColor = UIColor.white
            self.navigationController!.navigationBar.tintColor = UIColor.white
            self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController!.navigationBar.shadowImage = nil
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        
        switch isMenu {
        case .none: //add nothing
            self.navigationItem.setHidesBackButton(true, animated: true)
            break
        case .newback: //add back button
            self.navigationItem.setHidesBackButton(true, animated: true)
            let backButton = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnBackTap(_:)))
            self.navigationItem.setLeftBarButton(backButton, animated: true)

        }
    }
    
  
    
   
    /**
     Used to fetch last controller from stack
     
     - returns: last controller
     */
    func lastViewController() -> UIViewController {
        let arrayViewControllers: NSArray = self.navigationController!.viewControllers as NSArray
        if let lastVC = arrayViewControllers[arrayViewControllers.count - 2] as? UIViewController {
            return lastVC
        } else {
            return UIViewController()
        }
    }
    
    /**
     Delete all view in navigation and get back to login
     */
    func deleteAllViewFromsStack() {
        guard let navigationControl = self.navigationController else {
            return
        }
        let array = navigationControl.viewControllers as NSArray
        if array.count > 0 {
            for controller in array {
                if let control = controller as? UIViewController {
                    _ = self.navigationController?.popToViewController(control, animated: false)
                }
            }
        }
    }
    
    @IBAction func btnBackTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
