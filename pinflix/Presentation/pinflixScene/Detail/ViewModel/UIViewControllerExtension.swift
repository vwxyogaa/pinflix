//
//  UIViewControllerExtension.swift
//  pinflix
//
//  Created by Panji Yoga on 13/03/23.
//

import UIKit

// MARK: - Manage Loading View
extension UIViewController {
    func manageLoadingActivity(isLoading: Bool) {
        if isLoading {
            showLoadingActivity()
        } else {
            hideLoadingActivity()
        }
    }
    
    func showLoadingActivity() {
        self.view.makeToastActivity(.center)
    }
    
    func hideLoadingActivity() {
        self.view.hideToastActivity()
    }
}
