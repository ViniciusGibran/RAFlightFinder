import UIKit
@testable import RAFlightFinder

extension Station {
    static func makeMock(code: String = "DUB",
                         name: String = "Dublin Airport",
                         countryCode: String = "IE",
                         countryName: String = "Ireland") -> Station {
        return Station(code: code,
                       name: name,
                       alternateName: nil,
                       alias: [],
                       countryCode: countryCode,
                       countryName: "Ireland",
                       countryAlias: nil,
                       countryGroupCode: "EU",
                       countryGroupName: "European Union",
                       timeZoneCode: "Europe/Dublin",
                       latitude: "53.42728",
                       longitude: "-6.24411",
                       mobileBoardingPass: true,
                       markets: [],
                       notices: nil,
                       tripCardImageUrl: nil)
    }
}
