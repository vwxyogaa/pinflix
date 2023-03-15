//
//  DetailViewController.swift
//  pinflix
//
//  Created by Panji Yoga on 13/03/23.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var companiesProdLabel: UILabel!
    @IBOutlet weak var countriesProdLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    var viewModel: DetailViewModel!
    var id: Int?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
        initObserver()
        configureData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Helpers
    private func configureButton() {
        self.backButton.layer.cornerRadius = backButton.frame.height / 2
        self.backButton.layer.masksToBounds = true
        self.backButton.setTitle("", for: .normal)
        self.backButton.addTarget(self, action: #selector(self.backButtonTapped), for: .touchUpInside)
    }
    
    private func configureData() {
        if let id = id {
            viewModel.getDetail(id: id)
        }
    }
    
    private func initObserver() {
        viewModel.movie.drive(onNext: { [weak self] movie in
            self?.configureContent(movie: movie)
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.drive(onNext: { [weak self] isLoading in
            self?.manageLoadingActivity(isLoading: isLoading)
        }).disposed(by: disposeBag)
    }
    
    private func configureContent(movie: Movie?) {
        let imageUrl = "https://image.tmdb.org/t/p/original\(movie?.backdropPath ?? "")"
        if movie?.backdropPath == nil {
            self.backdropImageView.backgroundColor = .black
        } else {
            self.backdropImageView.loadImage(uri: imageUrl)
        }
        self.titleLabel.text = movie?.title
        self.genresLabel.text = movie?.genres.compactMap({$0.name}).joined(separator: ", ")
        if let voteAverageDecimal = movie?.voteAverage {
            let voteAverage = (String(format: "%.1f", voteAverageDecimal))
            self.categoriesLabel.text = "\(movie?.releaseDate ?? "") • ⭐️\(voteAverage) • \(movie?.popularity ?? 0)"
        }
        if let tagline = movie?.tagline, !tagline.isEmpty {
            self.taglineLabel.text = "#\(tagline)".uppercased()
        } else {
            self.taglineLabel.text = "-"
        }
        self.overviewLabel.text = movie?.overview
        self.homepageLabel.text = movie?.homepage
        self.companiesProdLabel.text = "Production Companies: \(movie?.productionCompanies.compactMap({$0.name}).joined(separator: ", ") ?? "-")"
        self.countriesProdLabel.text = "Production Countries: \(movie?.productionCountries.compactMap({$0.name}).joined(separator: ", ") ?? "-")"
    }
    
    // MARK: - Action
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
