//
//  ProfileTableViewCell.swift
//  Verdict
//
//  Created by Mekala Vamsi Krishna on 9/15/23.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    static let identifier = "ProfileTableViewCell"
    
    let rowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let rowTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(rowImageView)
        contentView.addSubview(rowTextLabel)
        
        NSLayoutConstraint.activate([
            rowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rowImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rowImageView.heightAnchor.constraint(equalToConstant: 25),
            rowImageView.widthAnchor.constraint(equalToConstant: 25),
            
            rowTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rowTextLabel.leadingAnchor.constraint(equalTo: rowImageView.trailingAnchor, constant: 16),
            rowTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
