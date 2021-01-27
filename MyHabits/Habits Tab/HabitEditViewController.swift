//
//  HabitEditViewController.swift
//  MyHabits
//
//  Created by Sergey on 26.11.2020.
//  Copyright © 2020 Sergey. All rights reserved.
//

import UIKit

class HabitEditViewController: HabitViewController {
    
    var habit: Habit?
    let details = HabitDetailsViewController()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(deleteHabit), for: .touchUpInside)
        return button
    }()
    
    /// UI Override
    private lazy var NameTF: UITextField = {
        let tf = UITextField()
        tf.text = habit?.name
        tf.textColor = habit?.color
        return tf
    }()
    
    override var textField: UITextField {
        get { return NameTF }
        set { NameTF = newValue }
    }
    
    private lazy var colorB: UIButton = {
        let button = UIButton()
        button.backgroundColor = habit?.color
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
        return button
    }()
    
    override var selectColorButton: UIButton {
        get { return colorB }
        set { colorB = newValue }
    }
    
    private lazy var timeTF: UITextField = {
        let time = UITextField()
        time.text = dateFormatter.string(from: habit!.date)
        time.textColor = UIColor(named: "violet")
        return time
    }()
    
    override var selectTimeField: UITextField {
        get { return timeTF }
        set { timeTF = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(deleteButton)
        setupLayout()
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
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancel)
        alert.addAction(deleteHabit)
        present(alert, animated: true, completion: nil)
    }
}

private extension HabitEditViewController {
    func setupLayout() {
        let contstaints = [
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            deleteButton.widthAnchor.constraint(equalToConstant: 200),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(contstaints)
    }
    
    @objc func changeColor() {
        if #available(iOS 14.0, *) {
            let newColor = UIColorPickerViewController()
            newColor.delegate = self
            newColor.selectedColor = selectColorButton.backgroundColor!
            present(newColor, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func cancel() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveHabit() {
        guard let changedHabit = habit else { return }
        let newTitle = textField.text
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
}


