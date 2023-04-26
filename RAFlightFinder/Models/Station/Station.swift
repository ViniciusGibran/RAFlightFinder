import UIKit

struct Station: Codable {
    let code: String
    let name: String
    let alternateName: String?
    let alias: [String]
    let countryCode: String
    let countryName: String
    let countryAlias: String?
    let countryGroupCode: String
    let countryGroupName: String
    let timeZoneCode: String
    let latitude: String
    let longitude: String
    let mobileBoardingPass: Bool
    let markets: [Market]
    let notices: String?
    let tripCardImageUrl: String?
    
    struct Market: Codable {
        let code: String
        let group: String?
    }
    
    struct StationResponse: Codable {
        let stations: [Station]
    }
}
