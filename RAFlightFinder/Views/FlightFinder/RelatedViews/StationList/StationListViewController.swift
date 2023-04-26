import Combine
import UIKit

class StationListViewController: UIViewController {
    // MARK: Properties
    
    private var viewModel: StationListViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var formViewType: FormFieldView.FormFieldViewType
    
    // MARK: UI
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.backgroundColor = .defaultBackround
        tableView.register(StationListTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(StationListTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 3
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "Enter city or airport"
        
        return textField
    }()
    
    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView(image: .init(systemName: "magnifyingglass"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        return imageView
    }()
    
    // MARK: Lifecycle
    
    init(viewModel: StationListViewModel, formViewType: FormFieldView.FormFieldViewType) {
        self.viewModel = viewModel
        self.formViewType = formViewType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .defaultBackround
        
        setupUI()
        
        bindViewModel()
        bindSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchStations()
    }
    
    // MARK: Private
    
    private func bindViewModel() {
        viewModel.searchText
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.stationListResponseSubject
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func bindSubviews() {
        searchTextField.publisher(for: \.text)
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.value, on: viewModel.searchText)
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        setupSearchTextField()
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.pinTop(15, target: searchTextField)
        tableView.pinLeft(15)
        tableView.pinRight(15)
        tableView.pinBottom(20)
    }
    
    private func setupSearchTextField() {
        view.addSubview(searchTextField)
        searchTextField.pinTop(20)
        searchTextField.pinLeft(15)
        searchTextField.pinRight(15)
        searchTextField.constraintHeight(60)
        
        setupSearchIconImageView()
    }
    
    private func setupSearchIconImageView() {
        searchTextField.addSubview(searchIconImageView)
        searchIconImageView.centerVertically(inRelationTo: searchTextField)
        searchIconImageView.pinLeft(10)
        searchIconImageView.constraintHeight(20)
        searchIconImageView.constraintWidth(20)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension StationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(StationListTableViewCell.classForCoder()), for: indexPath) as! StationListTableViewCell
        cell.configure(with: viewModel.filteredStations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let headerTitleLabel = UILabel()
        headerTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        headerTitleLabel.textColor = .appBlue
        headerTitleLabel.text = "All destination"
        
        headerView.addSubview(headerTitleLabel)
        headerTitleLabel.pinLeft(15)
        headerTitleLabel.centerVertically()
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStation = viewModel.filteredStations[indexPath.row]
        self.viewModel.formFieldSelectedStationSubject?.send((station: selectedStation, formType: self.formViewType))
        dismiss(animated: true)
    }
}
