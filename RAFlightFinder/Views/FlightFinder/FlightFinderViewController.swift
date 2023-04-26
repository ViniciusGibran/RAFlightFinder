import Combine
import UIKit

class FlightFinderViewController: UIViewController {
    
    // MARK: Properties
    
    private var viewModel: FlightFinderViewModel
    private var coordinator: FlightFinderCoordinator
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: UI
    
    private var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appBlue
        return view
    }()
    
    private var tripTypeContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private var tripInfoContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    // form fields
    private let fromFormFieldView: FormFieldView = {
        FormFieldView(iconName: "airplane.departure", formFieldViewType: .from)
    }()
    
    private let destinationFormFieldView: FormFieldView = {
        FormFieldView(iconName: "airplane.arrival", formFieldViewType: .destination)
    }()
    
    private let travelDatesFormFieldView: FormFieldView = {
        FormFieldView(iconName: "calendar", formFieldViewType: .travelDates)
    }()
    
    private var passengersFormFieldView: FormFieldView = {
        FormFieldView(iconName: "person", formFieldViewType: .passengers)
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.roundCorner(2)
        return button
    }()
    
    // MARK: Lifecycle
    
    init(
        coordinator: FlightFinderCoordinator,
        viewModel: FlightFinderViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .defaultBackround
        
        setupUI()
        bindEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setInitialData()
    }
    
    private func setupUI() {
        setupHeaderView()
        setupTripTypeContentView()
        setupTripInfoContentStackView()
        setupAppplyButton()
    }
    
    private func bindEvents() {
        bindViewModel()
        bindSubviews()
    }
    
    // MARK: View Setups
    private func bindViewModel() {
        viewModel.selectedStationSubject
            .sink { [weak self] station, formType in
                guard let self = self else { return }
                switch formType {
                case .from:
                    self.viewModel.fromStation = station
                    self.fromFormFieldView.updateTitle(station.name)
                    self.destinationFormFieldView.resetTitle()
                    
                case .destination:
                    self.viewModel.destinationStation = station
                    self.destinationFormFieldView.updateTitle(station.name)
                    
                default: break
                }
            }
            .store(in: &cancellables)
        
        viewModel.selectedDatesSubject
            .sink { [weak self] travelSegment in
                guard let self = self else { return }
                self.viewModel.travelSegment = travelSegment
                
                if let formattedDates = self.viewModel.travelSegment?.formattedDate(), formattedDates != "" {
                    self.travelDatesFormFieldView.updateTitle(formattedDates)
                }
            }
            .store(in: &cancellables)
        
        viewModel.selectedPassengersSubject
            .sink { [weak self] numberOfpassengers in
                guard let self = self else { return }
                self.viewModel.numberOfPassengers = numberOfpassengers
                
                if let numberOfPassengers = self.viewModel.numberOfPassengers.formattedPassengers() {
                    self.passengersFormFieldView.updateTitle(numberOfPassengers)
                }
            }
            .store(in: &cancellables)
        
        viewModel.isFormValidSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.updateSearchButtonStyle(isValid)
            }
            .store(in: &cancellables)
    }
    
    private func bindSubviews() {
        fromFormFieldView.buttonPublisher
            .sink { [weak self] formFieldViewType in
                self?.coordinator.navigateTo(formFieldViewType)
            }
            .store(in: &cancellables)
        
        destinationFormFieldView.buttonPublisher
            .sink { [weak self] formFieldViewType in
                self?.coordinator.navigateTo(formFieldViewType)
            }
            .store(in: &cancellables)
        
        travelDatesFormFieldView.buttonPublisher
            .sink { [weak self] formFieldViewType in
                self?.coordinator.navigateTo(formFieldViewType)
            }
            .store(in: &cancellables)
        
        passengersFormFieldView.buttonPublisher
            .sink { [weak self] formFieldViewType in
                self?.coordinator.navigateTo(formFieldViewType)
            }
            .store(in: &cancellables)
        
        searchButton.publisher.share()
            .receive(on: DispatchQueue.main)
            .sink { [weak self ] _ in
                guard let self = self,
                      let flightSearchParams = self.viewModel.flightSearchParams
                else { return }
                
                self.coordinator.showsearchResultView(flightSearchParams: flightSearchParams)
            }.store(in: &cancellables)
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.pinTop()
        headerView.pinLeft()
        headerView.pinRight()
        headerView.constraintHeight(70)
        
        // add header label
        let headerLabel = UILabel()
        headerLabel.font = .systemFont(ofSize: 22, weight: .bold)
        headerLabel.textColor = .appYellow
        headerLabel.text = "Flight Finder ✈️"
        headerLabel.textAlignment = .center
        
        headerView.addSubview(headerLabel)
        headerLabel.centerToSuperView()
    }
    
    // TODO:
    private func setupTripTypeContentView() {
        // TODO: adds buttons and bind actions
        // trip type content view
        //view.addSubview(tripTypeContentView)
        tripTypeContentView.pinTop(target: headerView)
        tripTypeContentView.pinLeft()
        tripTypeContentView.pinRight()
        tripTypeContentView.constraintHeight(10)
    }
    
    private func setupTripInfoContentStackView() {
        view.addSubview(tripInfoContentStackView)
        tripInfoContentStackView.pinTop(25, target: headerView)
        tripInfoContentStackView.pinLeft(15)
        tripInfoContentStackView.pinRight(15)
        
        setupTripInfoStackViewSubviews()
    }
    
    private func setupTripInfoStackViewSubviews() {
        // from to destination content
        let flightSegmentStackView = UIStackView()
        flightSegmentStackView.prepareForConstraints()
        flightSegmentStackView.axis = .vertical
        flightSegmentStackView.spacing = 2
        
        fromFormFieldView.roundCorner()
        flightSegmentStackView.addArrangedSubview(fromFormFieldView)
        fromFormFieldView.constraintHeight(50)
        
        destinationFormFieldView.roundCorner()
        flightSegmentStackView.addArrangedSubview(destinationFormFieldView)
        destinationFormFieldView.constraintHeight(50)
        
        tripInfoContentStackView.addArrangedSubview(flightSegmentStackView)
        
        // travel dates
        travelDatesFormFieldView.roundCorner()
        tripInfoContentStackView.addArrangedSubview(travelDatesFormFieldView)
        travelDatesFormFieldView.constraintHeight(50)
        
        // passengers
        passengersFormFieldView.roundCorner()
        tripInfoContentStackView.addArrangedSubview(passengersFormFieldView)
        passengersFormFieldView.constraintHeight(50)
    }
    
    private func setupAppplyButton() {
        view.addSubview(searchButton)
        searchButton.pinLeft(15)
        searchButton.pinRight(15)
        searchButton.pinSafeBottom(20)
        searchButton.constraintHeight(50)
    }
    
    private func setInitialData() {
        /// update number of passengers form view
        if let numberOfPassengers = self.viewModel.numberOfPassengers.formattedPassengers() {
            passengersFormFieldView.updateTitle(numberOfPassengers)
        }
    }
    
    private func updateSearchButtonStyle(_ isValidEntry: Bool) {
        let backgroundColor: UIColor = isValidEntry ? .appYellow : .lightGray
        let tintColor: UIColor = isValidEntry ? .appBlue : .white
        
        UIView.animate(withDuration: 0.5) {
            self.searchButton.isEnabled = isValidEntry
            self.searchButton.backgroundColor = backgroundColor
            self.searchButton.setTitleColor(tintColor, for: .normal)
        }
    }
}

// MARK: - Constants
extension FlightFinderViewController {
    // TODO: create constants for each use case
    struct Constants {
        static let defaultSpacing: CGFloat = 10
        static let flightSegmentStackViewSpacing: CGFloat = 2
        static let headerViewHeight: CGFloat = 70
        static let tripTypeContentViewHeight: CGFloat = 10
        static let tripInfoContentStackViewPinTop: CGFloat = 25
        static let tripInfoContentStackViewPinLeft: CGFloat = 15
        static let tripInfoContentStackViewPinRight: CGFloat = 15
        static let formFieldHeight: CGFloat = 50
    }
}
