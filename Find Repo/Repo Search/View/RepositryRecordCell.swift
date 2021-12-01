//
//  RepositoryRecordCell.swift
//  Find Repo
//
//  Created by Ravi Kumar on 30/11/21.
//

import Foundation
import UIKit
class RepositoryRecordCell: UITableViewCell {
    
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    
    func configureCellFor(data: RepositoryViewModel) {
        repoNameLabel.text = data.name
        repoDescriptionLabel.text = data.description
    }
}

extension RepositoryRecordCell {
    public static let reusableIdentifier = "RepositoryRecordCell"
}
