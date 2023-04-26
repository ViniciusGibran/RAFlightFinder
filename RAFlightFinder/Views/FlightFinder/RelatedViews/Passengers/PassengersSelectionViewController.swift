import Combine
import UIKit

class PassengersSelectionViewController: UIViewController {
    
    // MARK: Properties
    
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: PassengerSelectionViewModel
    
    // MARK: UI
    
    let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .appBlue
        button.setTitleColor(.appYellow, for: .normal)
        button.roundCorner(2)
        return button
    }()
    
    // MARK: Lifecycle
    
    init(viewModel: PassengerSelectionViewModel) {
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
    
    private func setupUI() {
        // passengers type stack view content
        let stackViewContent = UIStackView()
        stackViewContent.axis = .vertical
        stackViewContent.spacing = 2
        
        view.addSubview(stackViewContent)
        stackViewContent.pinTop(30)
        stackViewContent.pinLeft(15)
        stackViewContent.pinRight(15)
        
        // passenger type views
        PassengerTypeView.PassengerType.allCases.forEach { passengerType in
            if let changePassengerCountSubject = viewModel.changePassengerCountSubjects[passengerType] {
                var passengerTypeView: PassengerTypeView?
                
                switch passengerType {
                case .adult:
                    passengerTypeView = PassengerTypeView(
                        passengerType: passengerType,
                        numberOfPassengers: viewModel.numberOfPassengers.adult,
                        changePassengerCountSubject: changePassengerCountSubject
                    )
                case .teen:
                    passengerTypeView = PassengerTypeView(
                        passengerType: passengerType,
                        numberOfPassengers: viewModel.numberOfPassengers.teen,
                        changePassengerCountSubject: changePassengerCountSubject
                    )
                    
                case .child:
                    passengerTypeView = PassengerTypeView(
                        passengerType: passengerType,
                        numberOfPassengers: viewModel.numberOfPassengers.child,
                        changePassengerCountSubject: changePassengerCountSubject
                    )
                case .infant:
                    passengerTypeView = PassengerTypeView(
                        passengerType: passengerType,
                        numberOfPassengers: viewModel.numberOfPassengers.infant,
                        changePassengerCountSubject: changePassengerCountSubject
                    )
                }
                
                if let passengerTypeView = passengerTypeView {
                    stackViewContent.addArrangedSubview(passengerTypeView)
                    passengerTypeView.constraintHeight(60)
                }
            }
        }
        
        // apply button
        view.addSubview(applyButton)
        applyButton.pinLeft(15)
        applyButton.pinRight(15)
        applyButton.pinSafeBottom(20)
        applyButton.constraintHeight(50)
    }
    
    private func bindEvents() {
        applyButton.publisher.share()
            .receive(on: DispatchQueue.main)
            .sink { [weak self ] _ in
                guard let self = self else { return }
                self.viewModel.selectedPassengersSubject.send(self.viewModel.numberOfPassengers)
                self.dismiss(animated: true)
            }.store(in: &cancellables)
    }
}

