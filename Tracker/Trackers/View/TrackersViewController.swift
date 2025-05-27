//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Kira on 24.04.2025.
//

import UIKit

// MARK: - TrackersViewControllerDelegate

protocol TrackersViewControllerDelegate: AnyObject {
    func tracker(tracker: Tracker, for category: String)
}

// MARK: - TrackersViewController

final class TrackersViewController: UIViewController {
    
    // MARK: Private Property
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    
    private var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date = Date()
    
    private let dataManager = DataManager.shared
    
    private lazy var ui: UI = {
        let ui = createUI()
        layout(ui)
        return ui
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        updateUIForCategory()
        updateUIForCompletedTrackers()
    }
}

// MARK: - Private Methods

private extension TrackersViewController {
    
    func reloadData() {
        categories = dataManager.categories
        datePickerValueChanged()
    }
    
    func isTrackerComplitedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
    }
    
    func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(
            trackerRecord.date,
            inSameDayAs: ui.datePicker.date
        )
        return trackerRecord.id == id && isSameDay
    }
    
    func showHiddenImage() {
        ui.lackOfTrackersImageView.isHidden = false
        ui.lackOfTrackersLabel.isHidden = false
        ui.collectionView.isHidden = true
    }
    
    func hideHiddenImage() {
        ui.lackOfTrackersImageView.isHidden = true
        ui.lackOfTrackersLabel.isHidden = true
        ui.collectionView.isHidden = false
    }
    
    func showSearchImage() {
        ui.trackerNotFoundImageView.isHidden = false
        ui.trackerNotFoundLabel.isHidden = false
        ui.collectionView.isHidden = true
    }
    
    func hideSearchImage() {
        ui.trackerNotFoundImageView.isHidden = true
        ui.trackerNotFoundLabel.isHidden = true
        ui.collectionView.isHidden = false
    }
    
    func updateUIForCompletedTrackers() {
        if visibleCategories.isEmpty && ui.searchTextField.text?.isEmpty ?? true {
            showHiddenImage()
            hideSearchImage()
        } else {
            hideHiddenImage()
        }
    }
    
    func updateUIForCategory() {
        if visibleCategories.isEmpty && !(ui.searchTextField.text?.isEmpty ?? true) {
            showSearchImage()
            hideHiddenImage()
        } else {
            hideSearchImage()
        }
    }
    
    func reloadVisibleCategories() {
        let calendar = Calendar.current
        let filterText = (ui.searchTextField.text ?? String()).lowercased()
        let today = calendar.component(.weekday, from: ui.datePicker.date)
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty ||
                tracker.name.lowercased().contains(filterText)
                var dateCondition = false
                switch tracker.type {
                case .habit:
                    dateCondition = tracker.schedule.contains { weekDay in
                        return today == weekDay.rawValue
                    }
                case .irregularEvent:
                    if isCurrentDate(ui.datePicker.date) {
                        let creationDate = Date()
                        dateCondition = calendar.isDate(
                            creationDate,
                            inSameDayAs: ui.datePicker.date
                        )
                    }
                }
                
                return textCondition && dateCondition
            }
            return trackers.isEmpty ? nil : TrackerCategory(headingCategory: category.headingCategory, trackers: trackers)
        }
        if !filterText.isEmpty && visibleCategories.isEmpty {
            showSearchImage()
        } else {
            hideSearchImage()
        }
        ui.collectionView.reloadData()
    }
    
    func isCurrentDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
    
    @objc func didTapPlusButton() {
        let controller = CreatingTrackerViewController()
        controller.delegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .popover
        self.present(navigationController, animated: true)
    }
    
    @objc func datePickerValueChanged() {
        let selectedDate = ui.datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
        
        reloadVisibleCategories()
    }
}

// MARK: - UITextFieldDelegate

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadVisibleCategories()
        return true
    }
}

// MARK: - UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        let indexPath = indexPaths[0]
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [])
        })
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        cell.delegate = self
        
        let isComplitedToday = isTrackerComplitedToday(id: tracker.id)
        let isComplitedDay = completedTrackers.filter {
            $0.id == tracker.id
        }.count
        
        cell.schedule(
            tracker: tracker,
            isCompletedToday: isComplitedToday,
            completedDays: isComplitedDay,
            indexPath: indexPath
        )
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SupplementaryView.reuseIdentifier,
            for: indexPath
        ) as? SupplementaryView else { return UICollectionReusableView() }
        
        view.showNewTracker(with: visibleCategories.isEmpty ? "" : visibleCategories[indexPath.section].headingCategory)
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 10) / 2, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - TrackerCollectionViewCellDelegate

extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        
        if !isCurrentDate(ui.datePicker.date) && ui.datePicker.date > Date() { return }
        
        let trackerRecord = TrackerRecord(id: id, date: ui.datePicker.date)
        completedTrackers.append(trackerRecord)
        
        ui.collectionView.reloadItems(at: [indexPath])
    }
    
    func incompleteTracker(id: UUID, at indexPath: IndexPath) {
        
        if !isCurrentDate(ui.datePicker.date) && ui.datePicker.date > Date() { return }
        
        completedTrackers.removeAll { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
        ui.collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - TrackersViewControllerDelegate

extension TrackersViewController: TrackersViewControllerDelegate {
    func tracker(tracker: Tracker, for category: String) {
        var categoryAdded = false
        for oldCategory in categories {
            if oldCategory.headingCategory == category {
                renewCategory(for: oldCategory, tracker)
                categoryAdded = true
                break
            }
        }
        
        if !categoryAdded {
            categories.append(TrackerCategory(headingCategory: category, trackers: [tracker]))
        }
        updateUIForCategory()
        reloadVisibleCategories()
    }
    
    func renewCategory(for oldCategory: TrackerCategory, _ tracker: Tracker) {
        if let oldCategoryIndex: Int = visibleCategories.firstIndex(of: oldCategory) {
            let updatedTrackers = oldCategory.trackers + [tracker]
            let newCategory = TrackerCategory(
                headingCategory: oldCategory.headingCategory,
                trackers: updatedTrackers
            )
            visibleCategories.remove(at: oldCategoryIndex)
            visibleCategories.insert(newCategory, at: oldCategoryIndex)
        }
    }
}

// MARK: - UI Configuring

extension TrackersViewController {
    
    // MARK: UI components
    
    struct UI {
        let plusButton: UIButton
        let datePicker: UIDatePicker
        let treckerLabel: UILabel
        let searchTextField: UISearchTextField
        let collectionView: UICollectionView
        let lackOfTrackersImageView: UIImageView
        let lackOfTrackersLabel: UILabel
        let trackerNotFoundImageView: UIImageView
        let trackerNotFoundLabel: UILabel
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        
        let plusButton = UIButton.systemButton(
            with: UIImage(resource: ImageResource.plus),
            target: self,
            action: #selector(didTapPlusButton)
        )
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        view.addSubview(plusButton)
        
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.calendar.firstWeekday = 2
        datePicker.clipsToBounds = true
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(
            self,
            action: #selector(datePickerValueChanged),
            for: .valueChanged
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        view.addSubview(datePicker)
        
        let treckerLabel = UILabel()
        treckerLabel.translatesAutoresizingMaskIntoConstraints = false
        treckerLabel.text = "Трекеры"
        treckerLabel.font = FontsConstants.treckerLabel
        treckerLabel.textColor = .ypBlack
        view.addSubview(treckerLabel)
        
        let searchTextField = UISearchTextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = " Поиск"
        searchTextField.layer.cornerRadius = 10
        searchTextField.font = FontsConstants.searchTextField
        searchTextField.delegate = self
        view.addSubview(searchTextField)
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SupplementaryView.reuseIdentifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        let lackOfTrackersImageView = UIImageView()
        lackOfTrackersImageView.translatesAutoresizingMaskIntoConstraints = false
        lackOfTrackersImageView.image = ImageConstants.lackOfTrackersImageView
        view.addSubview(lackOfTrackersImageView)
        
        let lackOfTrackersLabel = UILabel()
        lackOfTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        lackOfTrackersLabel.text = "Что будем отслеживать?"
        lackOfTrackersLabel.font = FontsConstants.lackOfTrackersLabel
        lackOfTrackersLabel.textColor = .ypBlack
        view.addSubview(lackOfTrackersLabel)
        
        let trackerNotFoundImageView = UIImageView()
        trackerNotFoundImageView.translatesAutoresizingMaskIntoConstraints = false
        trackerNotFoundImageView.image = ImageConstants.trackerNotFoundImageView
        view.addSubview(trackerNotFoundImageView)
        
        let trackerNotFoundLabel = UILabel()
        trackerNotFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerNotFoundLabel.text = "Ничего не найдено"
        trackerNotFoundLabel.font = FontsConstants.lackOfTrackersLabel
        trackerNotFoundLabel.textColor = .ypBlack
        view.addSubview(trackerNotFoundLabel)
        
        return .init(
            plusButton: plusButton,
            datePicker: datePicker,
            treckerLabel: treckerLabel,
            searchTextField: searchTextField,
            collectionView: collectionView,
            lackOfTrackersImageView: lackOfTrackersImageView,
            lackOfTrackersLabel: lackOfTrackersLabel,
            trackerNotFoundImageView: trackerNotFoundImageView,
            trackerNotFoundLabel: trackerNotFoundLabel
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate( [
            
            ui.plusButton.widthAnchor.constraint(equalToConstant: 42),
            ui.plusButton.heightAnchor.constraint(equalToConstant: 42),
            ui.plusButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            ui.plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            
            ui.datePicker.widthAnchor.constraint(equalToConstant: 120),
            ui.datePicker.heightAnchor.constraint(equalToConstant: 34),
            ui.datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            ui.datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            ui.treckerLabel.widthAnchor.constraint(equalToConstant: 254),
            ui.treckerLabel.heightAnchor.constraint(equalToConstant: 41),
            ui.treckerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            ui.treckerLabel.leadingAnchor.constraint(equalTo: ui.plusButton.leadingAnchor, constant: 10),
            
            ui.searchTextField.heightAnchor.constraint(equalToConstant: 36),
            ui.searchTextField.topAnchor.constraint(equalTo: ui.treckerLabel.bottomAnchor, constant: 7),
            ui.searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ui.searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            ui.collectionView.topAnchor.constraint(equalTo: ui.searchTextField.bottomAnchor, constant: 34),
            ui.collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            ui.collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            ui.collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            ui.lackOfTrackersImageView.widthAnchor.constraint(equalToConstant: 80),
            ui.lackOfTrackersImageView.heightAnchor.constraint(equalToConstant: 80),
            ui.lackOfTrackersImageView.centerXAnchor.constraint(equalTo: ui.collectionView.centerXAnchor),
            ui.lackOfTrackersImageView.centerYAnchor.constraint(equalTo: ui.collectionView.centerYAnchor),
            
            ui.lackOfTrackersLabel.topAnchor.constraint(equalTo: ui.lackOfTrackersImageView.bottomAnchor, constant: 8),
            ui.lackOfTrackersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ui.trackerNotFoundImageView.widthAnchor.constraint(equalToConstant: 80),
            ui.trackerNotFoundImageView.heightAnchor.constraint(equalToConstant: 80),
            ui.trackerNotFoundImageView.centerXAnchor.constraint(equalTo: ui.collectionView.centerXAnchor),
            ui.trackerNotFoundImageView.centerYAnchor.constraint(equalTo: ui.collectionView.centerYAnchor),
            
            ui.trackerNotFoundLabel.topAnchor.constraint(equalTo: ui.lackOfTrackersImageView.bottomAnchor, constant: 8),
            ui.trackerNotFoundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupUI() {
        view.backgroundColor = .ypWhite
    }
}

// MARK: - Constants

private extension TrackersViewController {
    
    // MARK: FontsConstants
    
    enum FontsConstants {
        static let treckerLabel: UIFont = UIFont.systemFont(ofSize: 34, weight: .bold)
        static let searchTextField: UIFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let lackOfTrackersLabel: UIFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    // MARK: ImageConstants
    
    enum ImageConstants {
        static let plusButton: UIImage? = UIImage(named: "plus")
        static let lackOfTrackersImageView = UIImage(named: "lackOfTrackers")
        static let trackerNotFoundImageView = UIImage(named: "trackerNotFound")
    }
}
