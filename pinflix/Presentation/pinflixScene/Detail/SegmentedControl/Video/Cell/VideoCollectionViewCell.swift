//
//  VideoCollectionViewCell.swift
//  pinflix
//
//  Created by Panji Yoga on 16/03/23.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    private func configureViews() {
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor(named: "GrayTabBarColor")?.cgColor
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.masksToBounds = true    }
    
    func configureContent(content: Videos.Result?) {
        self.nameLabel.text = content?.name
    }
}
