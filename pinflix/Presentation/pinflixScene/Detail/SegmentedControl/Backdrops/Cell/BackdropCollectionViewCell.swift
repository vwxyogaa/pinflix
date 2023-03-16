//
//  BackdropCollectionViewCell.swift
//  pinflix
//
//  Created by Panji Yoga on 16/03/23.
//

import UIKit

class BackdropCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backdropImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }

    private func configureViews() {
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.masksToBounds = true
    }
    
    func configureContentBackdrops(backdrop: Images.Backdrop?) {
        let imageUrl = "https://image.tmdb.org/t/p/original\(backdrop?.filePath ?? "")"
        self.backdropImageView.loadImage(uri: imageUrl)
    }
}
