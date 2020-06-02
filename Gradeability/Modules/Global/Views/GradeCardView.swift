//
//  GradeCardView.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradeCardView: UIView {
    
    private let cardTopView = UIView()
    private let cardGradientView = GradientView()
    private var gradeLabel: UILabel!
    private var gradeTypeLabel: UILabel!
    private var messageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        
        addSubview(cardGradientView)
        cardGradientView.layer.cornerRadius = 6
        cardGradientView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: 5, left: 5, bottom: -5, right: -5))
            .activate()
        
        cardGradientView.addSubview(cardTopView)
        cardTopView.layer.cornerRadius = 4
        cardTopView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: 4, left: 4, bottom: -4, right: -4))
            .activate()
        
        // TODO: Delete this line after implementing the models
        setupView()
        
        let gesture = UIHoverGestureRecognizer(target: self, action: #selector(handleHover(_:)))
        addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let containerView = UIView()
        gradeLabel = createGradeLabel()
        gradeTypeLabel = createGradeTypeLabel()
        messageLabel = createMessageLabel()
        
        containerView.addSubview(gradeLabel)
        containerView.addSubview(gradeTypeLabel)
        containerView.addSubview(messageLabel)
        
        gradeLabel.anchor
            .topToSuperview()
            .leadingToSuperview()
            .trailingToSuperview()
            .activate()
        gradeTypeLabel.anchor
            .top(to: gradeLabel.bottomAnchor)
            .leadingToSuperview()
            .trailingToSuperview()
            .activate()
        messageLabel.anchor
            .top(to: gradeTypeLabel.bottomAnchor)
            .leadingToSuperview()
            .trailingToSuperview()
            .bottomToSuperview()
            .activate()
        
        cardTopView.addSubview(containerView)
        containerView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: 10, left: 16, bottom: -20, right: -16))
            .activate()
    }
    
    func configure(with viewModel: GradeCardViewModel) {
        backgroundColor = viewModel.color
        cardGradientView.color = viewModel.color
        cardTopView.backgroundColor = viewModel.color
        gradeLabel.text = viewModel.grade
        gradeTypeLabel.text = viewModel.type
        messageLabel.text = viewModel.message
    }
    
    private func createGradeLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 80.0)
        return label
    }
    
    private func createGradeTypeLabel() -> UILabel {
        let label = UILabel()
        return label
    }
    
    private func createMessageLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }
    
    @objc private func handleHover(_ recognizer: UIHoverGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            var location = recognizer.location(in: recognizer.view)
            location.x = location.x / (recognizer.view?.frame.size.width ?? 1)
            location.y = location.y / (recognizer.view?.frame.size.height ?? 1)
            cardGradientView.didHover(location)
        case .ended:
            cardGradientView.reset()
        default:
            break
        }
    }
    
}
