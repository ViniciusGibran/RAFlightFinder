import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    // MARK: UI
    
    // top left
    private let topLeftIcon: UIImageView = {
        let imageView = UIImageView(image: .init(systemName: "airplane.circle.fill"))
        imageView.tintColor = .appYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let topLeftAppNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .thin)
        label.textColor = .darkGray
        label.text = "FlightFinder"
        return label
    }()
    
    // left
    private let departureTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let departureFromLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // center
    private let flightTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let flightCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // right
    private let arrivalTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let arrivalDestinationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // bottom
    private let fareTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .ultraLight)
        label.textColor = .black
        label.text = "Value fare"
        return label
    }()
    
    private let fareValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .appDarkBlue
        return label
    }()
    
    // content
    private let backgroundContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.roundCorner(3)
        return view
    }()
    
    private let flightInfoContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // self
        contentView.backgroundColor = .defaultBackround
        
        // containers
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.pinEdgesToSuperview(8)
        
        // note: botton set in setupFareInfo
        contentView.addSubview(flightInfoContainerStackView)
        flightInfoContainerStackView.centerHorizontally()
        flightInfoContainerStackView.pinTop(45)
        flightInfoContainerStackView.constraintHeight(60)
        
        // contents
        setupTopLeft()
        setupFlightInfo()
        setupFareInfo()
    }
    
    private func setupTopLeft() {
        // icon
        backgroundContainerView.addSubview(topLeftIcon)
        topLeftIcon.pinTop(8)
        topLeftIcon.pinLeft(8)
        topLeftIcon.constraintHeight(18)
        topLeftIcon.constraintWidth(18)
        
        // app name
        backgroundContainerView.addSubview(topLeftAppNameLabel)
        topLeftAppNameLabel.alignLeading(25, target: topLeftIcon)
        topLeftAppNameLabel.centerVertically(inRelationTo: topLeftIcon)
    }
    
    private func setupFlightInfo() {
        // departure
        let departureStackView = UIStackView()
        departureStackView.axis = .vertical
        departureStackView.spacing = 5
        
        departureStackView.addArrangedSubviews([departureTimeLabel, departureFromLabel])
        flightInfoContainerStackView.addArrangedSubview(departureStackView)
        
        // flight time and code
        let flightTimeAndCodeStackView = UIStackView()
        flightTimeAndCodeStackView.axis = .vertical
        flightTimeAndCodeStackView.spacing = 3
        
        let separatorView = makeSeparatorViewToFlightTime()
        flightTimeAndCodeStackView.addArrangedSubviews([flightTimeLabel, separatorView, flightCodeLabel])
        flightInfoContainerStackView.addArrangedSubview(flightTimeAndCodeStackView)

        
        // arrival
        let arrivalStackView = UIStackView()
        arrivalStackView.axis = .vertical
        arrivalStackView.spacing = 5
        
        arrivalStackView.addArrangedSubviews([arrivalTimeLabel,arrivalDestinationLabel])
        flightInfoContainerStackView.addArrangedSubview(arrivalStackView)
    }
    
    private func setupFareInfo() {
        // separator
        let separatorView = UIView()
        backgroundContainerView.addSubview(separatorView)
        separatorView.pinTop(20, target: flightInfoContainerStackView)
        separatorView.pinLeft()
        separatorView.pinRight()
        separatorView.constraintHeight(1)
        separatorView.alpha = 0.6
        separatorView.backgroundColor = .lightGray
        
        
        // fare value
        backgroundContainerView.addSubview(fareValueLabel)
        
        fareValueLabel.pinTop(2, target: separatorView)
        fareValueLabel.pinBottom(3)
        fareValueLabel.centerHorizontally()
        
        // fare label
        backgroundContainerView.addSubview(fareTextLabel)
        fareTextLabel.alignLeading(-70, target: fareValueLabel)
        fareTextLabel.centerVertically(inRelationTo: fareValueLabel)
    }
    
    private func makeSeparatorViewToFlightTime() -> UIView {
        // container
        let contentStackView = UIStackView()
        contentStackView.axis = .horizontal
        contentStackView.spacing = 5
        contentStackView.distribution = .fill
        
        // left
        let leftLine = UIView()
        leftLine.backgroundColor = .lightGray
        
        let leftLineContainer = UIView()
        leftLineContainer.constraintWidth(34)
        leftLineContainer.constraintHeight(20)
        leftLineContainer.addSubview(leftLine)
        
        leftLine.pinLeft()
        leftLine.pinRight()
        leftLine.centerToSuperView()
        leftLine.constraintHeight(1)
        
        contentStackView.addArrangedSubview(leftLineContainer)
        
        // center
        let centerIcon = UIImageView(image: .init(systemName: "airplane.departure"))
        centerIcon.tintColor = .appYellow
        centerIcon.contentMode = .scaleAspectFit
        
        let iconContainer = UIView()
        iconContainer.constraintHeight(20)
        iconContainer.constraintWidth(20)
        iconContainer.addSubview(centerIcon)
        
        centerIcon.pinEdgesToSuperview(1)
        contentStackView.addArrangedSubview(iconContainer)

        // right
        let rightLine = UIView()
        rightLine.backgroundColor = .lightGray
        
        let rightLineContainer = UIView()
        rightLineContainer.constraintWidth(34)
        rightLineContainer.constraintHeight(20)
        rightLineContainer.addSubview(rightLine)
        
        rightLine.pinLeft()
        rightLine.pinRight()
        rightLine.centerToSuperView()
        rightLine.constraintHeight(1)
        
        contentStackView.addArrangedSubview(rightLineContainer)
        
        return contentStackView
    }
}

// MARK: - Configure Cell
extension SearchResultTableViewCell {
    func configure(with flightDisplayData: FlightSearchResultData) {
        departureTimeLabel.text = flightDisplayData.formattedDepartureTime
        arrivalTimeLabel.text = flightDisplayData.formattedArrivalTime
        flightCodeLabel.text = flightDisplayData.flightCode
        flightTimeLabel.text = flightDisplayData.formattedFlightDuration
        departureFromLabel.text = flightDisplayData.departureFrom
        arrivalDestinationLabel.text = flightDisplayData.arrivalDestination
        fareValueLabel.text = flightDisplayData.formattedFareValue
    }
}
