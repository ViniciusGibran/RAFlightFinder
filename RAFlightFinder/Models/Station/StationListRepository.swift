import Foundation
import Combine

protocol StationListRepositoryProtocol {
    func getStationList() -> AnyPublisher<[Station]?, APIError>
}

final class StationListRepository: APIRequest, StationListRepositoryProtocol {
    func getStationList() -> AnyPublisher<[Station]?, APIError> {
        return fetchDataFrom(baseURL: BaseURL.stations, endpoint: Endpoints.stations, httpMethod: "GET")
            .decode(type: Station.StationResponse.self, decoder: decoder)
            .map { $0.stations }
            .mapError { error in
                guard let error = error as? APIError
                else { return APIError(.apiError(reason: error.localizedDescription)) }
                return error
            }
            .eraseToAnyPublisher()
    }
}

extension StationListRepository {
    enum Endpoints {
        static let stations = "stations.json"
    }
    
    enum BaseURL {
        static let stations = "https://mobile-testassets-dev.s3.eu-west-1.amazonaws.com/"
    }
}
