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
    
    public let tableView: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Rated"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
        headerView = SegmentedHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 60))
        headerView?.delegate = self
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
        view.backgroundColor = UIColor(named: "BackgroundColor")
        configureNavbar()
        fetchTopRatedMovies(page: currentPage)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
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
        VDNetworking.shared.getTopRatedTv(page: page) { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles.append(contentsOf: titles)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchTopRatedMovies(page: Int) {
        VDNetworking.shared.getTopRatedMovies(page: page) { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles.append(contentsOf: titles)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
                    detailsVC.getPoster(with: data)
                    self?.navigationController?.pushViewController(detailsVC, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension TopRatedViewController: SegmentedHeaderViewDelegate {
    func didChangeSegment(_ segment: Int) {
        titles.removeAll()
        if segment == 0 {
            fetchTopRatedMovies(page: currentPage)
        } else {
            fetchTopRatedTv(page: currentPage, refresh: false)
        }
        self.tableView.reloadData()
    }
}


class LoadingView: UIView {
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray // Set the color as per your preference
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func startLoading() {
        activityIndicator.startAnimating()
        isHidden = false
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}
