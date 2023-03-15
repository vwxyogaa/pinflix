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
    @IBOutlet weak var crewLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
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
        
        self.imagesCollectionView.register(UINib(nibName: "ImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImagesCollectionViewCell")
        self.imagesCollectionView.dataSource = self
        self.imagesCollectionView.delegate = self
    }
    
    private func initObserver() {
        viewModel.movie.drive(onNext: { [weak self] movie in
            self?.configureContent(movie: movie)
        }).disposed(by: disposeBag)
        
        viewModel.casts.drive(onNext: { [weak self] _ in
            self?.castCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.crew.drive(onNext: { [weak self] crew in
            self?.configureContent(crew: crew)
        }).disposed(by: disposeBag)
        
        viewModel.images.drive(onNext: { [weak self] _ in
            self?.imagesCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.drive(onNext: { [weak self] isLoading in
            self?.manageLoadingActivity(isLoading: isLoading)
        }).disposed(by: disposeBag)
    }
    
    private func configureData() {
        if let id = id {
            viewModel.getDetail(id: id)
            viewModel.getCredits(id: id)
            viewModel.getImages(id: id)
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
    
    private func configureContent(crew: [Credits.Cast]?) {
        guard let crew = crew?.compactMap({$0.name}).prefix(10).joined(separator: ", ") else { return }
        self.crewLabel.text = "Crew: \(crew), etc."
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
        case imagesCollectionView:
            return viewModel.imageCount
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
        case imagesCollectionView:
            guard let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath) as? ImagesCollectionViewCell else { return UICollectionViewCell() }
            let image = viewModel.image(at: indexPath.row)
            cell.configureContent(backdrop: image)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case castCollectionView:
            return CGSize(width: 80, height: 133)
        case imagesCollectionView:
            return CGSize(width: 200, height: 110)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case castCollectionView, imagesCollectionView:
            return 4
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
