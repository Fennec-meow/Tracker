////
////  CollectionView.swift
////  Tracker
////
////  Created by Kira on 12.05.2025.
////
//
//import UIKit
//
//class CollectionView: UIViewController {
//    static let cellIdentifier = "cell"
//    
//    private let lettersSection1 = ["🍇", "🍈", "🍉", "🍊", "🍋", "🍌"]
//    private let lettersSection2 = ["🍍", "🥭", "🍎", "🍏", "🍐", "🍒"]
//    
//    private lazy var ui: UI = {
//        let ui = createUI()
//        layout(ui)
//        return ui
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // TODO:
//        if let layout = ui.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 20, height: 50)
//            layout.minimumLineSpacing = 10
//            layout.minimumInteritemSpacing = 10
//            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        }
//    }
//    
//    private func makeBold(indexPath: IndexPath) {
//        let cell = ui.collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell
////        cell?.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
//    }
//    
//    private func makeItalic(indexPath: IndexPath) {
//        let cell = ui.collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell
////        cell?.titleLabel.font = UIFont.italicSystemFont(ofSize: 17)
//    }
//}
//
//extension CollectionView: UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return lettersSection1.count
//        } else {
//            return lettersSection2.count
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrackerCollectionViewCell
//        if indexPath.section == 0 {
////            cell.titleLabel.text = lettersSection1[indexPath.row]
//        } else {
////            cell.titleLabel.text = lettersSection2[indexPath.row]
//        }
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String,
//                        at indexPath: IndexPath) -> UICollectionReusableView {
//        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SupplementaryView
//        if kind == UICollectionView.elementKindSectionHeader {
////            view.ui.collectionView.text = "Заголовок секции \(indexPath.section + 1)"
//        }
//        return view
//    }
//}
//
//extension CollectionView: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell
////        cell?.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
//        print("Вы выбрали букву: \(indexPath.section == 0 ? lettersSection1[indexPath.row] : lettersSection2[indexPath.row])")
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell
////        cell?.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
//        guard indexPaths.count > 0 else {
//            return nil
//        }
//        let indexPath = indexPaths[0]
//        return UIContextMenuConfiguration(actionProvider: { actions in
//            return UIMenu(children: [
//                UIAction(title: "Bold") { [weak self] _ in
//                    self?.makeBold(indexPath: indexPath)
//                },
//                UIAction(title: "Italic") { [weak self] _ in
//                    self?.makeItalic(indexPath: indexPath)
//                },
//            ])
//        })
//    }
//}
//
//// let width = UIScreen.main.bounds.width
//// ширина ячейки = width / 2 - 16 - 4
//
//extension CollectionView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 50)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize.zero
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width / 2 - 16 - 4, height: 148)
//    }
//}
//
//// MARK: - UI Configuring
//
//extension CollectionView {
//    
//    // MARK: UI components
//    
//    struct UI {
//        let collectionView: UICollectionView
//    }
//    
//    // MARK: Creating UI components
//    
//    func createUI() -> UI {
//        
//        let collectionView = UICollectionView(
//            frame: .zero,
//            collectionViewLayout: UICollectionViewLayout()
//        )
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        
//        collectionView.allowsMultipleSelection = false
//        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        collectionView.register(
//            SupplementaryView.self,
//            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//            withReuseIdentifier: "header"
//        )
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        view.addSubview(collectionView)
//        
//        return .init(
//            collectionView: collectionView
//        )
//    }
//    
//    // MARK: UI component constants
//    
//    func layout(_ ui: UI) {
//        
//        NSLayoutConstraint.activate( [
//           
//            ui.collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 34),
//            ui.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            ui.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            ui.collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//
//        ])
//    }
//}
