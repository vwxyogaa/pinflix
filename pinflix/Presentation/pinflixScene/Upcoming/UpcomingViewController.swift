//
//  UpcomingViewController.swift
//  pinflix
//
//  Created by Panji Yoga on 10/03/23.
//

import UIKit
import RxSwift

class UpcomingViewController: UIViewController {
    @IBOutlet weak var upcomingTableView: UITableView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    private let disposeBag = DisposeBag()
    var viewModel: UpcomingViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        initObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Helpers
    private func configureViews() {
        configureTableView()
        upcomingTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.upcomingTableView.bounds.size.width, height: 0.01))
    }
    
    private func initObserver() {
        viewModel.upcomings.drive(onNext: { [weak self] _ in
            self?.upcomingTableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.drive(onNext: { [weak self] isLoading in
            self?.manageLoadingActivity(isLoading: isLoading)
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.drive(onNext: { [weak self] errorMessage in
            self?.showErrorSnackBar(message: errorMessage)
        }).disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        upcomingTableView.register(UINib(nibName: "UpcomingTableViewCell", bundle: nil), forCellReuseIdentifier: "UpcomingTableViewCell")
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        upcomingTableView.refreshControl = refreshControl
        if #available(iOS 15.0, *) {
            upcomingTableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        upcomingTableView.dataSource = self
        upcomingTableView.delegate = self
    }
    
    // MARK: - Action
    @objc
    private func refreshData() {
        self.refreshControl.endRefreshing()
        self.viewModel.refresh()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.upcomingCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = upcomingTableView.dequeueReusableCell(withIdentifier: "UpcomingTableViewCell", for: indexPath) as? UpcomingTableViewCell else { return UITableViewCell() }
        let upcoming = viewModel.upcoming(at: indexPath.row)
        cell.configureContent(upcoming: upcoming)
        viewModel.loadMovieNextPage(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        let detailViewModel = DetailViewModel(detailUseCase: Injection().provideDetailUseCase())
        detailViewController.viewModel = detailViewModel
        detailViewController.id = viewModel.upcoming(at: indexPath.row)?.id
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
        label.text = "Upcoming"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        headerView.backgroundColor = .black
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
