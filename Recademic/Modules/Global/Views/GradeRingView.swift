//
//  GradeRingView.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/9/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import SwiftUI

class GradeRingView: UIView {
    /// The start angle of the grade graph
    private let startAngle: CGFloat = 5/6 * CGFloat.pi
    /// The end angle of the grade graph
    private let endAngle: CGFloat = 13/6 * CGFloat.pi
    /// The grade is multiplied by this angle to place the chart in the correct place
    private let constantAngle: CGFloat = 4/3 * CGFloat.pi
    /// The radius of the graph
    private var radius: CGFloat = 22
    private let lineWidth: CGFloat = 7
    private let contentView = UIView()
    private var sizeMultiplier: CGFloat {
        return radius * 2 / 44
    }
    /// Label for the subject's grade
    private let gradeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    private var gradeShapeLayer: CAShapeLayer = CAShapeLayer()

    init(radius: CGFloat) {
        super.init(frame: .zero)
        self.radius = radius
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        contentView.backgroundColor = .clear
        addSubview(contentView)
        contentView.anchor
            .height(constant: radius * 2)
            .width(constant: radius * 2)
            .trailingToSuperview()
            .bottomToSuperview(constant: 5)
            .leadingToSuperview()
            .activate()
        
        contentView.addSubview(gradeLabel)
        gradeLabel.anchor
            .centerX(to: contentView.centerXAnchor)
            .centerY(to: contentView.centerYAnchor)
            .activate()
        
        let circleCenter = CGPoint(x: radius, y: radius)
        let backgroundShapeLayer = CAShapeLayer()
        let backgroundCircularPath = UIBezierPath(arcCenter: circleCenter,
                                                  radius: radius,
                                                  startAngle: startAngle,
                                                  endAngle: endAngle,
                                                  clockwise: true)
        backgroundShapeLayer.path = backgroundCircularPath.cgPath
        backgroundShapeLayer.fillColor = UIColor.clear.cgColor
        backgroundShapeLayer.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        backgroundShapeLayer.lineWidth = lineWidth
        backgroundShapeLayer.lineCap = .round
        contentView.layer.addSublayer(backgroundShapeLayer)
        
        gradeShapeLayer.fillColor = UIColor.clear.cgColor
        gradeShapeLayer.lineWidth = lineWidth
        gradeShapeLayer.strokeEnd = 0
        gradeShapeLayer.lineCap = .round
        contentView.layer.addSublayer(gradeShapeLayer)
        
    }
    
    func configure(with viewModel: GradeRingViewModel) {
        gradeLabel.text = viewModel.grade
        let circleCenter = CGPoint(x: radius, y: radius)
        let circularPath = UIBezierPath(arcCenter: circleCenter,
                                        radius: radius,
                                        startAngle: startAngle,
                                        endAngle: startAngle + constantAngle * viewModel.angleMultiplier,
                                        clockwise: true)
        gradeShapeLayer.path = circularPath.cgPath
        gradeShapeLayer.strokeColor = viewModel.color.cgColor
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 0.5
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        gradeShapeLayer.add(basicAnimation, forKey: "animation")
    }
}
