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
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var companiesProdLabel: UILabel!
    @IBOutlet weak var countriesProdLabel: UILabel!
    @IBOutlet weak var castStackView: UIStackView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var castCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewsStackView: UIStackView!
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    @IBOutlet weak var reviewsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var recommendationsStackView: UIStackView!
    @IBOutlet weak var recommendationsCollectionView: UICollectionView!
    @IBOutlet weak var recommendationsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mediaSegmentedControl: CustomSegmentedControl!
    @IBOutlet weak var contentMediaView: UIView!
    
    private lazy var videoViewController = VideoViewController()
    private lazy var backdropsViewController = BackdropsViewController()
    private lazy var postersViewController = PostersViewController()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        castCollectionViewHeight.constant = castCollectionView.frame.height
        reviewsCollectionViewHeight.constant = reviewsCollectionView.frame.height
        recommendationsCollectionViewHeight.constant = recommendationsCollectionView.frame.height
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
        configureStatsSegmentedController()
    }
    
    private func configureButton() {
        self.backButton.layer.cornerRadius = backButton.frame.height / 2
        self.backButton.layer.masksToBounds = true
        self.backButton.setTitle("", for: .normal)
        self.backButton.addTarget(self, action: #selector(self.backButtonTapped), for: .touchUpInside)
        
        self.saveButton.layer.cornerRadius = backButton.frame.height / 2
        self.saveButton.layer.masksToBounds = true
        self.saveButton.setTitle("", for: .normal)
        self.saveButton.tintColor = .white
        self.saveButton.addTarget(self, action: #selector(self.saveButtonTapped), for: .touchUpInside)
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
    
    private func configureStatsSegmentedController() {
        mediaSegmentedControl.delegate = self
        mediaSegmentedControl.setButtonTitles(buttonTitles: ["Video", "Backdrops", "Posters"])
        mediaSegmentedControl.setIndex(index: 0)
        mediaSegmentedControl.backgroundColor = UIColor(named: "GrayBgColor")
        mediaSegmentedControl.selectorViewColor = .white
        mediaSegmentedControl.selectorTextColor = .white
        mediaSegmentedControl.textColor = UIColor(named: "GrayTabBarColor") ?? .lightGray
    }
    
    private func initObserver() {
        viewModel.movie.drive(onNext: { [weak self] movie in
            self?.configureContent(movie: movie)
        }).disposed(by: disposeBag)
        
        viewModel.casts.drive(onNext: { [weak self] cast in
            if let cast = cast, !cast.isEmpty {
                self?.castStackView.isHidden = false
            } else {
                self?.castStackView.isHidden = true
            }
            self?.castCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.reviews.drive(onNext: { [weak self] review in
            if let review = review, !review.isEmpty {
                self?.reviewsStackView.isHidden = false
            } else {
                self?.reviewsStackView.isHidden = true
            }
            self?.reviewsCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.recommendations.drive(onNext: { [weak self] recommendation in
            if let recommendation = recommendation, !recommendation.isEmpty {
                self?.recommendationsStackView.isHidden = false
            } else {
                self?.recommendationsStackView.isHidden = true
            }
            self?.recommendationsCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.videos.drive(onNext: { [weak self] video in
            if let video {
                self?.videoViewController.mediaVideos = video
                self?.videoViewController.reloadsCollectionView()
            }
        }).disposed(by: disposeBag)
        
        viewModel.backdrops.drive(onNext: { [weak self] backdrop in
            if let backdrop {
                self?.backdropsViewController.mediaBackdrops = backdrop
            }
        }).disposed(by: disposeBag)
        
        viewModel.posters.drive(onNext: { [weak self] poster in
            if let poster {
                self?.postersViewController.mediaPosters = poster
            }
        }).disposed(by: disposeBag)
        
        viewModel.isSaved.drive(onNext: { [weak self] isSaved in
            self?.updateSavedButton(isSaved)
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.drive(onNext: { [weak self] isLoading in
            self?.manageLoadingActivity(isLoading: isLoading)
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.drive(onNext: { [weak self] errorMessage in
            self?.showErrorSnackBar(message: errorMessage)
        }).disposed(by: disposeBag)
    }
    
    private func configureData() {
        if let id = id {
            viewModel.getDetail(id: id)
            viewModel.getCredits(id: id)
            viewModel.getReviews(id: id)
            viewModel.getRecommendations(id: id)
            viewModel.getImages(id: id)
            viewModel.getVideos(id: id)
            viewModel.checkMovieInCollection(id: id)
        }
    }
    
    private func configureContent(movie: Movie?) {
        let imageUrl = "https://image.tmdb.org/t/p/original\(movie?.backdropPath ?? "")"
        if movie?.backdropPath == nil {
            self.backdropImageView.backgroundColor = .black
        } else {
            self.backdropImageView.loadImage(uri: imageUrl)
        }
        let year = Utils.convertDateToYearOnly(movie?.releaseDate ?? "-")
        self.titleLabel.text = "\(movie?.title ?? "") (\(year))"
        let voteAverageDecimal = movie?.voteAverage ?? 0
        let voteAverage = (String(format: "%.1f", voteAverageDecimal))
        let releaseDate = Utils.convertDateSimple(movie?.releaseDate ?? "-")
        let runtime = Utils.minutesToHoursAndMinutes(movie?.runtime ?? 0)
        self.categoriesLabel.text = "\(releaseDate) • ⭐️\(voteAverage) • \(runtime.hours)h \(runtime.leftMinutes)m"
        self.genresLabel.text = movie?.genres?.compactMap({$0.name}).joined(separator: ", ")
        if let tagline = movie?.tagline, !tagline.isEmpty {
            self.taglineLabel.text = "#\(tagline)".uppercased()
        } else {
            self.taglineLabel.text = "-"
        }
        self.overviewLabel.text = movie?.overview
        self.companiesProdLabel.text = "Production Companies: \(movie?.productionCompanies?.compactMap({$0.name}).joined(separator: ", ") ?? "-")"
        self.countriesProdLabel.text = "Production Countries: \(movie?.productionCountries?.compactMap({$0.name}).joined(separator: ", ") ?? "-")"
    }
    
    private func updateSavedButton(_ isSaved: Bool) {
        if isSaved {
            saveButton.tag = 1
            saveButton.setTitle("", for: .normal)
            saveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            saveButton.tintColor = .red
            saveButton.backgroundColor = UIColor(named: "GrayBgColor")
        } else {
            saveButton.tag = 0
            saveButton.setTitle("", for: .normal)
            saveButton.setImage(UIImage(systemName: "heart"), for: .normal)
            saveButton.tintColor = .white
            saveButton.backgroundColor = UIColor(named: "GrayBgColor")
        }
    }
    
    // MARK: - Action
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func saveButtonTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            self.viewModel.addToCollection()
        } else {
            self.viewModel.deleteFromCollection()
        }
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
            let width = castCollectionView.frame.width / 3.6
            let height = castCollectionView.frame.height
            return CGSize(width: width, height: height)
        case reviewsCollectionView:
            let width = reviewsCollectionView.frame.width
            let height = reviewsCollectionView.frame.height
            return CGSize(width: width, height: height)
        case recommendationsCollectionView:
            let width = recommendationsCollectionView.frame.width / 3.6
            let height = recommendationsCollectionView.frame.height
            return CGSize(width: width, height: height)
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
}

// MARK: - CustomSegmentedControlDelegate
extension DetailViewController: CustomSegmentedControlDelegate {
    func change(to index: Int) {
        removeChild()
        switch index {
        case 0:
            addChildVC(videoViewController)
        case 1:
            addChildVC(backdropsViewController)
        case 2:
            addChildVC(postersViewController)
        default: break
        }
    }
    
    private func removeChild() {
        self.children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
    
    private func addChildVC(_ viewController: UIViewController?) {
        guard let viewController else { return }
        addChild(viewController)
        contentMediaView.addSubview(viewController.view)
        viewController.view.frame = contentMediaView.bounds
        viewController.view.backgroundColor = UIColor(named: "GrayBgColor")
        viewController.didMove(toParent: self)
    }
}
