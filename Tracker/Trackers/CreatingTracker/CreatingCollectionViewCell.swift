//
//  CreatingCollectionViewCell.swift
//  Tracker
//
//  Created by Kira on 27.05.2025.
//

import UIKit

// MARK: - CreatingCollectionViewCell

final class CreatingCollectionViewCell: UICollectionViewCell {
    
    // MARK: Public Property
    
    static let reuseIdentifier = "CreatingCell"
    
    // MARK: Private Property
    
    private lazy var ui: UI = {
        let ui = createUI()
        layout(ui)
        return ui
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension CreatingCollectionViewCell {
    
    func configure(with emoji: String? = nil, backgroundColor: UIColor? = nil) {
        ui.creatingNameLabel.text = emoji
        if backgroundColor == nil {
            ui.creatingNameLabel.backgroundColor = .clear
        } else {
            ui.creatingNameLabel.backgroundColor = backgroundColor
        }
    }
}

// MARK: - UI Configuring

extension CreatingCollectionViewCell {
    
    // MARK: UI components
    
    struct UI {
        let creatingNameLabel: UILabel
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        
        let creatingNameLabel = UILabel()
        creatingNameLabel.translatesAutoresizingMaskIntoConstraints = false
        creatingNameLabel.layer.cornerRadius = 8
        creatingNameLabel.layer.masksToBounds = true
        creatingNameLabel.textAlignment = .center
        creatingNameLabel.font = .systemFont(ofSize: 32, weight: .bold)
        contentView.addSubview(creatingNameLabel)
        
        return .init(
            creatingNameLabel: creatingNameLabel
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate( [
            
            ui.creatingNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            ui.creatingNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            ui.creatingNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            ui.creatingNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
}
