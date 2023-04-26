import Combine
import UIKit

class PassengerSelectionViewModel {
    // MARK: Properties
    
    let selectedPassengersSubject: PassthroughSubject<NumberOfPassengers, Never>
    var changePassengerCountSubjects: [PassengerTypeView.PassengerType: PassthroughSubject<Int, Never>]
    
    private var changePassengerCountCancellable = Set<AnyCancellable>()
    
    // MARK: Data
    
    var numberOfPassengers: NumberOfPassengers

    // MARK: Init
    
    init(numberOfPassengers: NumberOfPassengers,
        selectedPassengersSubject: PassthroughSubject<NumberOfPassengers, Never>
    ) {
        self.numberOfPassengers = numberOfPassengers
        self.selectedPassengersSubject = selectedPassengersSubject
        self.changePassengerCountSubjects = PassengerTypeView.PassengerType.allCases.reduce(into: [PassengerTypeView.PassengerType: PassthroughSubject<Int, Never>]()) { result, passengerType in
            result[passengerType] = PassthroughSubject<Int, Never>()
        }
        
        bindEvents()
    }
    
    private func bindEvents() {
        changePassengerCountSubjects.forEach { (passengerType, subject) in
            subject.sink { [weak self] change in
                guard let self = self else { return }
                switch passengerType {
                case .adult:
                    self.numberOfPassengers.adult = change
                case .teen:
                    self.numberOfPassengers.teen = change
                case .child:
                    self.numberOfPassengers.child = change
                case .infant:
                    self.numberOfPassengers.infant = change
                }
            }.store(in: &changePassengerCountCancellable)
        }
    }
}

