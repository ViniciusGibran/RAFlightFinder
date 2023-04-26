import UIKit
import Combine
@testable import RAFlightFinder

final class FlightSearchRepositoryMock: FlightSearchRepositoryProtocol {
    
    func getFlightFinderSearch(_ params: FlightSearchParams) -> AnyPublisher<[FlightSearchResultData]?, APIError> {
        let mockData: [FlightSearchResultData] = MOCK_DATA.mockFlightSearchResultData
        return Result<[FlightSearchResultData]?, APIError>.Publisher(.success(mockData))
            .eraseToAnyPublisher()
    }
}

extension FlightSearchRepositoryMock {
    enum MOCK_DATA {
        static let mockFlightSearchResultData = [
            FlightSearchResultData(
                departureTime: "08:30",
                arrivalTime: "11:15",
                flightCode: "FR1234",
                flightDuration: "2h 45m",
                departureFrom: "OPO",
                arrivalDestination: "BCN",
                fareValue: 45.0,
                currency: "EUR"
            ),
            FlightSearchResultData(
                departureTime: "12:00",
                arrivalTime: "14:40",
                flightCode: "FR2345",
                flightDuration: "2h 40m",
                departureFrom: "OPO",
                arrivalDestination: "BCN",
                fareValue: 60.0,
                currency: "EUR"
            ),
            FlightSearchResultData(
                departureTime: "18:30",
                arrivalTime: "21:10",
                flightCode: "FR3456",
                flightDuration: "2h 40m",
                departureFrom: "OPO",
                arrivalDestination: "BCN",
                fareValue: 55.0,
                currency: "EUR"
            )
        ]
        
        static let mockFlightSearchParams = FlightSearchParams(
            origin: "AAA",
            destination: "BBB",
            dateOut: Date(),
            dateIn: Date(),
            adult: 1,
            teen: 0,
            child: 0,
            infant: 0
        )
    }
}
