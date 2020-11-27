//
//  HabitEditViewController.swift
//  MyHabits
//
//  Created by Sergey on 26.11.2020.
//  Copyright © 2020 Sergey. All rights reserved.
//

import UIKit

class HabitEditViewController: UIViewController {
    
    var habit: Habit?
    
    private lazy var newTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.text = "НАЗВАНИЕ"
        return title
    }()
    
    private lazy var colorTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.text = "ЦВЕТ"
        return title
    }()
    
    private lazy var timeTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.text = "ВРЕМЯ"
        return title
    }()
    
    private lazy var nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.text = habit?.name
        textfield.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        textfield.textColor = habit?.color
        textfield.addTarget(self, action: #selector(setTitle), for: .editingDidEnd)
        return textfield
    }()
    
    private lazy var selectColorButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = habit?.color
        button.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
        return button
    }()
    
    private lazy var timeText: UILabel = {
        let text = UILabel()
        text.text = "Каждый день в "
        text.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return text
    }()
    
    private lazy var dataPicker: UIDatePicker = {
        let time = UIDatePicker()
        time.datePickerMode = .time
        time.preferredDatePickerStyle = .wheels
        time.locale = .current
        time.addTarget(self, action: #selector(changeTime), for: .valueChanged)
        return time
    }()
    
    private lazy var selectTimeField: UITextField = {
        let textField = UITextField()
        textField.text = "\(dateFormatter.string(from: habit!.date))"
        textField.textColor = UIColor(named: "violet")
        textField.inputView = dataPicker
        textField.tintColor = UIColor(named: "violet")
        return textField
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(deleteHabit), for: .touchUpInside)
        return button
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.string(from: habit!.date)
        return formatter
    }()
    
    /// Gesture
    private lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapDone))
        return tap
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addGestureRecognizer(tap)
        view.addSubviews(newTitle, colorTitle, timeTitle, selectTimeField, selectColorButton, deleteButton, selectTimeField, timeText, nameTextField)
        setupLayout()
        
        /// Navigation Bar
        title = "Править"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "violet")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveHabit))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "violet")
    }
    
}

extension HabitEditViewController {
    @objc func cancel() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveHabit() {
        guard let changedHabit = habit else { return }
        let newTitle = nameTextField.text
        let newColor = selectColorButton.backgroundColor
        let newTime = dataPicker.date
        changedHabit.name = newTitle ?? habit!.name
        changedHabit.color = newColor ?? habit!.color
        changedHabit.date = newTime
        if let index = HabitStore.shared.habits.firstIndex(of: habit!) {
            HabitStore.shared.habits[index] = changedHabit
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func setTitle() {
        _ = nameTextField.text
    }
    
    @objc func changeColor() {
        if #available(iOS 14.0, *) {
            let newColor = UIColorPickerViewController()
            newColor.delegate = self
            present(newColor, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func changeTime() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        selectTimeField.text = formatter.string(from: dataPicker.date)
    }
    
    @objc func tapDone() {
        view.endEditing(true)
    }
    
    @objc func deleteHabit() {
        guard let name = habit?.name else {return}
        let alert = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(name)?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        let deleteHabit = UIAlertAction(title: "Удалить", style: .destructive, handler: { (action) in
            let habitToDelete = self.habit
            if let index = HabitStore.shared.habits.firstIndex(of: habitToDelete!) {
                HabitStore.shared.habits.remove(at: index)
            }
            
            //let editVC = HabitEditViewController()
            //let habitsVC = HabitsViewController()
            //habitsVC.isModalInPresentation = true
            //self.showDetailViewController(habitsVC, sender: nil)
            //editVC.navigationController?.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancel)
        alert.addAction(deleteHabit)
        present(alert, animated: true, completion: nil)
    }
}

extension HabitEditViewController: UIColorPickerViewControllerDelegate {
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectColorButton.backgroundColor = viewController.selectedColor
    }
}

private extension HabitEditViewController {
    func setupLayout() {
        let contstaints = [
            newTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            newTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.topAnchor.constraint(equalTo: newTitle.bottomAnchor, constant: 7),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            colorTitle.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            colorTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectColorButton.topAnchor.constraint(equalTo: colorTitle.bottomAnchor, constant: 7),
            selectColorButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectColorButton.widthAnchor.constraint(equalToConstant: 30),
            selectColorButton.heightAnchor.constraint(equalTo: selectColorButton.widthAnchor),
            timeTitle.topAnchor.constraint(equalTo: selectColorButton.bottomAnchor, constant: 15),
            timeTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            timeText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            timeText.topAnchor.constraint(equalTo: timeTitle.bottomAnchor, constant: 7),
            selectTimeField.leadingAnchor.constraint(equalTo: timeText.trailingAnchor, constant: 2),
            selectTimeField.centerYAnchor.constraint(equalTo: timeText.centerYAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            deleteButton.widthAnchor.constraint(equalToConstant: 200),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(contstaints)
    }
}
