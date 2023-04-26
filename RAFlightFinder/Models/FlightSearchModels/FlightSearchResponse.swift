import UIKit

struct FlightSearchResponse: Codable {
    let currency: String
    let serverTimeUTC: String
    let currPrecision: Int
    let trips: [Trip]
    
    struct Trip: Codable {
        let origin: String
        let destination: String
        let dates: [FlightDate]
        
    }
    
    struct FlightDate: Codable {
        let dateOut: String
        let flights: [Flight]
    }
    
    struct Flight: Codable {
        let time: [String]
        let regularFare: Fare?
        let faresLeft: Int
        let timeUTC: [String]
        let duration: String
        let flightNumber: String
        let infantsLeft: Int
        let flightKey: String
        let businessFare: Fare?
    }
    
    struct Fare: Codable {
        let fareKey: String
        let fareClass: String
        let fares: [FareDetail]
    }
    
    struct FareDetail: Codable {
        let amount: Double
        let count: Int
        let type: String
        let hasDiscount: Bool
        let publishedFare: Double
    }
}
