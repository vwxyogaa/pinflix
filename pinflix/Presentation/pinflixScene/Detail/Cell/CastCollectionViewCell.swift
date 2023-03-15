//
//  CastCollectionViewCell.swift
//  pinflix
//
//  Created by Panji Yoga on 15/03/23.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profilePathImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    private func configureViews() {
        self.profilePathImageView.layer.cornerRadius = 10
        self.profilePathImageView.layer.masksToBounds = true
    }
    
    func configureContent(casts: Credits.Cast?) {
        let imageUrl = "https://image.tmdb.org/t/p/original\(casts?.profilePath ?? "")"
        if casts?.profilePath == nil {
            self.profilePathImageView.backgroundColor = .black
        } else {
            self.profilePathImageView.loadImage(uri: imageUrl)
        }
        self.nameLabel.text = casts?.name
        self.characterLabel.text = casts?.character
    }
}
