import XCTest
@testable import RAFlightFinder

final class FlightFinderViewModelTests: XCTestCase {
    
    var viewModel: FlightFinderViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = FlightFinderViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFormValidation_AllFieldsAreFilled() {
        let originStation = Station.makeMock()
        let destinationStation = Station.makeMock(code: "LHR", name: "London Heathrow Airport", countryCode: "GB")
        let travelDates = TravelDates(flyOutDate: Date(), flyBackDate: Date().addingTimeInterval(60 * 60 * 24))
        let numberOfPassengers = NumberOfPassengers(adult: 1, teen: 0, child: 0, infant: 0)
        
        viewModel.fromStation = originStation
        viewModel.destinationStation = destinationStation
        viewModel.travelSegment = travelDates
        viewModel.numberOfPassengers = numberOfPassengers
        
        // Assert
        XCTAssertTrue(viewModel.isFormValidSubject.value, "Form should be valid when all fields are filled")
    }
    
    func testFormValidation_FieldsAreNotFilled() {
        let originStation = Station.makeMock()
        let destinationStation = Station.makeMock(code: "LHR", name: "London Heathrow Airport", countryCode: "GB")
        let travelDates = TravelDates(flyOutDate: Date(), flyBackDate: Date().addingTimeInterval(60 * 60 * 24))
        
        viewModel.fromStation = nil
        viewModel.destinationStation = destinationStation
        viewModel.travelSegment = travelDates
        
        XCTAssertFalse(viewModel.isFormValidSubject.value, "Form should be invalid when origin station is missing")
        
        viewModel.fromStation = originStation
        viewModel.destinationStation = nil
        viewModel.travelSegment = travelDates
        
        XCTAssertFalse(viewModel.isFormValidSubject.value, "Form should be invalid when destination station is missing")
        
        viewModel.fromStation = originStation
        viewModel.destinationStation = destinationStation
        viewModel.travelSegment = nil
        
        XCTAssertFalse(viewModel.isFormValidSubject.value, "Form should be invalid when travel dates are missing")
    }
    
    func testFormValidation_NumberOfPassengersIsInvalid() {
        let originStation = Station.makeMock()
        let destinationStation = Station.makeMock(code: "LHR", name: "London Heathrow Airport", countryCode: "GB")
        let travelDates = TravelDates(flyOutDate: Date(), flyBackDate: Date().addingTimeInterval(60 * 60 * 24))
        
        viewModel.fromStation = originStation
        viewModel.destinationStation = destinationStation
        viewModel.travelSegment = travelDates
        
        viewModel.numberOfPassengers = NumberOfPassengers(adult: 0, teen: 0, child: 0, infant: 0)
        XCTAssertFalse(viewModel.isFormValidSubject.value, "Form should be invalid when the number of passengers is zero")
        
        viewModel.numberOfPassengers = NumberOfPassengers(adult: 11, teen: 0, child: 0, infant: 0)
        XCTAssertFalse(viewModel.isFormValidSubject.value, "Form should be invalid when the number of passengers exceeds the maximum limit")
    }
}
