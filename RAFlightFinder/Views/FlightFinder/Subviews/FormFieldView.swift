import Combine
import UIKit

class FormFieldView: UIView {
    
    enum FormFieldViewType: String {
        case from = "From"
        case destination = "Destination"
        case travelDates = "Travel dates"
        case passengers = "Passengers"
    }
    
    // MARK: Properties
    
    private let formFieldViewType: FormFieldViewType
    private var formValueCenterConstraint: NSLayoutConstraint?
    
    // private
    private lazy var formButton: UIButton = UIButton(type: .system)
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray
        label.numberOfLines = 1
        label.alpha = 0
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var formValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    // public
    var buttonPublisher: AnyPublisher<FormFieldViewType, Never> {
        return formButton.publisher.share()
            .receive(on: DispatchQueue.main)
            .map { self.formFieldViewType }
            .eraseToAnyPublisher()
    }
    
    // MARK: Lifecycle
    
    init(iconName: String, formFieldViewType: FormFieldViewType) {
        self.formFieldViewType = formFieldViewType
        
        super.init(frame: .zero)
        setupUI()
        configure(iconImageName: iconName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setupUI() {
        // self
        backgroundColor = .white
        
        // ui
        setupIcon()
        setupTitle()
        setupFormValueLabel()
        setupFormButton()
    }
    
    private func setupIcon() {
        addSubview(iconImageView)
        iconImageView.pinLeft(15)
        iconImageView.centerVertically()
        iconImageView.constraintHeight(24)
        iconImageView.constraintWidth(24)
    }
    
    private func setupTitle() {
        addSubview(titleLabel)
        titleLabel.alignLeading(40, target: iconImageView)
        titleLabel.pinRight(15)
        titleLabel.centerVertically(-10)
    }
    
    private func setupFormValueLabel() {
        addSubview(formValueLabel)
        formValueLabel.alignLeading(40, target: iconImageView)
        formValueLabel.pinRight(15)
        formValueCenterConstraint = formValueLabel.centerVertically(1)
    }
    
    private func setupFormButton() {
        addSubview(formButton)
        formButton.pinEdgesToSuperview()
    }
    
    private func configure(iconImageName: String) {
        iconImageView.image = UIImage(systemName: iconImageName)
        titleLabel.text = formFieldViewType.rawValue
        formValueLabel.text = formFieldViewType.rawValue
    }
    
    // public
    func updateTitle(_ title: String) {
        formValueLabel.textColor = .black
        formValueLabel.alpha = 0
        formValueLabel.text = title
        
        self.formValueCenterConstraint?.constant = 8
        
        UIView.animate(withDuration: 0.4) {
            self.formValueLabel.alpha = 1
            self.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.titleLabel.alpha = 1
            }
        }
    }
    
    func resetTitle() {
        formValueLabel.textColor = .gray
        formValueLabel.alpha = 0
        formValueLabel.text = formFieldViewType.rawValue
        
        self.formValueCenterConstraint?.constant = 1
        
        UIView.animate(withDuration: 0.4) {
            self.formValueLabel.alpha = 1
            self.titleLabel.alpha = 0
            self.layoutIfNeeded()
        }
    }
}
