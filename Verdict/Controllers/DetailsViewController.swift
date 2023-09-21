//
//  DetailsViewController.swift
//  Verdict
//
//  Created by Mekala Vamsi Krishna on 8/27/23.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController {
    
    var titles: Movie?
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "PosterNotFound")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieTitle: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let usersRatingLabel: CustomRatingLabel = {
        let label = CustomRatingLabel()
        label.updateRating(criticsText: "Users\nRating", ratingText: "9.8")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let coreCriticsRatingLabel: CustomRatingLabel = {
        let label = CustomRatingLabel()
        label.updateRating(criticsText: "Core Critic's\nRating", ratingText: "9.8")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let criticsRatingLabel: CustomRatingLabel = {
        let label = CustomRatingLabel()
        label.updateRating(criticsText: "Critic's\nRating", ratingText: "9.8")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.numberOfLines = 6
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        navigationController?.navigationBar.tintColor = .white
        configureConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        applyGradientToImageView()
    }
    
    func applyGradientToImageView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.0]
        gradientLayer.frame = movieImageView.bounds
        movieImageView.layer.addSublayer(gradientLayer)
    }
    
    func configureConstraints() {
        view.addSubview(containerView)
        containerView.addSubview(movieImageView)
        containerView.addSubview(movieTitle)
        
//        let yearLabel = createLabel(withText: "2013")
//        let genreLabel = createLabel(withText: "Adventure, Action")
//        let durationLabel = createLabel(withText: "2h 30m")
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(yearLabel)
        stackView.addArrangedSubview(genreLabel)
        stackView.addArrangedSubview(durationLabel)
        view.addSubview(ratingStackView)
        ratingStackView.addArrangedSubview(usersRatingLabel)
        ratingStackView.addArrangedSubview(coreCriticsRatingLabel)
        ratingStackView.addArrangedSubview(criticsRatingLabel)
        view.addSubview(descriptionLabel)
        
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.60),
            
            movieImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            movieImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            movieTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            movieTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            movieTitle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            movieTitle.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -70),
            
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 10),
            stackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            
            ratingStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ratingStackView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            ratingStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            descriptionLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 70),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func configure(with model: TitlePreviewViewModel) {
        movieTitle.text = model.title
        descriptionLabel.text = "Summary:\n\(model.titleOverview)"
    }
    func configure(with model: MovieDetail) {
        movieTitle.text = model.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let date = dateFormatter.date(from: model.release_date ?? "00-00-00") {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            yearLabel.text = String("\(year)")
        } else {
            yearLabel.text = model.release_date
        }
        
        genreLabel.text = model.genres?.map {$0.name ?? ""}.lazy.joined(separator: ", ")
        durationLabel.text = "\(model.runtime ?? 0) min"
        usersRatingLabel.updateRating(
            criticsText: "Users\nRating",
            ratingText: String(format: "%.1f ★", model.vote_average ?? 0.0)
        )
        coreCriticsRatingLabel.updateRating(
            criticsText: "Core Critics\nRating",
            ratingText: String(format: "%.1f ★", model.vote_average ?? 0.0)
        )
        criticsRatingLabel.updateRating(
            criticsText: "Critics\nRating",
            ratingText: String(format: "%.1f ★", model.vote_average ?? 0.0)
        )
        descriptionLabel.text = "Summary:\n\(model.overview ?? ""))"
    }
    

    func getPoster(with model: MovieDetail) {
        if let posterPath = model.poster_path {
            let sanitizedPosterPath = posterPath.replacingOccurrences(of: "\\", with: "")
            let imageUrlString = "https://image.tmdb.org/t/p/w500/\(sanitizedPosterPath)"
            
            if let imageUrl = URL(string: imageUrlString) {
                Task(priority: .medium) {
                    try await downloadImage(from: imageUrl)
                }
            } else {
                print("Invalid image URL: \(imageUrlString)")
            }
        } else {
            print("No poster path available for this movie")
        }

    }

    func downloadImage(from url: URL) async throws {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }
        let image = UIImage(data: data)
        movieImageView.image = image
    }
    
}


class CustomRatingLabel: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemBlue
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
        ])
    }
    
    func updateRating(criticsText: String, ratingText: String) {
        titleLabel.text = criticsText
        ratingLabel.text = ratingText
    }
}
