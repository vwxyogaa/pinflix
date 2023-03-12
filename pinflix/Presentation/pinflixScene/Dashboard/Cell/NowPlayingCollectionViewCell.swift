//
//  NowPlayingCollectionViewCell.swift
//  pinflix
//
//  Created by Panji Yoga on 10/03/23.
//

import UIKit

class NowPlayingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nowPlayingImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    private func configureViews() {
        self.containerView.layer.cornerRadius = 20
        self.containerView.layer.masksToBounds = true
    }
    
    func configureContent(nowPlaying: TMDB.Results?) {
        let imageUrl = "https://image.tmdb.org/t/p/original\(nowPlaying?.posterPath ?? "")"
        self.nowPlayingImageView.loadImage(uri: imageUrl)
    }
}
