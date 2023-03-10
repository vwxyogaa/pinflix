//
//  CardMovieCollectionViewCell.swift
//  pinflix
//
//  Created by Panji Yoga on 10/03/23.
//

import UIKit

class CardMovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }

    private func configureViews() {
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.masksToBounds = true
    }
}
