import Combine
import UIKit

class SearchResultViewModel {
    private let flightSearchRepository: FlightSearchRepositoryProtocol
    private let flightSearchParams: FlightSearchParams
    
    private var fetchFlightSearchCancellable = Set<AnyCancellable>()
    
    let searchFetchResulSubject = PassthroughSubject<Void, Never>()
    
    var flights: [FlightSearchResultData] = [] {
        didSet {
            searchFetchResulSubject.send()
        }
    }
    
    init(
        flightSearchRepository: FlightSearchRepositoryProtocol,
        flightSearchParams: FlightSearchParams
    ) {
        self.flightSearchRepository = flightSearchRepository
        self.flightSearchParams = flightSearchParams
    }
    
    func fetchFlightSearch() {
        flightSearchRepository.getFlightFinderSearch(flightSearchParams)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching stations: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] flights in
                if let flights = flights {
                    self?.flights = flights
                }
            })
            .store(in: &fetchFlightSearchCancellable)
    }
    
}
