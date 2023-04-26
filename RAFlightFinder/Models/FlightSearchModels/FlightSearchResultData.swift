import UIKit

struct FlightSearchResultData {
    let departureTime: String
    let arrivalTime: String
    let flightCode: String
    let flightDuration: String
    let departureFrom: String
    let arrivalDestination: String
    let fareValue: Double
    let currency: String
    
    private var currencySymbol: String {
        currencySymbol(for: currency)
    }
    
    var formattedDepartureTime: String? {
        formatFlightTime(dateString: departureTime)
    }
    
    var formattedArrivalTime: String? {
        formatFlightTime(dateString: arrivalTime)
    }
    
    var formattedFareValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: NSNumber(value: fareValue)) ?? "\(currency) \(fareValue)"
    }
    
    private func formatFlightTime(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    var formattedFlightDuration: String {
        let components = flightDuration.split(separator: ":")
        if components.count == 2,
           let hours = Int(components[0]),
           let minutes = Int(components[1]) {
            return "\(hours) hr \(minutes) min"
        } else {
            return flightDuration
        }
    }
    
    private func currencySymbol(for currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter.currencySymbol
    }
}
