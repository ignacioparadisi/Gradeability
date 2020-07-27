//
//  CircularSliderTableViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class CircularSliderTableViewCellViewModel {
    @Published var grade: Float = 0.0 {
        didSet {
            updateView?()
        }
    }
    var minGrade: Float = 0.0 {
        didSet {
            updateView?()
        }
    }
    var maxGrade: Float = 0.0 {
        didSet {
            updateView?()
        }
    }
    var updateView: (() -> Void)?
    var title: String {
        return GlobalStrings.grade.localized
    }
    var tintColor: UIColor {
        return UIColor.getColor(for: grade, minGrade: minGrade, maxGrade: maxGrade)
    }
    
    init(grade: Float) {
        self.grade = grade
    }
}

class CircularSliderTableViewCell: UITableViewCell, ReusableView {
    
    private var viewModel: CircularSliderTableViewCellViewModel!
    private let circularSlider = CircularSlider()
    private var subscriptions = Set<AnyCancellable>()
    var gestureDelegate: UIGestureRecognizerDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        contentView.addSubview(circularSlider)
        let multiplier: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 0.8 : 0.5
        circularSlider.anchor
            .centerXToSuperview()
            .topToSuperview(constant: 30)
            .bottomToSuperview(constant: 40)
            .width(to: contentView.widthAnchor, multiplier: multiplier)
            .height(to: circularSlider.widthAnchor)
            .activate()
        
        setupSlider()
    }
    
    private func setupSlider() {
        circularSlider.lineWidth = 40
        circularSlider.minimumValue = 0
        circularSlider.knobRadius = 50
        circularSlider.bgColor = .systemGray4
    }
    
    func configure(with viewModel: CircularSliderTableViewCellViewModel) {
        self.viewModel = viewModel
        circularSlider.title = viewModel.title.uppercased()
        circularSlider.setValue(viewModel.grade, animated: true)
        if subscriptions.isEmpty {
            circularSlider.$publishedValue
                .receive(on: RunLoop.main)
                .assign(to: \.grade, on: viewModel)
                .store(in: &subscriptions)
        }
        viewModel.updateView = { [weak self] in
            self?.updateView()
        }
    }
    
    private func updateView() {
        circularSlider.maximumValue = viewModel.maxGrade
        circularSlider.pgHighlightedColor = viewModel.tintColor
    }
}
