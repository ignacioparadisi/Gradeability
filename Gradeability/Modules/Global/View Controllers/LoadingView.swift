//
//  LoadingView.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/31/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .systemGroupedBackground
        
        let centerView = UIView()
        let activityIndicator = UIActivityIndicatorView()
        let loadingLabel = UILabel()
        loadingLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        loadingLabel.text = "LOADING"
        
        centerView.addSubview(activityIndicator)
        centerView.addSubview(loadingLabel)
        
        activityIndicator.anchor
            .topToSuperview()
            .centerXToSuperview()
            .activate()
        loadingLabel.anchor
            .top(to: activityIndicator.bottomAnchor, constant: 10)
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
            .activate()
        
        addSubview(centerView)
        centerView.anchor.centerToSuperview().activate()
        
        activityIndicator.startAnimating()
    }
}
