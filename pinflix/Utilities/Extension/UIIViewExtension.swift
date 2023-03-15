//
//  UIIViewExtension.swift
//  pinflix
//
//  Created by Panji Yoga on 15/03/23.
//

import UIKit

// MARK: - Get Image
extension UIView {
    func getUIImage(named: String) -> UIImage {
        return UIImage(named: named) ?? UIImage(systemName: "minus.circle.fill")!
    }
}
