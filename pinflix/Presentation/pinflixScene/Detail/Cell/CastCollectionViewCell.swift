//
//  CastCollectionViewCell.swift
//  pinflix
//
//  Created by Panji Yoga on 15/03/23.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profilePathImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    private func configureViews() {
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor(named: "GrayTabBarColor")?.cgColor
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.masksToBounds = true
    }
    
    func configureContent(casts: Credits.Cast?) {
        if let profilePathImage = casts?.profilePathImage, !profilePathImage.isEmpty {
            self.profilePathImageView.loadImage(uri: profilePathImage)
        } else {
            self.profilePathImageView.backgroundColor = .black
        }
        self.nameLabel.text = casts?.name
        self.characterLabel.text = casts?.character
    }
}
