//
//  UpComingViewController.swift
//  Verdict
//
//  Created by Mekala Vamsi Krishna on 23/12/22.
//

import UIKit
import SwiftUI

class UpComingViewController: UIViewController {
    
    public var movies: [Movie] = [Movie]()
    private var totalPage = 1
    private var currentPage = 1
    private var hasFetchedFirstPage = false
    
    public let collectionView: UICollectionView = {
        let layout = compositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UpcomingCollectionViewCell.self, forCellWithReuseIdentifier: UpcomingCollectionViewCell.identifier)
        return collectionView
    }()
    
    static func compositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(300)))
            item.contentInsets.trailing = 10
            item.contentInsets.bottom = 20
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1000)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.leading = 10
            return section
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UpComing"
        navigationController?.navigationBar.prefersLargeTitles = true

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "VerdictLogo")
        imageView.image = image
        navigationItem.titleView = imageView
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureNavbar()
        
        fetchUpcoming(page: currentPage)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
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
    
    private func fetchUpcoming(page: Int) {
        VDNetworking.shared.getUpcomingMovies(page: page) { [weak self] result in
            switch result {
            case .success(let titles):
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
//
//                let moviesWithDates = titles.compactMap({
//                    if let date = dateFormatter.date(from: $0.release_date ?? "00-00-0000"), date >= tomorrow ?? Date() {
//                        return ($0, date)
//                    }
//                    return nil
//                })
//                let sortedMoviesWithDates = moviesWithDates.sorted(by: { $0.1 < $1.1 })
                self?.movies.append(contentsOf: titles)
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension UpComingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingCollectionViewCell.identifier, for: indexPath) as? UpcomingCollectionViewCell else {
            return UICollectionViewCell()
        }
        let title = movies[indexPath.row]
        let model = TitleViewModel(titleName: title.title ?? title.original_name ?? title.original_title ?? "Unknown", posterURL: title.poster_path ?? "", overview: title.overview ?? "", vote_average: title.vote_average, release_date: title.release_date ?? "", language: title.original_language ?? "")
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = movies[indexPath.row]
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
        let offSetY = scrollView.contentOffset.y + defaultOffSet
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offSetY))
        let contentHeight = scrollView.contentSize.height

        // Check if the user has scrolled to the bottom
        if offSetY > contentHeight - scrollView.frame.height {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.currentPage += 1
                self.fetchUpcoming(page: self.currentPage)
            }
        }
    }
}

struct Content_Preview: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        
        func makeUIViewController(context: Context) -> UIViewController {
            UINavigationController(rootViewController: UpComingViewController())
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
        
        typealias UIViewControllerType = UIViewController
    }
}
