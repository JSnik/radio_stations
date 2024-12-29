//
//  UIViewController+Management.swift
//  Latvijas Radio
//
//  Created by Sandis Putnis on 13/12/2021.
//

import UIKit

extension UIViewController {
    
    func removeSelfAsPreviousVCFromNavigationController() {
        var navigationArray = self.navigationController?.viewControllers
        navigationArray!.remove(at: (navigationArray?.count)! - 2) // remove previous UIViewController
        self.navigationController?.viewControllers = navigationArray!
    }
    
    @objc func moveToBack(_ sender:UISwipeGestureRecognizer) {
        switch sender.direction{
        case .left:
            navigationController?.popViewController(animated: true)
            break
            //left swipe action
        case .right:
            navigationController?.popViewController(animated: true)
            break
            //right swipe action
        default: //default
            break
        }
    }
}
