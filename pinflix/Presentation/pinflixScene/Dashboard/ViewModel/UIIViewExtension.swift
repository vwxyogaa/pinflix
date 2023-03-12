//
//  UIIViewExtension.swift
//  pinflix
//
//  Created by yxgg on 12/03/23.
//

import UIKit

// MARK: - get image
extension UIView {
    func getUIImage(named: String) -> UIImage {
        return UIImage(named: named) ?? UIImage(systemName: "minus.circle.fill")!
    }
}
