//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Kira on 08.05.2025.
//

import UIKit

// MARK: - ScheduleDelegate

protocol ScheduleDelegate: AnyObject {
    func delegateSchedule(days: [WeekDay])
}

// MARK: - ScheduleViewController

final class ScheduleViewController: UIViewController {
    
    // MARK: Public Property
    
    var delegate: ScheduleDelegate?
    var currentSchedule: [WeekDay] = []
    
    // MARK: Private Property
    
    private var weekdays: [WeekDay] = []
    
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

private extension ScheduleViewController {
    
    func setupNavBar() {
        navigationItem.title = NSLocalizedString("scheduleNavigationItem.title", comment: "")
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.ypBlack
            ]
        }
    }
    
    func statusDay() {
        for (index, day) in WeekDay.allCases.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = ui.scheduleTableView.cellForRow(at: indexPath)
            guard let switchButton = cell?.accessoryView as? UISwitch else { return }
            
            if switchButton.isOn {
                weekdays.append(day)
            } else {
                weekdays.removeAll { $0 == day }
            }
        }
    }
    
    @objc func didTapButton() {
        statusDay()
        delegate?.delegateSchedule(days: weekdays)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == WeekDay.allCases.count - 1 {
            return 76
        } else {
            return 75
        }
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .ypBackground
        let switchButton = UISwitch(frame: .zero)
        let switchIsOn = currentSchedule.contains(WeekDay.allCases[indexPath.row])
        switchButton.setOn(switchIsOn, animated: true)
        switchButton.onTintColor = .ypBlue
        switchButton.tag = indexPath.row
        cell.accessoryView = switchButton
        cell.configure(with: WeekDay.allCases[indexPath.row])
        
        return cell
    }
}

// MARK: - UI Configuring

private extension ScheduleViewController {
    
    // MARK: UI components
    
    struct UI {
        let scheduleTableView: UITableView
        let doneButton: UIButton
    }
    
    // MARK: Creating UI components
    
    func createUI() -> UI {
        
        let scheduleTableView = UITableView()
        scheduleTableView.register(
            CustomTableViewCell.self,
            forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier
        )
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        scheduleTableView.layer.cornerRadius = 16
        scheduleTableView.backgroundColor = .ypBackground
        scheduleTableView.separatorStyle = .none
        scheduleTableView.layer.masksToBounds = true
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        view.addSubview(scheduleTableView)
        
        let doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.layer.cornerRadius = 16
        doneButton.backgroundColor = .ypBlack
        doneButton.setTitle(NSLocalizedString("doneButton.setTitle", comment: ""), for: .normal)
        doneButton.setTitleColor(.ypWhite, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.addTarget(
            self,
            action: #selector(didTapButton),
            for: .touchUpInside
        )
        view.addSubview(doneButton)
        
        return .init(
            scheduleTableView: scheduleTableView,
            doneButton: doneButton
        )
    }
    
    // MARK: UI component constants
    
    func layout(_ ui: UI) {
        
        NSLayoutConstraint.activate([
            
            ui.scheduleTableView.heightAnchor.constraint(equalToConstant: 525),
            ui.scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            ui.scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ui.scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            ui.doneButton.heightAnchor.constraint(equalToConstant: 60),
            ui.doneButton.topAnchor.constraint(equalTo: ui.scheduleTableView.bottomAnchor, constant: 47),
            ui.doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ui.doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func setupUI() {
        view.backgroundColor = .ypWhite
        print(ui.doneButton.titleLabel?.text)
        setupNavBar()
    }
}

