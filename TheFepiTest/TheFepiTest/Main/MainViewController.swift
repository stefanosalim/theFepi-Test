//
//  MainViewController.swift
//  TheFepiTest
//
//  Created by stefano.salim on 17/07/21.
//

import UIKit

class MainViewController: UIViewController {
    
    public var viewModel: MainViewModelProtocol
    
    var issuesViewController: SearchResultViewController?
    
    var reposViewController: SearchResultViewController?
    
    lazy var searchBarContainerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ftGreyDark
        
        return view
    }()
    
    lazy var searchBarView: FTSearchBarView = {
        let model: FTSearchBarModel = FTSearchBarModel(placeholder: "Keyword based project's name")
        let view: FTSearchBarView = FTSearchBarView(with: model)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    lazy var tabBarView: FTTabBarView = {
        let view = FTTabBarView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var contentView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    init(with viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        self.viewModel.action = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onLoad()
    }
}

private extension MainViewController {
    
    func setupDefaultView() {
        view.backgroundColor = .white
    }
    
    func setupSearchBar() {
        view.addSubview(searchBarContainerView)
        NSLayoutConstraint.activate([
            searchBarContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            searchBarContainerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBarContainerView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        searchBarContainerView.addSubview(searchBarView)
        let searchBarSafeLayoutGuide: UILayoutGuide = searchBarContainerView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: searchBarSafeLayoutGuide.topAnchor),
            searchBarView.leftAnchor.constraint(equalTo: searchBarSafeLayoutGuide.leftAnchor),
            searchBarView.rightAnchor.constraint(equalTo: searchBarSafeLayoutGuide.rightAnchor),
            searchBarView.bottomAnchor.constraint(equalTo: searchBarSafeLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupTabBar() {
        view.addSubview(tabBarView)
        NSLayoutConstraint.activate([
            tabBarView.topAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor),
            tabBarView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tabBarView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func addContentView() {
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: tabBarView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func getListViewController(by index:Int) -> SearchResultViewController? {
        return index == 0 ? issuesViewController : reposViewController
    }
    
    func add(_ childViewController: UIViewController) {
        
        addChild(childViewController)
        
        let childView: UIView = childViewController.view
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(childView)
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: contentView.topAnchor),
            childView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            childView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            childView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        
        childViewController.didMove(toParent: self)
    }
    
    func remove(_ childViewController: UIViewController?) {
        
        childViewController?.willMove(toParent: nil)
        childViewController?.view.removeFromSuperview()
        childViewController?.removeFromParent()
    }
}

extension MainViewController: MainViewModelAction {
    
    func setupView() {
        setupDefaultView()
        setupSearchBar()
        setupTabBar()
        addContentView()
    }
    
    func setupTabBar(with model: FTTabBarModel) {
        tabBarView.setupView(with: model)
    }
    
    func setupIssuesContent(with viewModel: SearchResultViewModel) {
        
        issuesViewController = SearchResultViewController(with: viewModel)
        guard let issuesViewController = issuesViewController else { return }
        issuesViewController.collectionView.reloadData()
    }
    
    func setupListContent(for activeIndex: Int, viewModel: SearchResultViewModel) {
        var selectedViewController = getListViewController(by: activeIndex)
        remove(selectedViewController)
        selectedViewController = SearchResultViewController(with: viewModel)
        
        guard let viewController = selectedViewController else { return }
        if activeIndex == 0 {
            issuesViewController = viewController
        }
        else {
            reposViewController = viewController
        }
        add(viewController)
        viewController.collectionView.reloadData()
    }
    
    func setActiveIssueList() {
        
        remove(reposViewController)
        
        guard let issuesViewController = issuesViewController else { return }
        add(issuesViewController)
    }
    
    func setActiveReposList() {
        
        remove(issuesViewController)
        
        guard let reposViewController = reposViewController else { return }
        add(reposViewController)
    }
    
    func isListViewControllerDisplaying(for index: Int) -> Bool {
        guard let listViewController = getListViewController(by: index), let listView = listViewController.viewIfLoaded else {
            return false
        }
        
        return listView.window != nil
    }
}

extension MainViewController: FTSearchBarViewDelegate {
    func ftSearchBarSearch(with text: String) {
        viewModel.onSearch(with: text)
    }
}

extension MainViewController: FTTabBarViewDelegate {
    func ftTabBarViewTabDidActive(at index: Int) {
        viewModel.onTabDidTapped(with: index)
    }
}

