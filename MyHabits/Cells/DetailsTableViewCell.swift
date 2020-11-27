//
//  DetailsTableViewCell.swift
//  MyHabits
//
//  Created by Sergey on 24.11.2020.
//  Copyright © 2020 Sergey. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    
    public lazy var dateLable: UILabel = {
        let date = UILabel()
        return date
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(dateLable)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DetailsTableViewCell {
    func setupLayout(){
        let constraints = [
            dateLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            dateLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -12),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
