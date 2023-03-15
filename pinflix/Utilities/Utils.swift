//
//  Utils.swift
//  pinflix
//
//  Created by Panji Yoga on 15/03/23.
//

import Foundation

class Utils: NSObject {
    static func humanDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let tgl = dateFormatter.date(from: date) {
            dateFormatter.locale = Locale(identifier: "id_ID")
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            return dateFormatter.string(from: tgl)
        }
        return date
    }
    
    static func dateValidUntil(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        if let tgl = dateFormatter.date(from: date) {
            dateFormatter.locale = Locale(identifier: "id_ID")
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            return dateFormatter.string(from: tgl)
        }
        return date
    }
    
    static func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
}
