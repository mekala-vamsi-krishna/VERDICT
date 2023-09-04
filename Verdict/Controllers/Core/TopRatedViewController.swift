//
//  TopRatedViewController.swift
//  Verdict
//
//  Created by Mekala Vamsi Krishna on 23/12/22.
//

import UIKit

class TopRatedViewController: UIViewController {
    
    public var titles: [Movie] = [Movie]()
    private var totalPage = 1
    private var currentPage = 1
    private var headerView: SegmentedHeaderView?
    
    public let topRatedTable: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Rated"
        navigationController?.navigationBar.prefersLargeTitles = true
        topRatedTable.delegate = self
        topRatedTable.dataSource = self
        headerView = SegmentedHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 60))
        
        topRatedTable.tableHeaderView = headerView
        view.addSubview(topRatedTable)
        view.backgroundColor = UIColor(named: "BackgroundColor")
        configureNavbar()
        fetchTopRatedMovies(page: currentPage, refresh: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topRatedTable.frame = view.bounds
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
    
    public func fetchTopRatedTv(page: Int, refresh: Bool = false) {
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/top_rated?api_key=34f1a8f9c59360b0ca5e6cddb936a2d8&") else { return }
        let params = "language=enUS&page=\(page)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = params.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                do {
                    let myData = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                    self.titles = myData.results
                    print("Titles Count Tv: \(self.titles.count)")
                    self.topRatedTable.reloadData()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    public func fetchTopRatedMovies(page: Int, refresh: Bool = false) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=34f1a8f9c59360b0ca5e6cddb936a2d8&") else { return }
        let params = "language=enUS&page=\(page)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = params.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                do {
                    let myData = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                    self.titles.append(contentsOf: myData.results)
                    self.topRatedTable.reloadData()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension TopRatedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.title ?? title.original_name ?? title.original_title ?? "Unknown", posterURL: title.poster_path ?? "", overview: title.overview ?? "", vote_average: title.vote_average, release_date: title.release_date ?? "", language: title.original_language ?? "")
        cell.configure(with: model)
        cell.accessoryType = .disclosureIndicator
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffSet = view.safeAreaInsets.top
        let offSetY = scrollView.contentOffset.y + defaultOffSet
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offSetY))
        let contentHeight = scrollView.contentSize.height
        
        // Check if the user has scrolled to the bottom
        if offSetY > contentHeight - scrollView.frame.height {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.currentPage += 1
                self.fetchTopRatedMovies(page: self.currentPage)
            }
        }
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
                    detailsVC.getPoser(with: data)
                    self?.navigationController?.pushViewController(detailsVC, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
