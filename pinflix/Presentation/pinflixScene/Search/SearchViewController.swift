//
//  SearchViewController.swift
//  pinflix
//
//  Created by Panji Yoga on 13/03/23.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {
    @IBOutlet weak var searchMovieTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        initObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.searchMovieTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.searchMovieTextField.resignFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func configureViews() {
        configureSearchTextField()
        configureCancelButton()
        configureCollectionView()
    }
    
    private func initObserver() {
        viewModel.movies.drive(onNext: { [weak self] movie in
            guard let movie else { return }
            if movie.isEmpty {
                self?.movieListCollectionView.setBackground(imageName: "icon_empty_items", messageImage: "Not Found")
            } else {
                self?.movieListCollectionView.clearBackground()
            }
            self?.movieListCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func configureSearchTextField() {
        guard let grayTabBarColor = UIColor(named: "GrayTabBarColor") else { return }
        searchMovieTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: grayTabBarColor]
        )
        searchMovieTextField.clearButtonMode = .whileEditing
        searchMovieTextField.delegate = self
        searchMovieTextField.rx.text
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                self.viewModel.search(query: value)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureCancelButton() {
        cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped), for: .touchUpInside)
    }
    
    private func configureCollectionView() {
        movieListCollectionView.register(UINib(nibName: "CardMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardMovieCollectionViewCell")
        movieListCollectionView.dataSource = self
        movieListCollectionView.delegate = self
    }
    
    // MARK: - action
    @objc
    private func cancelButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movieCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = movieListCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
        let movie = viewModel.movie(at: indexPath.row)
        cell.configureContent(content: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        let detailViewModel = DetailViewModel(detailUseCase: Injection().provideDetailUseCase())
        detailViewController.viewModel = detailViewModel
        detailViewController.id = viewModel.movie(at: indexPath.row)?.id
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 115, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
