//
//  GradientView.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradientView: UIView {
    // MARK: Properties
    /// Main color of the gradient
    var color: UIColor = .white
    /// Light color of gradient
    private var lightColor: UIColor {
        return color
    }
    /// Dark color of gradient
    private var darkColor: UIColor {
        return color.darker(by: 40) ?? color
    }
    // private var motionManager = CMMotionManager()
    /// Start point of gradient
    private var startPoint = CGPoint(x: 0.5, y: 1)
    /// End point of gradient
    private var endPoint = CGPoint(x: 0.5, y: 0.0)
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // startMotionUpdates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Draw the gradient
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = [darkColor.cgColor, lightColor.cgColor]
    }
    
    /// Set position of gradient when mouse hovers over the view
    /// - Parameter position: Hover position
    func didHover(_ position: CGPoint) {
        startPoint = position
        setNeedsLayout()
    }
    
    /// Reset gradient position when hovering ends
    func reset() {
        startPoint = CGPoint(x: 0.5, y: 1)
        endPoint = CGPoint(x: 0.5, y: 0.0)
        UIView.animate(withDuration: 1) {
            self.setNeedsLayout()
        }
    }
    
    /// Starts obtaining motion data for the gradient
    //    private func startMotionUpdates() {
    //        if let operationQueue = OperationQueue.current, motionManager.isAccelerometerAvailable {
    //            motionManager.startAccelerometerUpdates(to: operationQueue) { (data, error) in
    //                if let data = data {
    //                    let rotation = abs(atan2(data.acceleration.x,
    //                    data.acceleration.y) - .pi)
    //
    //                    self.startPoint = CGPoint(x: rotation / 6, y: rotation / 6 + 0.5)
    //                    self.layoutSubviews()
    //                }
    //            }
    //        }
    //    }
}
