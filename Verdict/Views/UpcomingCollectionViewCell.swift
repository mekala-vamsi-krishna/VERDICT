//
//  UpcomingCollectionViewCell.swift
//  Verdict
//
//  Created by Mekala Vamsi Krishna on 9/21/23.
//

import UIKit

class UpcomingCollectionViewCell: UICollectionViewCell {
    static let identifier = "UpcomingCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "PosterNotFound")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Day-Mon-Year"
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
//        addGradient()
        contentView.addSubview(releaseDateLabel)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    private func applyConstraints() {
        
        let posterImageViewConstraints = [
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        
        let releaseDataLabelConstraints = [
            releaseDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            releaseDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            releaseDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ]
        
        NSLayoutConstraint.activate(releaseDataLabelConstraints)
        NSLayoutConstraint.activate(posterImageViewConstraints)
    }
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            posterImageView.image = UIImage(named: "PosterNotFound")
            return
        }
        posterImageView.sd_setImage(with: url, completed: nil)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: model.release_date) {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let formattedDate = dateFormatter.string(from: date)
            releaseDateLabel.text = formattedDate
        } else {
            releaseDateLabel.text = model.release_date
        }
    }
}
