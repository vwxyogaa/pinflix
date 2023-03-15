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
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var companiesProdLabel: UILabel!
    @IBOutlet weak var countriesProdLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    @IBOutlet weak var recommendationsCollectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    var viewModel: DetailViewModel!
    var id: Int?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
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
    private func configureViews() {
        configureButton()
        configureCollectionView()
    }
    
    private func configureButton() {
        self.backButton.layer.cornerRadius = backButton.frame.height / 2
        self.backButton.layer.masksToBounds = true
        self.backButton.setTitle("", for: .normal)
        self.backButton.addTarget(self, action: #selector(self.backButtonTapped), for: .touchUpInside)
    }
    
    private func configureCollectionView() {
        self.castCollectionView.register(UINib(nibName: "CastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CastCollectionViewCell")
        self.castCollectionView.dataSource = self
        self.castCollectionView.delegate = self
        
        self.reviewsCollectionView.register(UINib(nibName: "ReviewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReviewsCollectionViewCell")
        self.reviewsCollectionView.dataSource = self
        self.reviewsCollectionView.delegate = self
        
        self.recommendationsCollectionView.register(UINib(nibName: "CardMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardMovieCollectionViewCell")
        self.recommendationsCollectionView.dataSource = self
        self.recommendationsCollectionView.delegate = self
    }
    
    private func initObserver() {
        viewModel.movie.drive(onNext: { [weak self] movie in
            self?.configureContent(movie: movie)
        }).disposed(by: disposeBag)
        
        viewModel.casts.drive(onNext: { [weak self] _ in
            self?.castCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.reviews.drive(onNext: { [weak self] _ in
            self?.reviewsCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.recommendations.drive(onNext: { [weak self] _ in
            self?.recommendationsCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.drive(onNext: { [weak self] isLoading in
            self?.manageLoadingActivity(isLoading: isLoading)
        }).disposed(by: disposeBag)
    }
    
    private func configureData() {
        if let id = id {
            viewModel.getDetail(id: id)
            viewModel.getCredits(id: id)
            viewModel.getReviews(id: id)
            viewModel.getRecommendations(id: id)
        }
    }
    
    private func configureContent(movie: Movie?) {
        let imageUrl = "https://image.tmdb.org/t/p/original\(movie?.backdropPath ?? "")"
        if movie?.backdropPath == nil {
            self.backdropImageView.backgroundColor = .black
        } else {
            self.backdropImageView.loadImage(uri: imageUrl)
        }
        self.titleLabel.text = movie?.title
        if let voteAverageDecimal = movie?.voteAverage {
            let voteAverage = (String(format: "%.1f", voteAverageDecimal))
            let releaseDate = Utils.humanDate(movie?.releaseDate ?? "")
            let runtime = Utils.minutesToHoursAndMinutes(movie?.runtime ?? 0)
            self.categoriesLabel.text = "\(releaseDate) • ⭐️\(voteAverage) • \(runtime.hours)h \(runtime.leftMinutes)m"
        }
        self.genresLabel.text = movie?.genres.compactMap({$0.name}).joined(separator: ", ")
        if let tagline = movie?.tagline, !tagline.isEmpty {
            self.taglineLabel.text = "#\(tagline)".uppercased()
        } else {
            self.taglineLabel.text = "-"
        }
        self.overviewLabel.text = movie?.overview
        self.companiesProdLabel.text = "Production Companies: \(movie?.productionCompanies.compactMap({$0.name}).joined(separator: ", ") ?? "-")"
        self.countriesProdLabel.text = "Production Countries: \(movie?.productionCountries.compactMap({$0.name}).joined(separator: ", ") ?? "-")"
    }
    
    // MARK: - Action
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case castCollectionView:
            return viewModel.castCount
        case reviewsCollectionView:
            return viewModel.reviewCount
        case recommendationsCollectionView:
            return viewModel.recommendationCount
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case castCollectionView:
            guard let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as? CastCollectionViewCell else { return UICollectionViewCell() }
            let cast = viewModel.cast(at: indexPath.row)
            cell.configureContent(casts: cast)
            return cell
        case reviewsCollectionView:
            guard let cell = reviewsCollectionView.dequeueReusableCell(withReuseIdentifier: "ReviewsCollectionViewCell", for: indexPath) as? ReviewsCollectionViewCell else { return UICollectionViewCell() }
            let review = viewModel.review(at: indexPath.row)
            cell.configureContent(review: review)
            return cell
        case recommendationsCollectionView:
            guard let cell = recommendationsCollectionView.dequeueReusableCell(withReuseIdentifier: "CardMovieCollectionViewCell", for: indexPath) as? CardMovieCollectionViewCell else { return UICollectionViewCell() }
            let recommendation = viewModel.recommendation(at: indexPath.row)
            cell.configureContentRecommendations(content: recommendation)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case recommendationsCollectionView:
            let detailViewController = DetailViewController()
            let detailViewModel = DetailViewModel(detailUseCase: Injection().provideDetailUseCase())
            detailViewController.viewModel = detailViewModel
            detailViewController.id = viewModel.recommendation(at: indexPath.row)?.id
            detailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailViewController, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case castCollectionView:
            return CGSize(width: 100, height: 172)
        case reviewsCollectionView:
            return CGSize(width: 361, height: 129)
        case recommendationsCollectionView:
            return CGSize(width: 100, height: 150)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case castCollectionView:
            return 8
        case reviewsCollectionView:
            return 8
        case recommendationsCollectionView:
            return 8
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
