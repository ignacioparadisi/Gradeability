//
//  GradableCellSecondaryView.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class ProgressLineView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1).bold
        return label
    }()
    private let progressView: UIProgressView = {
        let view = UIProgressView()
        view.backgroundColor = .systemGray3
        return view
    }()
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(titleLabel)
        addSubview(progressView)
        addSubview(progressLabel)
        
         titleLabel.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()

        progressView.anchor
            .top(to: titleLabel.bottomAnchor, constant: 8)
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()

        progressLabel.anchor
            .top(to: progressView.bottomAnchor, constant: 3)
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
            .activate()
    }
    
    func configure(with title: String, progress: Float, progressText: String? = nil) {
        titleLabel.text = title.uppercased()
        progressView.progress = progress
        progressLabel.text = progressText
    }
}

class GradableCellSecondaryView: UIView {
    private let verticalMargin: CGFloat = 15.0
    private let horizontalMargin: CGFloat = 20.0
    
    private let contentView: UIView = UIView()
    private var progressLineView: ProgressLineView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(contentView)
        setupContentView()
    }
    
    private func setupContentView() {
        progressLineView = ProgressLineView()
        contentView.addSubview(progressLineView)
        
        contentView.anchor
            .topToSuperview(constant: 8)
            .trailingToSuperview(constant: -horizontalMargin)
            .bottomToSuperview(constant: -8)
            .leadingToSuperview(constant: horizontalMargin)
            .activate()
        
        progressLineView.anchor.edgesToSuperview().activate()
    }
    
    func configure(with title: String, progress: Float, progressText: String? = nil) {
        progressLineView.configure(with: title, progress: progress, progressText: progressText)
    }
}
