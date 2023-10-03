//
//  AppColor+Ext.swift
//  pinflix
//
//  Created by Panji Yoga on 03/10/23.
//

import UIKit

private enum AppColor: String {
    case blackFlix, grayBgFlix, grayFlix, grayTabBarFlix, grayTextFlix, whiteFlix
}

private extension AppColor {
    private func color(named: String) -> UIColor {
        return UIColor.defaultColor(named: named)
    }
    
    private var title: String {
        return self.rawValue
    }
    
    var color: UIColor {
        switch self {
        case .blackFlix:
            return color(named: AppColor.blackFlix.title)
        case .grayBgFlix:
            return color(named: AppColor.grayBgFlix.title)
        case .grayFlix:
            return color(named: AppColor.grayFlix.title)
        case .grayTabBarFlix:
            return color(named: AppColor.grayTabBarFlix.title)
        case .grayTextFlix:
            return color(named: AppColor.grayTextFlix.title)
        case .whiteFlix:
            return color(named: AppColor.whiteFlix.title)
        }
    }
}

let _defaultColors : [String:UIColor] = [
    "blackFlix" : UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1),
    "grayBgFlix" : UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1),
    "grayFlix" : UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1),
    "grayTabBarFlix" : UIColor(red: 95/255, green: 95/255, blue: 95/255, alpha: 1),
    "grayTextFlix" : UIColor(red: 143/255, green: 143/255, blue: 143/255, alpha: 1),
    "whiteFlix" : UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
]

extension UIColor {
    static func defaultColor(named name: String, default defaultColor: UIColor = .black) -> UIColor {
        if #available(iOS 11, *) {
            return UIColor(named: name) ?? defaultColor
        }
        else {
            return _defaultColors[name] ?? defaultColor
        }
    }
    
    public class var blackFlix: UIColor {
        return AppColor.blackFlix.color
    }
    
    public class var grayBgFlix: UIColor {
        return AppColor.grayBgFlix.color
    }
    
    public class var grayFlix: UIColor {
        return AppColor.grayFlix.color
    }
    
    public class var grayTabBarFlix: UIColor {
        return AppColor.grayTabBarFlix.color
    }
    
    public class var grayTextFlix: UIColor {
        return AppColor.grayTextFlix.color
    }
    
    public class var whiteFlix: UIColor {
        return AppColor.whiteFlix.color
    }
}
