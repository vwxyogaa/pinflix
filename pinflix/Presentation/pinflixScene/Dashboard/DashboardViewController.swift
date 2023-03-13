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
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    var viewModel: DashboardViewModel!
    
    // MARK: - LifeCycle
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
        configureSearchTextField()
        configureCollectionViews()
    }
    
    private func initObserver() {
        viewModel.nowPlayings.drive(onNext: { [weak self] nowPlaying in
            self?.nowPlayingCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.populars.drive(onNext: { [weak self] popular in
            self?.popularCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func configureSearchTextField() {
        guard let grayTabBarColor = UIColor(named: "GrayTabBarColor") else { return }
        searchMovieTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: grayTabBarColor]
        )
    }
    
    private func configureCollectionViews() {
        nowPlayingCollectionView.register(UINib(nibName: "NowPlayingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NowPlayingCollectionViewCell")
        nowPlayingCollectionView.dataSource = self
        nowPlayingCollectionView.delegate = self
        
        popularCollectionView.register(UINib(nibName: "CardMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardMovieCollectionViewCell")
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self
        
        topRatedCollectionView.register(UINib(nibName: "CardMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardMovieCollectionViewCell")
        topRatedCollectionView.dataSource = self
        topRatedCollectionView.delegate = self
        
        latestCollectionView.register(UINib(nibName: "CardMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardMovieCollectionViewCell")
        latestCollectionView.dataSource = self
        latestCollectionView.delegate = self
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
            return 10
        case latestCollectionView:
            return 10
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
            return cell
        case popularCollectionView:
            guard let cell = popularCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            let popular = viewModel.popular(at: indexPath.row)
            cell.configureContent(content: popular)
            return cell
        case topRatedCollectionView:
            guard let cell = popularCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case latestCollectionView:
            guard let cell = popularCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case nowPlayingCollectionView:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        case popularCollectionView:
            return CGSize(width: 100, height: 150)
        case topRatedCollectionView:
            return CGSize(width: 100, height: 150)
        case latestCollectionView:
            return CGSize(width: 100, height: 150)
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
        case latestCollectionView:
            return 8
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case nowPlayingCollectionView:
            return 0
        case popularCollectionView:
            return 0
        case topRatedCollectionView:
            return 0
        case latestCollectionView:
            return 0
        default:
            return 0
        }
    }
}
