import UIKit

class StationListTableViewCell: UITableViewCell {
    
    // MARK: UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private let backgroundContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: private
    
    private func setupUI() {
        // self
        contentView.backgroundColor = .defaultBackround
        
        // container
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.pinTop(1)
        backgroundContainerView.pinBottom(1)
        backgroundContainerView.pinLeft()
        backgroundContainerView.pinRight()
        
        // Setup stack view
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(subtitleLabel)
        
        backgroundContainerView.addSubview(containerStackView)
        containerStackView.pinTop(10)
        containerStackView.pinBottom(10)
        containerStackView.pinLeft(15)
        containerStackView.pinRight(15)
    }
}

// MARK: - Configure Cell
extension StationListTableViewCell {
    func configure(with station: Station) {
        titleLabel.text = station.name
        subtitleLabel.text = station.countryName
    }
}
