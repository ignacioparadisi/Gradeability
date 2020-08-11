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
    private let backgroundGradientView = GradientView()
    private let cardGradientView = GradientView()
    /// Label for the grade
    private var gradeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 70.0)
        return label
    }()
    /// Label for the grade type. Grade or Max Grade
    private var gradeTypeLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    /// Label for the message
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = Constants.cornerRadius
        
        addSubview(backgroundGradientView)
        backgroundGradientView.anchor.edgesToSuperview().activate()
        backgroundGradientView.layer.cornerRadius = layer.cornerRadius
        
        let blurView = createBlurView(cornerRadius: layer.cornerRadius)
        backgroundGradientView.addSubview(blurView)
        blurView.anchor.edgesToSuperview().activate()
        
        backgroundGradientView.addSubview(cardGradientView)
        var margin: CGFloat = 8
        let borderCornerRadius = Constants.cornerRadius - margin
        cardGradientView.layer.cornerRadius = borderCornerRadius
        cardGradientView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: margin, left: margin, bottom: -margin, right: -margin))
            .activate()
        
        cardGradientView.addSubview(cardTopView)
        margin = 5
        cardTopView.layer.cornerRadius = borderCornerRadius - margin
        cardTopView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: margin, left: margin, bottom: -margin, right: -margin))
            .activate()
        
        setupView()
        
        let gesture = UIHoverGestureRecognizer(target: self, action: #selector(handleHover(_:)))
        addGestureRecognizer(gesture)
    }
    
    func createBlurView(cornerRadius: CGFloat) -> UIVisualEffectView {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
        blurView.layer.cornerRadius = cornerRadius
        blurView.clipsToBounds = true
        return blurView
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
        
        cardTopView.backgroundColor = .clear // UIColor.systemBackground.withAlphaComponent(0.7)
        
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
        
        let blurView = createBlurView(cornerRadius: cardTopView.layer.cornerRadius)
        cardTopView.addSubview(blurView)
        cardTopView.addSubview(containerView)
        blurView.anchor.edgesToSuperview().activate()
        containerView.anchor
            .top(greaterOrEqual: cardTopView.topAnchor, constant: 10)
            .trailingToSuperview(constant: -16)
            .bottom(lessOrEqual: cardTopView.bottomAnchor, constant: -10)
            .leadingToSuperview(constant: 16)
            .centerYToSuperview()
            .activate()
        
        addShadow()
    }
    
    /// Configure the view with the information stored in the view model
    /// - Parameter viewModel: View Model that holds the view's information
    func configure(with viewModel: GradeCardViewModel) {
        backgroundGradientView.color = viewModel.color
        cardGradientView.color = viewModel.color
        gradeLabel.text = viewModel.grade
        gradeTypeLabel.text = GlobalStrings.grade.localized
        messageLabel.text = viewModel.message
        // backgroundColor = viewModel.color.withAlphaComponent(0.2)
        
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
