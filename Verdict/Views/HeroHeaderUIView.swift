//
//  HeroHeaderView.swift
//  Netflix Clone
//
//  Created by Mekala Vamsi Krishna on 26/06/22.
//

import UIKit

class HeroHeaderUIView: UIView {

    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.layer.cornerRadius = 70
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "Dune")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let headerTitle: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var headerDescription: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.numberOfLines = 3
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
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
        addSubview(heroImageView)
        addGradient()
        addSubview(headerTitle)
        addSubview(headerDescription)
        applyConsraints()
    }
    
    private func applyConsraints() {
        
        let headerImageConstraints = [
            heroImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            heroImageView.topAnchor.constraint(equalTo: topAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        
        let headerTitleConstraints = [
            headerTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            headerTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        ]
        
        let headerDescriptionConstraints = [
            headerDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            headerDescription.topAnchor.constraint(equalTo: headerTitle.bottomAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(headerTitleConstraints)
        NSLayoutConstraint.activate(headerDescriptionConstraints)
        NSLayoutConstraint.activate(headerImageConstraints)
    }
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        heroImageView.sd_setImage(with: url, completed: nil)
        DispatchQueue.main.async {
            self.headerTitle.text = model.titleName
            self.headerDescription.text = "Desription: \(model.overview)"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
