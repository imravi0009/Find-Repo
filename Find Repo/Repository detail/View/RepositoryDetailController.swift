//
//  RepositoryDetailController.swift
//  Find Repo
//
//  Created by Ravi Kumar on 30/11/21.
//

import UIKit

class RepositoryDetailController: UIViewController {
    @IBOutlet private weak var repoNameLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var visibilityStatusLabel: UILabel!
    @IBOutlet private weak var ownerNameLabel: UILabel!
    @IBOutlet private weak var aboutTextView: UITextView!
    var repository: RepositoryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialScreenSetup()
    }

    // MARK: - Update UI for selected repository
    private func initialScreenSetup() {
        guard let repo = repository else {return}
        repoNameLabel.text = repo.name
        languageLabel.text = "Language: \(repo.lanugage)"
        ownerNameLabel.text = "Owner: \(repo.owner_login)"
        aboutTextView.text = repo.description
        visibilityStatusLabel.text = "(\(repo.visibilityStatus))"
    }
    
}


