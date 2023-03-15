//
//  ReviewsCollectionViewCell.swift
//  pinflix
//
//  Created by Panji Yoga on 15/03/23.
//

import UIKit

class ReviewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarPathImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }

    private func configureViews() {
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor(named: "GrayTabBarColor")?.cgColor
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.masksToBounds = true
        
        self.avatarPathImageView.layer.cornerRadius = avatarPathImageView.frame.height / 2
        self.avatarPathImageView.layer.masksToBounds = true
    }
    
    func configureContent(review: Reviews.Result?) {
        let imageUrl = "https://image.tmdb.org/t/p/original\(review?.authorDetails.avatarPath ?? "")"
        if review?.authorDetails.avatarPath == nil {
            self.avatarPathImageView.backgroundColor = .black
        } else {
            self.avatarPathImageView.loadImage(uri: imageUrl)
        }
        self.authorLabel.text = "A Review by \(review?.author ?? "")"
        let createdAt = Utils.convertDateValidToDesc(review?.createdAt ?? "")
        self.createdAtLabel.text = "Written by \(review?.author ?? "") on \(createdAt)"
        self.contentLabel.text = review?.content
    }
}
