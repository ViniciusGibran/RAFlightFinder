#FLIGHT FINDER

Flight Finder allows users to search for and explore flight options between different stations. The app is built using Swift and follows the MVVM
(Model-View-ViewModel) design pattern. It utilizes UIKit for building the user interface and Combine for reactive programming and handling data flow.

#Project Structure
The app is organized into the following key components:

ViewControllers: Contains the main view controllers responsible for rendering the user interface and handling user interactions. The FlightFinderViewController is the primary view controller, which displays the search form for users to enter their flight search criteria.

ViewModels: Contains the view models that handle the app's logic and provide data to the view controllers. The FlightFinderViewModel is the main view model that interacts with the FlightFinderViewController and manages the search form's data.

Views: Contains custom UIView subclasses, such as FormFieldView, which are used by the view controllers to render various UI elements.

Coordinator: Implements the coordinator pattern for handling navigation and dependencies between view controllers. The FlightFinderCoordinator is responsible for managing the navigation flow and initializing the view models and view controllers.

Models: Contains data models, such as Station, TravelSegment, and NumberOfPassengers, which represent some of the app's data structures.

Extensions: Contains extensions for UIKit components to add custom functionality or appearance.

#Technologies and Libraries
- Swift: The app is written in Swift, a powerful and modern programming language for iOS development.
- UIKit: The user interface is built using UIKit, Apple's framework for building graphical user interfaces for iOS devices.
- Combine: Reactive programming is implemented using the Combine framework, which allows for efficient and declarative data flow management between the app's components.
- Coordinator Pattern: The app follows the coordinator pattern to manage the app's navigation flow and dependencies between view controllers.

#Usage
The app presents a flight search form where users can input their desired origin and destination stations, travel dates, and the number of passengers. Users can search for stations
by selecting the "From" or "Destination" fields, which navigates to a station selection view where they can filter and choose a station. After completing the form, users can explore
the available flight options based on their search criteria.


#TASK

Build a search form
Create a form where the user can make an availability request with the following parameters: * Origin station (origin)
* Destination station (destination)
* Departure date (dateout)
* Adults (adt)
* Teen (teen)
* Children (chd)

The form should also include a search button to call the server to retrieve the response and present the results on a list with date, flight number and regular fare.
Plus for:
* Origin station (origin) " show station list and provide search option by code or name
* Destination station (destination) " show station list and provide search option by code or name
* Departure date (dateout) " plus to show a date picker or calendar
* Adults (adt) " plus to show a picker or increment control with min 1 / max 6
* Teen (teen) " plus to show a picker or increment control with min 0 / max 6
* Children (chd) " plus to show a picker or increment control with min 0 / max 6
Important note: This is a technical test, do not invest too much time thinking about UI/UX

#TODO's

There's still a lot of things to be reviewd, updated and finished. Amongst all, here's few important things to be done in the future:
- create atuomated tests (a few have been added)
- organize the models into own files ✅
- fix the SearchResult with a working API to request available Flights ✅
- review Subviews usage, in some cases we can add a ViewModel and separate some business logics (eg PassengerTypeView buttons action UI update)" to "Review subview usage; in some cases, a ViewModel can be added to separate business logic (e.g., PassengerTypeView button action UI updates).
- consider using same approach used to handle FormFieldView user interaction on FormFieldView 
- adds and customize a "trip type" on FlightFinderViewController so the user can selects with its a one way round trip
- adds options to show days flexdays before/in on the SearchResultViewController 
- convert views to SwiftUI


###Overall Experience
I found it very exciting and challenging developing this small app, I used the opportunity to explore Combine framework and bind events between views and viewModels. Designing and implementing the logic for data capture and fields was enjoyable, and I am satisfied with the results.
