import Combine
import UIKit
@testable import RAFlightFinder

final class StationListRepositoryMock: StationListRepositoryProtocol {
    func getStationList() -> AnyPublisher<[Station]?, APIError> {
        let mockData: [Station] = MOCK_DATA.mockStationListResultData
        return Result<[Station]?, APIError>.Publisher(.success(mockData))
            .eraseToAnyPublisher()
    }
}

extension StationListRepositoryMock {
    enum MOCK_DATA {
        static let mockStationListResultData = [
            Station.makeMock(
                code: "AAA",
                name: "Test Airport A",
                countryName: "Test Country A"
            ),
            Station.makeMock(
                code: "BBB",
                name: "Test Airport B",
                countryName: "Test Country B"
            )
        ]
    }
}
