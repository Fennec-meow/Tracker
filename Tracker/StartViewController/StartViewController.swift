//
//  StartViewController.swift
//  Tracker
//
//  Created by Kira on 24.04.2025.
//

import UIKit

// MARK: - StartViewController

final class StartViewController: UIViewController {
    
    // MARK: Private Property
    
    private lazy var ui: UI = {
        let ui = createUI()
        layout(ui)
        return ui
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private Methods

private extension StartViewController {
    
    @objc func didTapStartButton() {
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let trackersViewController = TrackersViewController()
            window.rootViewController = trackersViewController
            // Можно добавить переход или анимацию, если нужно
        }
    }
}

// MARK: - UI Configuring

extension StartViewController {
    
    // MARK: UI components
    
    struct UI {
        
        let backgroundImageView: UIImageView
        let startLabelText: UILabel
        let startButton: UIButton
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        
        let backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = ImageConstants.backgroundImage
        view.addSubview(backgroundImageView)
        
        let startLabelText = UILabel()
        startLabelText.translatesAutoresizingMaskIntoConstraints = false
        startLabelText.text = "Отслеживайте только то, что хотите"
        startLabelText.numberOfLines = 0
        startLabelText.textAlignment = .center
        startLabelText.font = FontsConstants.startLabelText
        startLabelText.textColor = .ypBlack
        view.addSubview(startLabelText)
        
        let startButton = UIButton(type: .system)
        startButton.layer.cornerRadius = 16
        startButton.setTitle("Вот это технологии!", for: .normal)
        startButton.backgroundColor = .ypBlack
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.tintColor = .ypWhite
        startButton.addTarget(
            self,
            action: #selector(didTapStartButton),
            for: .touchUpInside
        )
        view.addSubview(startButton)
        
        return .init(
            backgroundImageView: backgroundImageView,
            startLabelText: startLabelText,
            startButton: startButton
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate( [
            
            ui.backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            ui.backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ui.backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ui.backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            ui.startLabelText.topAnchor.constraint(equalTo: ui.backgroundImageView.topAnchor, constant: 432),
            ui.startLabelText.leadingAnchor.constraint(equalTo: ui.backgroundImageView.leadingAnchor, constant: 16),
            ui.startLabelText.trailingAnchor.constraint(equalTo: ui.backgroundImageView.trailingAnchor, constant: -16),
            
            ui.startButton.widthAnchor.constraint(equalToConstant: 335),
            ui.startButton.heightAnchor.constraint(equalToConstant: 60),
            ui.startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ui.startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ui.startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    func setupUI() {
        view.backgroundColor = .ypWhite
        print(ui.startButton.currentAttributedTitle?.string ?? String())
    }
}

// MARK: - Constants

private extension StartViewController {
    
    // MARK: FontsConstants
    
    enum FontsConstants {
        static let startLabelText: UIFont = UIFont.systemFont(ofSize: 32, weight: .bold)
    }
    
    // MARK: ImageConstants
    
    enum ImageConstants {
        static let backgroundImage = UIImage(named: "backgroundBlueImage")
    }
}
