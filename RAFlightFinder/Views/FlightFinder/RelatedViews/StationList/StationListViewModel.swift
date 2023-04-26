import Combine
import UIKit

class StationListViewModel {
    
    // MARK: Properties
    
    let formFieldSelectedStationSubject: PassthroughSubject<(station: Station, formType: FormFieldView.FormFieldViewType),  Never>?
    let stationListResponseSubject = PassthroughSubject<Void, Never>()
    let searchText = CurrentValueSubject<String, Never>("")
    
    private let stationListRepository: StationListRepositoryProtocol
    private var fetchStationCancellable = Set<AnyCancellable>()
    
    private var stations: [Station] = [] {
        didSet {
            stationListResponseSubject.send()
        }
    }
    
    var filteredStations: [Station] {
        let allStations: [Station]

        if let selectedStation = selectedStation {
            let marketCodes = Set(selectedStation.markets.map { $0.code })
            allStations = stations.filter { marketCodes.contains($0.code) }
        } else {
            allStations = stations
        }

        if searchText.value.isEmpty {
            return allStations
        } else {
            return allStations.filter { station in
                return station.name.lowercased().contains(searchText.value.lowercased()) ||
                station.countryName.lowercased().contains(searchText.value.lowercased()) ||
                station.code.lowercased().contains(searchText.value.lowercased())
            }
        }
    }
    
    // MARK: Data
    
    private var selectedStation: Station?
    
    // MARK: Init
    
    init(
        stationListRepository: StationListRepositoryProtocol,
        selectedStation: Station?,
        formFieldSelectedStationSubject: PassthroughSubject<(station: Station, formType: FormFieldView.FormFieldViewType),  Never>?
    ) {
        self.stationListRepository = stationListRepository
        self.selectedStation = selectedStation
        self.formFieldSelectedStationSubject = formFieldSelectedStationSubject
    }
    
    // MARK: Methods
    
    func fetchStations() {
        stationListRepository.getStationList()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching stations: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] stations in
                if let stations = stations {
                    self?.stations = stations
                }
            })
            .store(in: &fetchStationCancellable)
    }
}
