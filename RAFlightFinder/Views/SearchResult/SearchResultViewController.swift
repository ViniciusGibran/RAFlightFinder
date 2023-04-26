import Combine
import UIKit

class SearchResultViewController: UIViewController {
    
    // MARK: Propertis
    private let viewModel: SearchResultViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appBlue
        return view
    }()
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(SearchResultTableViewCell.self))
        tableView.backgroundColor = .defaultBackround
        tableView.separatorStyle = .none
        tableView.rowHeight = 170
        tableView.dataSource = self
        
        return tableView
    }()
    
    // MARK: Lifecycle
    init(viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFlightSearch()
    }
    
    
    // MARK: UI
    private func setupUI() {
        // self
        view.backgroundColor = .defaultBackround
            
        setupHeaderView()
        setupTableView()
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.pinTop()
        headerView.pinLeft()
        headerView.pinRight()
        headerView.constraintHeight(50)
        
        // add header label
        let headerLabel = UILabel()
        headerLabel.font = .systemFont(ofSize: 18, weight: .bold)
        headerLabel.textColor = .appYellow
        headerLabel.text = "Flights Found"
        headerLabel.textAlignment = .left
        
        headerView.addSubview(headerLabel)
        headerLabel.pinLeft(20)
        headerLabel.centerVertically()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.pinTop(15, target: headerView)
        tableView.pinLeft()
        tableView.pinRight()
        tableView.pinBottom(20)
    }
    
    // MARK: Bidings
    private func bindViewModel() {
        viewModel.searchFetchResulSubject
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SearchResultTableViewCell.classForCoder()), for: indexPath) as! SearchResultTableViewCell
        cell.configure(with: viewModel.flights[indexPath.row])
        return cell
    }
}
