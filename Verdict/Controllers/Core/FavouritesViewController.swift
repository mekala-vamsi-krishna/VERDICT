//
//  FavouritesViewController.swift
//  Verdict
//
//  Created by Mekala Vamsi Krishna on 03/01/23.
//

import UIKit

enum ViewMode {
    case Simple
    case Extended
}

class FavouritesViewController: UIViewController {
    
    public var titles: [TitleItem] = [TitleItem]()
    private var currentViewModeValue: ViewMode = .Simple
    
    private let favouritesTable: UITableView = {
        let table = UITableView()
        table.register(FavouritesTableViewCell.self, forCellReuseIdentifier: FavouritesTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(favouritesTable)
        
        favouritesTable.delegate = self
        favouritesTable.dataSource = self
        
        fetchFavourites()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("AddedToFavourites"), object: nil, queue: nil) { _ in
            self.fetchFavourites()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favouritesTable.frame = view.bounds
    }
    
    private func configureNavbar() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "VerdictLogo")
        imageView.image = image
        navigationItem.titleView = imageView
        navigationController?.navigationBar.isTranslucent = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(handleAccountVC))
        
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    @objc func handleAccountVC() {
        let vc = MyAccountViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchFavourites() {
        FavouritesDataPersistantManager.shared.fetchFavouritesFromDatabse { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.favouritesTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}


extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesTableViewCell.identifier, for: indexPath) as? FavouritesTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.title ?? title.original_name ?? title.original_title ?? "Unknown", posterURL: title.poster_path ?? "", overview: title.overview ?? "", vote_average: title.vote_average, release_date: title.release_date ?? "", language: title.original_language ?? "")
        cell.configure(with: model)
        cell.accessoryType = .disclosureIndicator
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        VDNetworking.shared.getMovieDetails(with: Int(title.id)) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    let detailsVC = DetailsViewController()
                    detailsVC.configure(with: data)
                    detailsVC.getPoser(with: data)
                    self?.navigationController?.pushViewController(detailsVC, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            FavouritesDataPersistantManager.shared.deleteTFavouritesitleWith(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted From the Dtabase")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffSet = view.safeAreaInsets.top
        let offSet = scrollView.contentOffset.y + defaultOffSet
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offSet))
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveTitle = titles[sourceIndexPath.row]
        titles.remove(at: sourceIndexPath.row)
        titles.insert(moveTitle, at: destinationIndexPath.row)
        favouritesTable.isEditing = false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Delete Action
        let deleteAction = UIContextualAction(style: .normal, title: "") { (action, view, (Bool) -> Void) in
            FavouritesDataPersistantManager.shared.deleteTFavouritesitleWith(model: self.titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted From the Dtabase")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        deleteAction.backgroundColor = UIColor.red
        deleteAction.image = UIImage(systemName: "trash")
        
        // Move Action
        let moveAction = UIContextualAction(style: .normal, title: "") { (_, view, _) in
            print("moveActionCode")
            self.favouritesTable.isEditing = false //hiding actions
            self.favouritesTable.isEditing = true //enabling the editing mode
        }
        moveAction.backgroundColor = UIColor.systemBlue
        moveAction.image = UIImage(systemName: "square.and.pencil")
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, moveAction])
        swipeActionConfiguration.performsFirstActionWithFullSwipe = true
        return swipeActionConfiguration
    }
}
