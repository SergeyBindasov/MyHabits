//
//  File.swift
//  MyHabits
//
//  Created by Sergey on 03.11.2020.
//  Copyright © 2020 Sergey. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviewWithAutoLayout(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
}
