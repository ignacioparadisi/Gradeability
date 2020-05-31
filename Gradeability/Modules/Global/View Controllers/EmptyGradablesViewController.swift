//
//  EmptyGradablesViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/31/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol EmptyGradablesViewDelegate: class {
    func didTapButton()
}

class EmptyGradablesView: UIView {
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let imageName: String
    private let descriptionText: String
    private let buttonTitle: String
    weak var delegate: EmptyGradablesViewDelegate?
    
    init(imageName: String, description: String, buttonTitle: String) {
        self.imageName = imageName
        self.descriptionText = description
        self.buttonTitle = buttonTitle
        super.init(frame: .zero)
        backgroundColor = .systemGroupedBackground
        setupCreateTermView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Setup view to show if there's not terms saved in the database
    private func setupCreateTermView() {
        let label = UILabel()
        let button = UIButton()
        
        imageView.image = UIImage(systemName: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray4
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        label.text = descriptionText
        label.numberOfLines = 2
        
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(label)
        containerView.addSubview(button)
        
        containerView.anchor
            .top(greaterOrEqual: safeAreaLayoutGuide.topAnchor, constant: 50)
            .trailing(to: safeAreaLayoutGuide.trailingAnchor, constant: -30)
            .bottom(lessOrEqual: safeAreaLayoutGuide.bottomAnchor, constant: -50)
            .leading(to: safeAreaLayoutGuide.leadingAnchor, constant: 30)
            .centerToSuperview()
            .activate()
        
        label.anchor
            .top(to: imageView.bottomAnchor, constant: 40)
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        
        button.anchor
            .top(to: label.bottomAnchor, constant: 30)
            .trailing(lessOrEqual: containerView.trailingAnchor)
            .leading(lessOrEqual: containerView.leadingAnchor)
            .bottomToSuperview()
            .centerXToSuperview()
            .height(constant: 44)
            .width(lessThanOrEqualToConstant: 400)
            .activate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.anchor
            .topToSuperview()
            .centerXToSuperview()
            .height(constant: min(frame.height, frame.width) * 0.6)
            .width(to: imageView.heightAnchor)
            .activate()
    }
    
    @objc private func didTapButton() {
        delegate?.didTapButton()
    }
}
