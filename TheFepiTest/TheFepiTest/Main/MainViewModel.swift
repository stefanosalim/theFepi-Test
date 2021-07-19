//
//  MainViewModel.swift
//  TheFepiTest
//
//  Created by stefano.salim on 18/07/21.
//

import UIKit

class MainViewModel {
    var action: MainViewModelAction?
    
    var activeIndex: Int = 0
    
    var issuePage: Int = 1
    var repoPage: Int = 1
    
    var lastIssueQuery: String = ""
    var lastRepoQuery: String = ""
    
    lazy var activeChildViewModel: SearchResultViewModel = {
        return activeIndex == 0 ? issuesViewModel : reposViewModel
    }()
    
    lazy var issuesViewModel: SearchResultViewModel = {
    
        let viewModel: SearchResultViewModel = SearchResultViewModel(with: SearchResultDataSource())
        viewModel.delegate = self
        return viewModel
    }()
    
    lazy var reposViewModel: SearchResultViewModel = {
    
        let viewModel: SearchResultViewModel = SearchResultViewModel(with: SearchResultDataSource())
        viewModel.delegate = self
        return viewModel
    }()
}

private extension MainViewModel {
    
    func setupTabBar() {
        
        let model: FTTabBarModel = FTTabBarModel(titles: ["issues", "repositories"], activeTabIndex: 0)
        action?.setupTabBar(with: model)
    }
    
    func setupListContent(with cellModels:[FTCardViewCellModel]) {
        
        activeChildViewModel.dataSource.cellModels = cellModels
        action?.setupListContent(for: activeIndex, viewModel: activeChildViewModel)
    }
    
    func handleIssueResponse(response: GithubIssueResponse) {
        
        var issueListModel:[FTCardViewCellModel] = []
        for item in response.items {
            let issueCellModel: FTCardViewCellModel = getIssue(from: item)
            issueListModel.append(issueCellModel)
        }
        
        setupListContent(with: issueListModel)
    }
    
    func appendIssueResponse(response: GithubIssueResponse) {
        
        var issueListModel:[FTCardViewCellModel] = []
        for item in response.items {
            let issueCellModel: FTCardViewCellModel = getIssue(from: item)
            issueListModel.append(issueCellModel)
        }
        
        activeChildViewModel.dataSource.cellModels.append(contentsOf: issueListModel)
        action?.reloadList(for: activeIndex)
    }
    
    func fetchIssue(query:String, page:Int) {
        
        let spec: GithubIssueSpec = GithubIssueSpec(query: query, page: page, perPage: 10)
        fetchIssues(spec: spec) { [weak self] (response: GithubIssueResponse) in
            
            self?.handleIssueResponse(response: response)
        }
    }
    
    func fetchIssues(spec:GithubIssueSpec, completion: @escaping (GithubIssueResponse) -> ()) {
        
        let urlString: String = String(format: "https://api.github.com/search/issues?q=%@&page=%ld&per_page=%ld", spec.query, spec.page, spec.perPage)
        FTNetworkManager.shared.fetch(urlString: urlString, completion: completion)
    }
    
    func getIssue(from itemResponse:GithubIssueItem) -> FTCardViewCellModel {
        
        let cellIssueModel: FTCardViewCellModel = FTCardViewCellModel(imageUrl: nil,
                                                                      title: itemResponse.title,
                                                                      subtitle: itemResponse.updatedAt,
                                                                      infoText: itemResponse.state,
                                                                      multipleInfoText: nil,
                                                                      isMultipleInfoText: false)
        return cellIssueModel
    }
    
    func handleRepoResponse(response: GithubRepoResponse) {
        
        var issueListModel:[FTCardViewCellModel] = []
        for item in response.items {
            let issueCellModel: FTCardViewCellModel = getRepo(from: item)
            issueListModel.append(issueCellModel)
        }
        
        setupListContent(with: issueListModel)
    }
    
    func appendRepoResponse(response: GithubRepoResponse) {
        
        var repoListModel:[FTCardViewCellModel] = []
        for item in response.items {
            let repoCellModel: FTCardViewCellModel = getRepo(from: item)
            repoListModel.append(repoCellModel)
        }
        
        activeChildViewModel.dataSource.cellModels.append(contentsOf: repoListModel)
        action?.reloadList(for: activeIndex)
    }
    
    func fetchRepos(query:String, page:Int) {
        
        let spec: GithubRepoSpec = GithubRepoSpec(query: query, page: page, perPage: 10)
        fetchRepos(spec: spec) { [weak self] (response: GithubRepoResponse) in
            
            self?.handleRepoResponse(response: response)
        }
    }
    
    func fetchRepos(spec:GithubRepoSpec, completion: @escaping (GithubRepoResponse) -> ()) {
        
        let urlString: String = String(format: "https://api.github.com/search/repositories?q=%@&page=%ld&per_page=%ld", spec.query, spec.page, spec.perPage)
        FTNetworkManager.shared.fetch(urlString: urlString, completion: completion)
    }
    
    func getRepo(from itemResponse:GithubRepoItem) -> FTCardViewCellModel {
        let watchText: String = String(format: "Watchers: %ld", itemResponse.watchers)
        let starText: String = String(format: "Stars: %ld", itemResponse.stars)
        let forkText: String = String(format: "Forks: %ld", itemResponse.forks)
        let cellIssueModel: FTCardViewCellModel = FTCardViewCellModel(imageUrl: nil,
                                                                      title: itemResponse.name,
                                                                      subtitle: itemResponse.createdAt,
                                                                      infoText: nil,
                                                                      multipleInfoText: [watchText, starText, forkText],
                                                                      isMultipleInfoText: true)
        return cellIssueModel
    }
}

extension MainViewModel: MainViewModelProtocol {
    
    func onLoad() {
        
        action?.setupView()
        setupTabBar()
    }
    
    func onSearch(with query:String) {
        
        if activeIndex == 0 {
            
            issuePage = 1
            fetchIssue(query: query, page: issuePage)
            lastIssueQuery = query
        }
        else {
            
            repoPage = 1
            fetchRepos(query: query, page: repoPage)
            lastRepoQuery = query
        }
    }
    
    func onTabDidTapped(with index: Int) {
        
        activeIndex = index
        
        if index == 0 {
            
            action?.setActiveIssueList()
        }
        else {
            
            action?.setActiveReposList()
        }
    }
}

extension MainViewModel: SearchResultViewModelDelegate {
    
    func searchResultReachingEndOfList() {
        
        if activeIndex == 0 {
            issuePage += 1
            fetchIssues(spec: GithubIssueSpec(query: lastIssueQuery, page: issuePage, perPage: 10)) { [weak self] (response: GithubIssueResponse) in
                self?.appendIssueResponse(response: response)
            }
        }
        else {
            repoPage += 1
            fetchRepos(spec: GithubRepoSpec(query: lastRepoQuery, page: repoPage, perPage: 10)) { [weak self] (response: GithubRepoResponse) in
                
                self?.appendRepoResponse(response: response)
            }
        }
    }
}
