//
//  VideoViewController.swift
//  pinflix
//
//  Created by Panji Yoga on 16/03/23.
//

import UIKit
import AVKit

class VideoViewController: UIViewController {
    @IBOutlet weak var videoCollectionView: UICollectionView!
    
    var mediaVideos = [Videos.Result]()
    var avPlayerController = AVPlayerViewController()
    var playerView: AVPlayer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    // MARK: - Helpers
    private func configureCollectionView() {
        self.videoCollectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionViewCell")
        self.videoCollectionView.dataSource = self
        self.videoCollectionView.delegate = self
    }
    
    private func videoUrl(key: String?){
        let url = URL(string: "https://www.youtube.com/watch?v=\(key ?? "")")!
        self.playerView = AVPlayer(url: url)
        playerView?.play()
        avPlayerController.player = playerView
        present(avPlayerController, animated: true, completion: nil)
    }
    
    func reloadsCollectionView(){
        videoCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension VideoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = videoCollectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as? VideoCollectionViewCell else { return UICollectionViewCell() }
        let video = mediaVideos[indexPath.row]
        cell.configureContent(content: video)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let key = mediaVideos[indexPath.row].key
        self.videoUrl(key: key)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
