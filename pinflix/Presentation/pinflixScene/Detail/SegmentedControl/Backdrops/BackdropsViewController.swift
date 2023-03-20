//
//  BackdropsViewController.swift
//  pinflix
//
//  Created by Panji Yoga on 16/03/23.
//

import UIKit

class BackdropsViewController: UIViewController {
    @IBOutlet weak var backdropsCollectionView: UICollectionView!
    
    var mediaBackdrops = [Images.Backdrop]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    // MARK: - Helpers
    private func configureCollectionView() {
        backdropsCollectionView.register(UINib(nibName: "BackdropCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BackdropCollectionViewCell")
        backdropsCollectionView.dataSource = self
        backdropsCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension BackdropsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaBackdrops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = backdropsCollectionView.dequeueReusableCell(withReuseIdentifier: "BackdropCollectionViewCell", for: indexPath) as? BackdropCollectionViewCell else { return UICollectionViewCell() }
        let backdrop = mediaBackdrops[indexPath.row]
        cell.configureContentBackdrops(backdrop: backdrop)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = backdropsCollectionView.frame.width / 1.4
        let height = backdropsCollectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
