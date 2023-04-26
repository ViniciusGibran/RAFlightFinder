import Combine
import UIKit

class TravelDateViewModel: ObservableObject {
    // MARK: Properties
    let selectedDatesPublisher: PassthroughSubject<TravelDates, Never>
    
    // MARK: Data
    var travelSegment: TravelDates
    
    // MARK: Init
    init(selectedDatesPublisher: PassthroughSubject<TravelDates, Never>) {
        self.selectedDatesPublisher = selectedDatesPublisher
        self.travelSegment = TravelDates()
    }
}
