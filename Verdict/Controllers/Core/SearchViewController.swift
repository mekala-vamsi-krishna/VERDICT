//
//  SearchViewController.swift
//  Verdict
//
//  Created by Mekala Vamsi Krishna on 23/12/22.
//

import UIKit

class SearchViewController: UIViewController {

    private var titles: [Movie] = [Movie]()
    
    public let discoverTable: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for Movies and Tv shows"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "VerdictLogo")
        imageView.image = image
        navigationItem.titleView = imageView
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(discoverTable)
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        configureNavbar()
        
        fetchDiscoverMovies()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let height: CGFloat = 100
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
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
    
    private func fetchDiscoverMovies() {
        VDNetworking.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.title ?? title.original_name ?? title.original_title ?? "Unknown", posterURL: title.poster_path ?? "", overview: title.overview ?? "", vote_average: title.vote_average, release_date: title.release_date ?? "", language: title.original_language ?? "")
        cell.configure(with: model)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        VDNetworking.shared.getMovieDetails(with: title.id) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    let detailsVC = DetailsViewController()
                    detailsVC.configure(with: data)
                    detailsVC.getPoster(with: data)
                    self?.navigationController?.pushViewController(detailsVC, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffSet = view.safeAreaInsets.top
        let offSet = scrollView.contentOffset.y + defaultOffSet

        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offSet))
    }
    
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        resultsController.delegate = self
        
        VDNetworking.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.discoverTable.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchResultsViewControllerDidTapItem(_ model: MovieDetail) {
        DispatchQueue.main.async { [weak self] in
            DispatchQueue.main.async { [weak self] in
                let detailsVC = DetailsViewController()
                detailsVC.configure(with: model)
                detailsVC.getPoster(with: model)
                self?.navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
    }

}
