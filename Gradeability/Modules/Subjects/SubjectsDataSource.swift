//
//  SubjectsDataSource.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/8/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class SubjectsDataSource: UITableViewDiffableDataSource<GradablesViewController.Sections, AnyHashable> {
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let section = GradablesViewController.Sections(rawValue: indexPath.section)
        guard section == .gradables else { return }
        if editingStyle == .delete {
            print("Delete")
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let section = GradablesViewController.Sections(rawValue: indexPath.section)
        return section == .gradables
    }

}
