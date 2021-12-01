//
//  SearchRepoViewController.swift
//  Find Repo
//
//  Created by Ravi Kumar on 30/11/21.
//

import UIKit

class SearchRepoViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var suggestionsTableView: UITableView!
    private let viewModel = RepositoriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
    }
    
    private func configureViewModel() {
        viewModel.reloadTableView = { [unowned self] in
            DispatchQueue.main.async {
                suggestionsTableView.reloadData()
            }
        }
        viewModel.showError = { [unowned self] message in
            DispatchQueue.main.async {
                showAlertWith(message: message)
            }
        }
    }
    
    private func showAlertWith(message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { UIAlertAction in }))
        present(alert, animated: true, completion: nil)
    }
    
    func presentRepoDetails(repo: RepositoryViewModel)  {
        view.endEditing(true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(identifier: "RepositoryDetailController") as? RepositoryDetailController else {return}
        controller.repository = repo
        present(controller, animated: true, completion: nil)
    }
}

extension SearchRepoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        viewModel.requestDataFor(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.requestDataFor(text: "")
    }
}

extension SearchRepoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryRecordCell.reusableIdentifier) as? RepositoryRecordCell else { return UITableViewCell() }
        cell.configureCellFor(data: viewModel.getRepositoryViewModel(at: indexPath))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentRepoDetails(repo: viewModel.getRepositoryViewModel(at: indexPath))
    }
}
