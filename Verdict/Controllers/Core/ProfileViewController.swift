//
//  ProfileViewController.swift
//  Verdict
//
//  Created by Mekala Vamsi Krishna on 9/14/23.
//

import UIKit

struct Profile {
    var image: UIImage?
    var text: String
}

class ProfileViewController: UIViewController {
    
    let section1 = [
        Profile(image: UIImage(systemName: "star"), text: "Favourites"),
        Profile(image: UIImage(systemName: "list.star"), text: "My Ratings"),
    ]

    let section2 = [
        Profile(image: UIImage(systemName: "phone"), text: "Customer Support"),
        Profile(image: UIImage(systemName: "circle.dashed"), text: "Faq"),
        Profile(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), text: "Logout"),
    ]
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .insetGrouped)
        table.separatorStyle = .singleLine
        table.showsVerticalScrollIndicator = false
        table.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileHeaderView.identifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return section1.count
        } else {
            return section2.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileHeaderView.identifier) as! ProfileHeaderView
            header.profileImageView.image = UIImage(named: "profilePic")
            header.nameLabel.text = "Mekala Vamsi Krishna"
            header.roleLabel.text = "Public User"
            return header
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 110
        } else {
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
        cell.backgroundColor = .systemGray6
        cell.accessoryType = .disclosureIndicator
        if indexPath.section == 0 {
            cell.rowImageView.image = section1[indexPath.row].image
            cell.rowTextLabel.text = section1[indexPath.row].text
        } else {
            cell.rowImageView.image = section2[indexPath.row].image
            cell.rowTextLabel.text = section2[indexPath.row].text
            if indexPath.row == 2 {
                cell.tintColor = .red
                cell.rowTextLabel.textColor = .red
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let favouritesVCIndexPath = IndexPath(row: 0, section: 0)
        if favouritesVCIndexPath == indexPath {
            let destinationVC = FavouritesViewController()
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}
