import XCTest
import Combine
@testable import RAFlightFinder

class StationListViewModelTests: XCTestCase {
    var viewModel: StationListViewModel!
    var stationListRepository: StationListRepositoryMock!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        
        stationListRepository = StationListRepositoryMock()
        viewModel = StationListViewModel(
            stationListRepository: stationListRepository,
            selectedStation: nil,
            formFieldSelectedStationSubject: PassthroughSubject<(station: Station, formType: FormFieldView.FormFieldViewType), Never>()
        )
    }
    
    func testFetchStations_UpdatesStations() {
        let expectation = XCTestExpectation(description: "Stations are fetched and stored in the viewModel")
        
        viewModel.stationListResponseSubject
            .sink(receiveValue: {
                XCTAssertEqual(self.viewModel.filteredStations.count, 2)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.fetchStations()
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFilteredStations_ReturnsFilteredStationsBasedOnSearchText() {
        let expectation = XCTestExpectation(description: "Fetch stations expectation")
        
        viewModel.fetchStations()
        
        viewModel.stationListResponseSubject
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.searchText.value = "B"
        
        wait(for: [expectation], timeout: 5.0)
        
        let filteredStations = viewModel.filteredStations
        XCTAssertEqual(filteredStations.count, 1)
        XCTAssertEqual(filteredStations.first?.code, "BBB")
    }
    
    func testFilteredStations_EmptySearchTextReturnsAllStations() {
        let mockStations = StationListRepositoryMock.MOCK_DATA.mockStationListResultData
        let expectation = XCTestExpectation(description: "Fetch stations expectation")
        
        viewModel.searchText.value = ""
        viewModel.stationListResponseSubject
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchStations()
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(viewModel.filteredStations.count, mockStations.count)
    }

}

