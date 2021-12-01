//
//  RepositiryViewModel.swift
//  Find Repo
//
//  Created by Ravi Kumar on 30/11/21.
//

import Foundation
import UIKit

class RepositoriesViewModel {
    var items: [Item] = [Item]()
    private var timer: Timer?
    var reloadTableView: (()->())?
    var showError: ((String)->())?
    private let networkClient = NetworkClient()
    private var isRequestAllowed = true
    
    // MARK: - Keeping view model for single repository
    private var repositoryViewModels: [RepositoryViewModel] = [RepositoryViewModel]() {
        didSet {
            self.reloadTableView?()
        }
    }
    
    private func blockNexRequestWithTimeInterval(){
        isRequestAllowed = false
        self.timer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true, block: {[unowned self] _timer in
            isRequestAllowed = true
            _timer.invalidate()
        })
    }
    
    // MARK: - Requesting server for repos
    func requestDataFor(text: String){
        if text.count == 0 {
            repositoryViewModels = []
            self.reloadTableView?()
            return
        }
        
        if !isRequestAllowed {
            filterAvailableRepoFor(text: text)
            return
        }
        networkClient.makeSearchRequestFor(text: text, handler: { [unowned self] response, error in
            if let data = response?.items {
                DispatchQueue.main.async {
                blockNexRequestWithTimeInterval()
                }
                items.append(contentsOf: data)
                self.createItemViewModel(datas: data)
                self.reloadTableView?()
            } else if let err = error {
                if items.count > 0 {
                    DispatchQueue.main.async {
                    blockNexRequestWithTimeInterval()
                    }
                }
                self.showError?(err.description)
            }
            else {
                self.showError?(NetworkError.other.description)
            }
        })
    }
    
    private func filterAvailableRepoFor(text: String) {
        let filteredItems = items.filter { item in
            return item.full_name.lowercased().contains(text.lowercased()) || item.description.lowercased().contains(text.lowercased())
        }
        if filteredItems.count == 0 && !isRequestAllowed {
            isRequestAllowed = true
            timer?.invalidate()
        }
        createItemViewModel(datas: filteredItems)
        self.reloadTableView?()
    }
    
    var numberOfRows: Int {
        return repositoryViewModels.count > 5 ? 5 : repositoryViewModels.count
    }
    
    func getRepositoryViewModel( at indexPath: IndexPath ) -> RepositoryViewModel {
        return repositoryViewModels[indexPath.row]
    }
    
    func createItemViewModel(datas: [Item]){
        var vms = [RepositoryViewModel]()
        for data in datas {
            vms.append(RepositoryViewModel(item: data))
        }
        repositoryViewModels = vms
    }
}


class RepositoryViewModel {
    private let item: Item
    init(item: Item) {
        self.item = item
    }
    var fullName: String { item.full_name }
    var name: String { item.name }
    var description: String { item.description }
    var lanugage: String { item.language ?? ""}
    var visibilityStatus: String { item.visibility.rawValue }
    var owner_login: String {item.owner.login}
}
