//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Sergey on 11.11.2020.
//  Copyright © 2020 Sergey. All rights reserved.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    private var textLable: UILabel = {
        let text = UILabel()
        text.text = "Всё получится!"
        text.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        text.textColor = .systemGray
        return text
    }()
    
    public var percentageLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        lable.textColor = .systemGray
        return lable
    }()
    
    public var progressView: UIProgressView = {
        let view = UIProgressView()
        view.tintColor = UIColor(named: "violet")
        view.setProgress(view.progress, animated: true)
        view.layer.cornerRadius = 4
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(textLable, percentageLable, progressView)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProgressCollectionViewCell {
    func  setupLayout() {
        let constraints = [
            textLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            percentageLable.centerYAnchor.constraint(equalTo: textLable.centerYAnchor),
            percentageLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            progressView.topAnchor.constraint(equalTo: textLable.bottomAnchor, constant: 10),
            progressView.heightAnchor.constraint(equalToConstant: 7),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

