//
//  GradeCardView.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradeCardView: UIView {
    
    // MARK: Properties
    /// View that holds the labels
    private let cardTopView = UIView()
    /// Gradient view
    private let cardGradientView = GradientView()
    /// Label for the grade
    private var gradeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont.boldSystemFont(ofSize: 70.0)
        return label
    }()
    /// Label for the grade type. Grade or Max Grade
    private var gradeTypeLabel: UILabel = UILabel()
    /// Label for the message
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15
        
        addSubview(cardGradientView)
        cardGradientView.layer.cornerRadius = 10
        cardGradientView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: 8, left: 8, bottom: -8, right: -8))
            .activate()
        
        cardGradientView.addSubview(cardTopView)
        cardTopView.layer.cornerRadius = 7
        cardTopView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: 5, left: 5, bottom: -5, right: -5))
            .activate()
        
        setupView()
        
        let gesture = UIHoverGestureRecognizer(target: self, action: #selector(handleHover(_:)))
        addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    /// Setup the subviews
    private func setupView() {
        let containerView = UIView()
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
        
        addShadow()
    }
    
    private func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.2
        layer.cornerRadius = 15
        clipsToBounds = false
    }
    
    /// Configure the view with the information stored in the view model
    /// - Parameter viewModel: View Model that holds the view's information
    func configure(with viewModel: GradeCardViewModel) {
        backgroundColor = viewModel.color
        cardGradientView.color = viewModel.color
        cardTopView.backgroundColor = viewModel.color
        gradeLabel.text = viewModel.grade
        print(viewModel.grade)
        gradeTypeLabel.text = viewModel.type
        messageLabel.text = viewModel.message
        gradeLabel.textColor = viewModel.color.lighter(by: 60)
        gradeTypeLabel.textColor = viewModel.color.lighter(by: 60)
        messageLabel.textColor = viewModel.color.lighter(by: 60)
        
//        let sizeMultiplier = frame.width / 300
//        let multiplier = (sizeMultiplier > 1) ? 1 : sizeMultiplier
//        gradeLabel.font = UIFont.boldSystemFont(ofSize: 80.0 * multiplier)
    }
    
    /// Handle gradient position on mouse hover
    /// - Parameter recognizer: Hover recognizer to get the pointer's position
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
