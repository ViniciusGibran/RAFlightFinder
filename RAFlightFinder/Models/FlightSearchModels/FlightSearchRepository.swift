import Combine
import Foundation

protocol FlightSearchRepositoryProtocol {
    func getFlightFinderSearch(_ params: FlightSearchParams) -> AnyPublisher<[FlightSearchResultData]?, APIError>
}

final class FlightSearchRepository: APIRequest, FlightSearchRepositoryProtocol {
    func getFlightFinderSearch(_ params: FlightSearchParams) -> AnyPublisher<[FlightSearchResultData]?, APIError> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let queryParams: [String: String] = [
            "origin": params.origin,
            "destination": params.destination,
            "dateout": dateFormatter.string(from: params.dateOut),
            "datein": dateFormatter.string(from: params.dateIn),
            "flexdaysbeforeout": "3",
            "flexdaysout": "3",
            "flexdaysbeforein": "3",
            "flexdaysin": "3",
            "adt": "\(params.adult)",
            "teen": "\(params.teen)",
            "chd": "\(params.child)",
            "inf": "\(params.infant)",
            "roundtrip": "true",
            "ToUs": "AGREED",
            "Disc": "0"
        ]

        let urlString = BaseURL.baseApi + Enpoints.availability + queryParams.queryString()
        
        return fetchDataFrom(baseURL: urlString, endpoint: "", httpMethod: "GET")
            .decode(type: FlightSearchResponse.self, decoder: decoder)
            .map {
                self.mapToFlightSearchResultData($0)
            }
            .mapError { error in
                guard let error = error as? APIError else { return APIError(.unknown) }
                return error
            }
            .eraseToAnyPublisher()
    }
    
    private func mapToFlightSearchResultData(_ response: FlightSearchResponse) -> [FlightSearchResultData] {        
        return response.trips.flatMap { trip in
            trip.dates.flatMap { flightDate in
                flightDate.flights.compactMap { flight in
                    if let regularFare = flight.regularFare {
                        let fareDetail = regularFare.fares.first
                        return FlightSearchResultData(
                            departureTime: flight.time.first ?? "",
                            arrivalTime: flight.time.last ?? "",
                            flightCode: flight.flightNumber,
                            flightDuration: flight.duration,
                            departureFrom: trip.origin,
                            arrivalDestination: trip.destination,
                            fareValue: fareDetail?.amount ?? 0,
                            currency: response.currency
                        )
                    }
                    return nil
                }
            }
        }
    }
}

extension Dictionary where Key == String, Value == String {
    func queryString() -> String {
        var components = URLComponents()
        components.queryItems = self.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.url?.query ?? ""
    }
}

extension FlightSearchRepository {
    enum Enpoints {
        static let availability = "api/v4/en-IE/Availability?"
    }
    
    enum BaseURL {
        static let baseApi = "https://nativeapps.ryanair.com/"
    }
}
