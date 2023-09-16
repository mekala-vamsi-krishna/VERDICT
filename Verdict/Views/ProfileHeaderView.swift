//
//  ProfileHeaderView.swift
//  Verdict
//
//  Created by Mekala Vamsi Krishna on 9/14/23.
//

import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView {
    static let identifier = "CustomHeaderView"
    
    let imageHeight: CGSize = CGSize(width: 60, height: 60)
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let roleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = imageHeight.width / 2
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(roleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: imageHeight.height),
            profileImageView.widthAnchor.constraint(equalToConstant: imageHeight.width),
            
            stackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
