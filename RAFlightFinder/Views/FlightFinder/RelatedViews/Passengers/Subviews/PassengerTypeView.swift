import Combine
import UIKit

class PassengerTypeView: UIView {
    
    enum PassengerType: CaseIterable {
        case adult
        case teen
        case child
        case infant

        func value() -> (title: String, subtitle: String) {
            switch self {
            case .adult:
                return (title: "Adults", subtitle: "16+ years")
            case .teen:
                return (title: "Teens", subtitle: "12-15 years")
            case .child:
                return (title: "Children", subtitle: "2-11 years")
            case .infant:
                return (title: "Infant", subtitle: "Under 2 years")
            }
        }
    }
    
    // MARK: Properties
    
    private var cancellables: Set<AnyCancellable> = []
    private let passengerType: PassengerType
    
    let changePassengerCountSubject: PassthroughSubject<Int, Never>
    
    // MARK: Data
    
    var numberOfPassengers: Int {
        didSet {
            valueLabel.text = "\(numberOfPassengers)"
        }
    }
    
    
    // MARK: UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .appBlue
        label.textAlignment = .center
        return label
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        button.tintColor = .appBlue
        return button
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .appBlue
        return button
    }()
    
    // MARK: Init

    init(passengerType: PassengerType,
         numberOfPassengers: Int,
         changePassengerCountSubject: PassthroughSubject<Int, Never>
    ) {
        self.passengerType = passengerType
        self.changePassengerCountSubject = changePassengerCountSubject
        self.numberOfPassengers = numberOfPassengers
        
        super.init(frame: .zero)
        
        configure()
        setupUI()
        bindEvents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // self
        backgroundColor = .white
        roundCorner(2)
        
        // right side
        let leftSideContentStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        leftSideContentStackView.axis = .vertical
        leftSideContentStackView.spacing = 5
        
        addSubview(leftSideContentStackView)
        leftSideContentStackView.pinLeft(15)
        leftSideContentStackView.centerVertically()
        
        // right side
        let rightSideContentStackView = UIStackView(arrangedSubviews: [minusButton, valueLabel, plusButton])
        rightSideContentStackView.axis = .horizontal
        rightSideContentStackView.spacing = 10
        
        addSubview(rightSideContentStackView)
        rightSideContentStackView.pinRight(15)
        rightSideContentStackView.centerVertically()
        
        valueLabel.constraintWidth(20)
    }
    
    private func bindEvents() {
        minusButton.publisher.share()
            .receive(on: DispatchQueue.main)
            .sink { [weak self ] _ in
                guard let self = self else { return }
                var value = self.passengerType != .adult && self.numberOfPassengers > 0 ? 1 : 0
                if self.passengerType == .adult && self.numberOfPassengers > 1 { value = 1 }
                
                self.numberOfPassengers -= value
                self.changePassengerCountSubject.send(self.numberOfPassengers)
                self.updateButtonsColorIfNeeded()
        }.store(in: &cancellables)
        
        plusButton.publisher.share()
            .receive(on: DispatchQueue.main)
            .sink { [weak self ] _ in
                guard let self = self else { return }
                let value = self.numberOfPassengers < 6 ? 1 : 0
                
                self.numberOfPassengers += value
                self.changePassengerCountSubject.send(self.numberOfPassengers)
                self.updateButtonsColorIfNeeded()
        }.store(in: &cancellables)
    }
    
    private func configure() {
        let (title, subtitle) = passengerType.value()
        titleLabel.text = title
        subtitleLabel.text = subtitle
        valueLabel.text = "\(numberOfPassengers)"
        updateButtonsColorIfNeeded()
    }
    
    private func updateButtonsColorIfNeeded() {
        let minusButtonColor: UIColor = numberOfPassengers == 0 || (self.passengerType == .adult && self.numberOfPassengers == 1) ? .gray : .appBlue
        minusButton.tintColor = minusButtonColor
        
        let plusButtonColor: UIColor = numberOfPassengers == 6 ? .gray : .appBlue
        plusButton.tintColor = plusButtonColor
    }
}
