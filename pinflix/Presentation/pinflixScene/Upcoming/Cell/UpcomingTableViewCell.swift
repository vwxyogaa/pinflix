//
//  UpcomingTableViewCell.swift
//  pinflix
//
//  Created by Panji Yoga on 14/03/23.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var backdropPathImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureContent(upcoming: TMDB.Results?) {
        self.releaseDateLabel.text = upcoming?.releaseDate
        self.titleLabel.text = upcoming?.title
        self.overviewLabel.text = upcoming?.overview
        let imageUrl = "https://image.tmdb.org/t/p/original\(upcoming?.backdropPath ?? "")"
        if upcoming?.posterPath == nil {
            self.backdropPathImageView.backgroundColor = .black
        } else {
            self.backdropPathImageView.loadImage(uri: imageUrl)
        }
        if let voteAverageDecimal = upcoming?.voteAverage {
            let voteAverage = (String(format: "%.1f", voteAverageDecimal))
            self.categoriesLabel.text = "⭐️\(voteAverage) • \(upcoming?.popularity ?? 0) • \(upcoming?.originalLanguage ?? "")"
        }
    }
}
