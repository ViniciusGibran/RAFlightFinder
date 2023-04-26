import Combine
import UIKit

class FlightFinderViewModel {
    // MARK: Properties
    // Publishers
    let selectedStationSubject = PassthroughSubject<(station: Station, formType: FormFieldView.FormFieldViewType),  Never>()
    let selectedDatesSubject = PassthroughSubject<TravelDates, Never>()
    let selectedPassengersSubject = PassthroughSubject<NumberOfPassengers, Never>()
    let isFormValidSubject = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: Data
    // forms params
    var fromStation: Station? {
        didSet {
            destinationStation = nil
            validateForm()
        }
    }
    
    var destinationStation: Station? {
        didSet { validateForm() }
    }
    
    var travelSegment: TravelDates? {
        didSet { validateForm() }
    }
    
    var numberOfPassengers = NumberOfPassengers() {
        didSet { validateForm() }
    }
    
    // search form data parameters
    private(set) var flightSearchParams: FlightSearchParams?
    
    // MARK: Methods
    
    // private
    private func validateForm() {
        if numberOfPassengers.isValidEntry,
           let fromStation = fromStation,
           let destinationStation = destinationStation,
           let flyOutDate = travelSegment?.flyOutDate,
           let flyBackDate = travelSegment?.flyBackDate {
            
            flightSearchParams = .init(
                origin: fromStation.code,
                destination: destinationStation.code,
                dateOut: flyOutDate,
                dateIn: flyBackDate,
                adult: numberOfPassengers.adult,
                teen: numberOfPassengers.teen,
                child: numberOfPassengers.child,
                infant: numberOfPassengers.infant
            )
            
            isFormValidSubject.send(true)
        } else {
            isFormValidSubject.send(false)
        }
    }
}
