//
//  MainViewContract.swift
//  TheFepiTest
//
//  Created by stefano.salim on 18/07/21.
//

import Foundation

protocol MainViewModelAction: AnyObject {
    func setupView()
    func setupTabBar(with model: FTTabBarModel)
    func setupIssuesContent(with viewModel: SearchResultViewModel)
    func setupListContent(for activeIndex:Int, viewModel: SearchResultViewModel)
    func setActiveIssueList()
    func setActiveReposList()
    func isListViewControllerDisplaying(for index: Int) -> Bool
}

protocol MainViewModelProtocol: AnyObject {
    var action: MainViewModelAction? {get set}
    
    func onLoad()
    
    func onSearch(with query: String)
    
    func onTabDidTapped(with index: Int)
}
