//
//  SegmentedHeaderView.swift
//  Verdict
//
//  Created by Mekala Vamsi Krishna on 15/01/23.
//

import UIKit

protocol SegmentedHeaderViewDelegate: AnyObject {
    func didChangeSegment(_ segment: Int)
}

class SegmentedHeaderView: UIView {
    
    var delegate: SegmentedHeaderViewDelegate?
    
    public let movieSeriesSegment: UISegmentedControl = {
        let items = ["Movies", "Series"]
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 0
        segment.selectedSegmentTintColor = .systemBlue
        segment.backgroundColor = .clear
        segment.layer.cornerRadius = 20
//        segment.layer.borderWidth = 1.0
//        segment.layer.borderColor = UIColor.white.cgColor
        segment.clipsToBounds = false
        segment.layer.masksToBounds = false
        segment.addTarget(self, action: #selector(handleSegment), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieSeriesSegment.layer.cornerRadius = bounds.height/2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(movieSeriesSegment)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSegment(segment: UISegmentedControl) {
        delegate?.didChangeSegment(segment.selectedSegmentIndex)
    }
    
    private func applyConstraints() {
        let movieSeriesSegmentConstraints = [
            movieSeriesSegment.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            movieSeriesSegment.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            movieSeriesSegment.centerXAnchor.constraint(equalTo: centerXAnchor),
            movieSeriesSegment.heightAnchor.constraint(equalToConstant: 50),
            movieSeriesSegment.widthAnchor.constraint(equalToConstant: 70)
        ]
        NSLayoutConstraint.activate(movieSeriesSegmentConstraints)
    }
}
