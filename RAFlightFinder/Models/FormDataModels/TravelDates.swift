import UIKit

struct TravelDates {
    var flyOutDate: Date?
    var flyBackDate: Date?
    
    func formattedDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM"
        
        if let flyOutDate = flyOutDate, let flyBackDate = flyBackDate {
            let formattedFlyOutDate = dateFormatter.string(from: flyOutDate)
            let formattedFlyBackDate = dateFormatter.string(from: flyBackDate)
            return "\(formattedFlyOutDate) - \(formattedFlyBackDate)"
            
        } else if let flyOutDate = flyOutDate {
            let formattedFlyOutDate = dateFormatter.string(from: flyOutDate)
            return "\(formattedFlyOutDate)"
        }
        
        return ""
    }
}
