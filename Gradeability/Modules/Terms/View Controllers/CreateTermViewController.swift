//
//  CreateTermViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/3/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class CreateTermViewController: UIViewController {
    
    let viewModel: CreateTermViewModel = CreateTermViewModel()
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Create Term"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(dismissView))
//        navigationItem.rightBarButtonItem?.isEnabled = false
//        setupViewModel()
//        setupForm()
//    }
//
//    @objc private func dismissView() {
//        dismiss(animated: true)
//    }
//
//    private func setupViewModel() {
//        viewModel.canSaveDidChange = { [weak self] canSave in
//            self?.navigationItem.rightBarButtonItem?.isEnabled = canSave
//        }
//    }
//
//    private func setupForm() {
//        form +++ Section()
//            <<< TextRow { row in
//                row.title = "Nombre"
//                let ruleRequiredViaClosure = RuleClosure<String> { rowValue in
//                return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: "Field required!") : nil
//                }
//                row.add(rule: ruleRequiredViaClosure)
//            }.onChange { [weak self] row in
//                self?.viewModel.name = row.value ?? ""
//            }
//            .cellUpdate { cell, row in
//                if !row.isValid {
//                    cell.titleLabel?.textColor = .systemRed
//                }
//            }
//            <<< DecimalRow { row in
//                row.title = "Calificación máxima"
//                let ruleRequiredViaClosure = RuleClosure<Double> { rowValue in
//                    return (rowValue == nil || rowValue == 0.0) ? ValidationError(msg: "Field required!") : nil
//                }
//                row.add(rule: ruleRequiredViaClosure)
//            }.onChange { [weak self] row in
//                self?.viewModel.maxGrade = Float(row.value ?? 0)
//            }
//            .cellUpdate { cell, row in
//                if !row.isValid {
//                    cell.titleLabel?.textColor = .systemRed
//                }
//            }
//            <<< DecimalRow { row in
//                row.title = "Calificación mínima para pasar"
//            }.onChange { [weak self] row in
//                self?.viewModel.minGrade = Float(row.value ?? 0)
//            }
//            .cellUpdate { cell, row in
//                if !row.isValid {
//                    cell.titleLabel?.textColor = .systemRed
//                }
//            }
//    }
    
}

