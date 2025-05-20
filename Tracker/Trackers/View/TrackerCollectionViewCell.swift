//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Kira on 12.05.2025.
//

import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        configureAppearance()
    }
    
    private func configureAppearance() {
        contentView.backgroundColor = UIColor.systemGray6
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

//        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
