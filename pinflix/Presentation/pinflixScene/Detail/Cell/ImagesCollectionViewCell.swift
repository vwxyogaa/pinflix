//
//  ImagesCollectionViewCell.swift
//  pinflix
//
//  Created by Panji Yoga on 15/03/23.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageCollectionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    private func configureViews() {
        self.imageCollectionImageView.layer.cornerRadius = 10
        self.imageCollectionImageView.layer.masksToBounds = true
    }

    func configureContent(backdrop: Images.Backdrop?) {
        let imageUrl = "https://image.tmdb.org/t/p/original\(backdrop?.filePath ?? "")"
        if backdrop?.filePath == nil {
            self.imageCollectionImageView.backgroundColor = .black
        } else {
            self.imageCollectionImageView.loadImage(uri: imageUrl)
        }
    }
}
