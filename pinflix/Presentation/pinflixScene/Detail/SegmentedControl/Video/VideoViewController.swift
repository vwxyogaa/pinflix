//
//  VideoViewController.swift
//  pinflix
//
//  Created by Panji Yoga on 16/03/23.
//

import UIKit
import AVKit

class VideoViewController: UIViewController {
    @IBOutlet weak var videosCollectionView: UICollectionView!
    
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
        self.videosCollectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionViewCell")
        self.videosCollectionView.dataSource = self
        self.videosCollectionView.delegate = self
    }
    
    private func videoUrl(key: String?){
        let url = URL(string: "https://www.youtube.com/watch?v=\(key ?? "")")!
        self.playerView = AVPlayer(url: url)
        playerView?.play()
        avPlayerController.player = playerView
        present(avPlayerController, animated: true, completion: nil)
    }
    
    func reloadsCollectionView(){
        videosCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension VideoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = videosCollectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as? VideoCollectionViewCell else { return UICollectionViewCell() }
        let video = mediaVideos[indexPath.row]
        cell.configureContent(content: video)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let key = mediaVideos[indexPath.row].key
        self.videoUrl(key: key)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = videosCollectionView.frame.width / 1.44
        let height = videosCollectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
