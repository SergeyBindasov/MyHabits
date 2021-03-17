//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Sergey on 11.11.2020.
//  Copyright © 2020 Sergey. All rights reserved.
//

import UIKit


class HabitCollectionViewCell: UICollectionViewCell {
    
    
    var habit: Habit? {
        didSet {
            guard let habit = habit else { return }
            mainTitle.text = habit.name
            mainTitle.textColor = habit.color
            timeTitle.text = "Каждый день в \(dateFormatter.string(from: habit.date))"
            countTitle.text = "Подряд: \(habit.trackDates.count)"
            markButton.layer.borderColor = habit.color.cgColor
        }
    }
    
    public var mainTitle: UILabel = {
        let title = UILabel()
        title.numberOfLines = .zero
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return title
    }()
    
    private var timeTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        title.tintColor = .systemGray2
        return title
    }()
    
    private var countTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        title.tintColor = .systemGray
        return title
    }()
    
    public var markButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 2
        return button
    }()
    
    private var markImg: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "mark")
        return image
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.string(from: habit!.date)
        return formatter
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(mainTitle, timeTitle, countTitle, markButton, mainTitle)
        markButton.addSubviews(markImg)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


private extension HabitCollectionViewCell {
    
    func setupLayout() {
        let constraints = [
            mainTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            timeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timeTitle.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 4),
            countTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            countTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            markButton.heightAnchor.constraint(equalToConstant: 36),
            markButton.widthAnchor.constraint(equalToConstant: 36),
            markButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            markButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 47),
            markButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -47),
            markImg.centerXAnchor.constraint(equalTo: markButton.centerXAnchor),
            markImg.centerYAnchor.constraint(equalTo: markButton.centerYAnchor),
            markImg.widthAnchor.constraint(equalToConstant: 20),
            markImg.heightAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
