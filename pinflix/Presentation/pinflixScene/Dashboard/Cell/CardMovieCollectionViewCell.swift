//
//  CardMovieCollectionViewCell.swift
//  pinflix
//
//  Created by Panji Yoga on 10/03/23.
//

import UIKit

class CardMovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }

    private func configureViews() {
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.masksToBounds = true
    }
    
    func configureContentDashboard(content: TMDB.Results?) {
        self.contentImageView.loadImage(uri: content?.posterPathImage)
    }
    
    func configureContentRecommendations(content: Recommendations.Result?) {
        self.contentImageView.loadImage(uri: content?.posterPathImage)
    }
    
    func configureContentPosters(poster: Images.Backdrop?) {
        self.contentImageView.loadImage(uri: poster?.filePathImage)
    }
}
