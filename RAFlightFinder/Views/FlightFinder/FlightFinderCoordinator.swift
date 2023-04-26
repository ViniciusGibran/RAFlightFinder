import UIKit

class FlightFinderCoordinator: Coordinator {
    var navigationController: UINavigationController
    private var viewModel: FlightFinderViewModel
    
    init(navigationController: UINavigationController, viewModel: FlightFinderViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let flightFinderViewController = FlightFinderViewController(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(flightFinderViewController, animated: true)
    }
    
    func navigateTo(_ formFieldViewType: FormFieldView.FormFieldViewType) {
        
        var viewControllerToPresent: UIViewController?
        
        switch formFieldViewType {
        case .from, .destination:
            let selectedStation = formFieldViewType == .destination ? viewModel.fromStation : nil
            let stationListRepository = StationListRepository()
            let stationListViewModel = StationListViewModel(
                stationListRepository: stationListRepository,
                selectedStation: selectedStation,
                formFieldSelectedStationSubject: viewModel.selectedStationSubject
            )
            let stationListViewController = StationListViewController(
                viewModel: stationListViewModel,
                formViewType: formFieldViewType
            )
            viewControllerToPresent = stationListViewController
            
        case .travelDates:
            let travelDateViewModel = TravelDateViewModel(selectedDatesPublisher: viewModel.selectedDatesSubject)
            let travelDateViewController = TravelDateViewController(viewModel: travelDateViewModel)
            viewControllerToPresent = travelDateViewController
            
        case .passengers:
            let passengersSelectionViewModel = PassengerSelectionViewModel(numberOfPassengers: viewModel.numberOfPassengers,
                                                                           selectedPassengersSubject: viewModel.selectedPassengersSubject)
            let passengersSelectionViewController = PassengersSelectionViewController(viewModel: passengersSelectionViewModel)
            viewControllerToPresent = passengersSelectionViewController
        }
        
        if let viewControllerToPresent = viewControllerToPresent {
            navigationController.present(viewControllerToPresent, animated: true)
        }
    }
    
    func showsearchResultView(flightSearchParams: FlightSearchParams) {
        let searchResultViewModel = SearchResultViewModel(
            flightSearchRepository: FlightSearchRepository(),
            flightSearchParams: flightSearchParams
        )
        
        let searchViewController = SearchResultViewController(viewModel: searchResultViewModel)
        
        navigationController.present(searchViewController, animated: true)
    }
}
