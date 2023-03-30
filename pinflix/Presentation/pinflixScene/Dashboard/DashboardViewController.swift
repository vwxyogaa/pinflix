//
//  DashboardViewController.swift
//  pinflix
//
//  Created by Panji Yoga on 10/03/23.
//

import UIKit
import RxSwift

class DashboardViewController: UIViewController {
    @IBOutlet weak var searchMovieTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var nowPlayingCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionViewHeight: NSLayoutConstraint!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    private let disposeBag = DisposeBag()
    var viewModel: DashboardViewModel!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        initObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nowPlayingCollectionViewHeight.constant = nowPlayingCollectionView.frame.height
        popularCollectionViewHeight.constant = popularCollectionView.frame.height
        topRatedCollectionViewHeight.constant = topRatedCollectionView.frame.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.searchMovieTextField.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.searchMovieTextField.resignFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Helpers
    private func configureViews() {
        configureSearchTextField()
        configureScrollView()
        configureCollectionViews()
    }
    
    private func initObserver() {
        viewModel.isLoading.drive(onNext: { [weak self] isLoading in
            self?.manageLoadingActivity(isLoading: isLoading)
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.drive(onNext: { [weak self] errorMessage in
            self?.showErrorSnackBar(message: errorMessage)
        }).disposed(by: disposeBag)
        
        viewModel.nowPlayings.drive(onNext: { [weak self] _ in
            self?.nowPlayingCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.populars.drive(onNext: { [weak self] _ in
            self?.popularCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.topRateds.drive(onNext: { [weak self] _ in
            self?.topRatedCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func configureSearchTextField() {
        guard let grayTabBarColor = UIColor(named: "GrayTabBarColor") else { return }
        searchMovieTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: grayTabBarColor]
        )
        searchMovieTextField.delegate = self
    }
    
    private func configureScrollView() {
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    private func configureCollectionViews() {
        nowPlayingCollectionView.register(UINib(nibName: "NowPlayingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NowPlayingCollectionViewCell")
        nowPlayingCollectionView.decelerationRate = .fast
        nowPlayingCollectionView.dataSource = self
        nowPlayingCollectionView.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.nowPlayingCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
                                                      at: .centeredHorizontally,
                                                      animated: true)
        }
        
        popularCollectionView.register(UINib(nibName: "CardMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardMovieCollectionViewCell")
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self
        
        topRatedCollectionView.register(UINib(nibName: "CardMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardMovieCollectionViewCell")
        topRatedCollectionView.dataSource = self
        topRatedCollectionView.delegate = self
    }
    
    // MARK: - Action
    @objc
    private func refreshData() {
        self.refreshControl.endRefreshing()
        self.viewModel.refresh()
    }
}

// MARK: - UITextFieldDelegate
extension DashboardViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let searchViewController = SearchViewController()
        let searchViewModel = SearchViewModel(searchUseCase: Injection().provideSearchUseCase())
        searchViewController.viewModel = searchViewModel
        searchViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchViewController, animated: true)
        return true
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case nowPlayingCollectionView:
            return viewModel.nowPlayingCount
        case popularCollectionView:
            return viewModel.popularCount
        case topRatedCollectionView:
            return viewModel.topRatedCount
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case nowPlayingCollectionView:
            guard let cell = nowPlayingCollectionView.dequeueReusableCell(withReuseIdentifier: "NowPlayingCollectionViewCell", for: indexPath) as? NowPlayingCollectionViewCell else { return UICollectionViewCell() }
            let nowPlaying = viewModel.nowPlaying(at: indexPath.row)
            cell.configureContent(nowPlaying: nowPlaying)
            viewModel.loadNowPlayingNextPage(index: indexPath.row)
            return cell
        case popularCollectionView:
            guard let cell = popularCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            let popular = viewModel.popular(at: indexPath.row)
            cell.configureContentDashboard(content: popular)
            viewModel.loadPopularNextPage(index: indexPath.row)
            return cell
        case topRatedCollectionView:
            guard let cell = popularCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            let topRated = viewModel.topRated(at: indexPath.row)
            cell.configureContentDashboard(content: topRated)
            viewModel.loadTopRatedNextPage(index: indexPath.row)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case nowPlayingCollectionView:
            let detailViewController = DetailViewController()
            let detailViewModel = DetailViewModel(detailUseCase: Injection().provideDetailUseCase())
            detailViewController.viewModel = detailViewModel
            detailViewController.id = viewModel.nowPlaying(at: indexPath.row)?.id
            detailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailViewController, animated: true)
        case popularCollectionView:
            let detailViewController = DetailViewController()
            let detailViewModel = DetailViewModel(detailUseCase: Injection().provideDetailUseCase())
            detailViewController.viewModel = detailViewModel
            detailViewController.id = viewModel.popular(at: indexPath.row)?.id
            detailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailViewController, animated: true)
        case topRatedCollectionView:
            let detailViewController = DetailViewController()
            let detailViewModel = DetailViewModel(detailUseCase: Injection().provideDetailUseCase())
            detailViewController.viewModel = detailViewModel
            detailViewController.id = viewModel.topRated(at: indexPath.row)?.id
            detailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailViewController, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case nowPlayingCollectionView:
            let width = nowPlayingCollectionView.frame.width * 0.9
            let height = nowPlayingCollectionView.frame.height
            return CGSize(width: width, height: height)
        case popularCollectionView:
            let width = popularCollectionView.frame.width / 3.6
            let height = popularCollectionView.frame.height
            return CGSize(width: width, height: height)
        case topRatedCollectionView:
            let width = topRatedCollectionView.frame.width / 3.6
            let height = topRatedCollectionView.frame.height
            return CGSize(width: width, height: height)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case nowPlayingCollectionView:
            return 0
        case popularCollectionView:
            return 8
        case topRatedCollectionView:
            return 8
        default:
            return 0
        }
    }
}
