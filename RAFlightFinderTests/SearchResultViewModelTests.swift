import XCTest
import Combine
@testable import RAFlightFinder

class SearchResultViewModelTests: XCTestCase {
    var viewModel: SearchResultViewModel!
    var flightSearchRepository: FlightSearchRepositoryMock!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        
        flightSearchRepository = FlightSearchRepositoryMock()
        
        viewModel = SearchResultViewModel(
            flightSearchRepository: flightSearchRepository,
            flightSearchParams: FlightSearchRepositoryMock.MOCK_DATA.mockFlightSearchParams
        )
    }
    
    func testFetchFlightSearch_UpdatesFlights() {
        let expectation = XCTestExpectation(description: "Flights are fetched and stored in the viewModel")
        
        viewModel.searchFetchResulSubject
            .sink(receiveValue: {
                XCTAssertEqual(self.viewModel.flights.count, 3)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.fetchFlightSearch()
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testSearchFetchResulSubject_SendsValueOnFlightsUpdate() {
        let expectation = XCTestExpectation(description: "searchFetchResulSubject sends value on flights update")
        
        viewModel.searchFetchResulSubject
            .sink(receiveValue: {
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.fetchFlightSearch()
        
        wait(for: [expectation], timeout: 5)
    }
}
