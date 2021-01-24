//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Sergey on 03.11.2020.
//  Copyright © 2020 Sergey. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    
    private lazy var infoTitle: UILabel = {
        let title = UILabel()
        title.text = "Привычка за 21 день"
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return title
    }()
    
    private lazy var infoDescription: UILabel = {
        let description = UILabel()
        description.text = """
Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму: \n\n1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага. \n\n2. Выдержать 2 дня в прежнем состоянии самоконтроля. \n\n3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться. \n\n4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств. \n\n5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой. \n\n6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся. \n\nИсточник: psychbook.ru
"""
        description.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        description.numberOfLines = 0
        return description
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Информация"
        view.addSubviewWithAutoLayout(scrollView)
        scrollView.addSubviews(infoTitle, infoDescription)
        setupLayout()
        
    }
    
}
private extension InfoViewController {
    func setupLayout() {
        let constraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            infoTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 22),
            infoTitle.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            infoDescription.topAnchor.constraint(equalTo: infoTitle.bottomAnchor, constant: 16),
            infoDescription.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            infoDescription.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            infoDescription.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
