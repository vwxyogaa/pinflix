//
//  SearchViewController.swift
//  pinflix
//
//  Created by Panji Yoga on 13/03/23.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchMovieTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
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
    
    private func configureViews() {
        configureSearchTextField()
        configureCancelButton()
        configureCollectionView()
    }
    
    private func configureSearchTextField() {
        guard let grayTabBarColor = UIColor(named: "GrayTabBarColor") else { return }
        searchMovieTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: grayTabBarColor]
        )
        searchMovieTextField.clearButtonMode = .whileEditing
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

// MARK: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = movieListCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
        return cell
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
