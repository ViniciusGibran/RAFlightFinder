import Combine
import UIKit

class TravelDateViewController: UIViewController {
    
    enum SegmentOptions: String {
        case flyOut = "Fly Out"
        case flyBack = "Fly Back"
        
        var intValue: Int {
            switch self {
            case .flyOut: return 0
            case .flyBack: return 1
            }
        }
    }
    
    // MARK: UI
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [SegmentOptions.flyOut.rawValue, SegmentOptions.flyBack.rawValue])
        control.selectedSegmentIndex = 0
        control.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = .appBlue
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        return control
    }()
    
    private lazy var calendarView: UICalendarView = {
        let calendar = UICalendarView()
        calendar.tintColor = .appBlue
        calendar.backgroundColor = .white
        
        // date range
        let now = Date()
        let twoMonthsLater = Calendar.current.date(byAdding: .month, value: 2, to: now)!
        calendar.availableDateRange = DateInterval(start: now, end: twoMonthsLater)

        calendar.fontDesign = .rounded
        calendar.roundCorner()
        calendar.locale = .current
        calendar.calendar = .current
        calendar.delegate = self
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendar.selectionBehavior = selection
        
        return calendar
    }()
    
    // MARK: Properties
    
    private var viewModel: TravelDateViewModel
    
    // MARK: Lifecycle
    
    init(viewModel: TravelDateViewModel) {
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
    }
    
    private func setupUI() {
        setupSegmentControl()
        setupCalendar()
    }
    
    private func setupSegmentControl() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.centerHorizontally()
        segmentedControl.constraintWidth(250)
        segmentedControl.constraintHeight(40)
        segmentedControl.pinSafeTop(30)
        
        segmentedControl.addTarget(self, action: #selector(updateCalendarDateRange), for: .valueChanged)
    }
    
    private func setupCalendar() {
        view.addSubview(calendarView)
        calendarView.pinTop(20, target: segmentedControl)
        calendarView.pinLeft(16)
        calendarView.pinRight(16)
        calendarView.pinBottom(80)
        
        calendarView.tintColor = .appBlue
        calendarView.backgroundColor = .white
    }
    
    @objc private func updateCalendarDateRange() {
        guard let endDate = Calendar.current.date(byAdding: .month, value: 2, to: Date())
        else { return }
        
        switch segmentedControl.selectedSegmentIndex {
        case SegmentOptions.flyOut.intValue:
            calendarView.availableDateRange = DateInterval(start: Date(), end: endDate)
        case SegmentOptions.flyBack.intValue:
            if let flyOutDate = viewModel.travelSegment.flyOutDate {
                calendarView.availableDateRange = DateInterval(start: flyOutDate, end: endDate)
            }
        default:
            break
        }
    }
}


// MARK: - UICalendarSelectionSingleDateDelegate
extension TravelDateViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let date = dateComponents?.date else { return }
        
        switch segmentedControl.selectedSegmentIndex {
        case SegmentOptions.flyOut.intValue:
            viewModel.travelSegment.flyOutDate = date
            segmentedControl.selectedSegmentIndex = SegmentOptions.flyBack.intValue
            updateCalendarDateRange()
        case SegmentOptions.flyBack.intValue:
            viewModel.travelSegment.flyBackDate = date
            
            viewModel.selectedDatesPublisher.send(viewModel.travelSegment)
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
}

// MARK: - UICalendarViewDelegate
extension TravelDateViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
       if let date = dateComponents.date,
           (calendarView.availableDateRange.contains(date) || date.yearMonthDay == Date().yearMonthDay) {
            switch segmentedControl.selectedSegmentIndex {
            case SegmentOptions.flyOut.intValue:
                return .image(.init(systemName: "airplane.departure"), color: .appBlue)
            case SegmentOptions.flyBack.intValue:
                return .image(.init(systemName: "airplane.arrival"), color: .appBlue)
            default:
                break
            }
        }
        return nil
    }
}

// MARK: - Helper
extension Date {
    var yearMonthDay: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)!
    }
}

