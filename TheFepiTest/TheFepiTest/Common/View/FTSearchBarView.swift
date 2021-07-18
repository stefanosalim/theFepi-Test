//
//  FTSearchBarView.swift
//  TheFepiTest
//
//  Created by stefano.salim on 18/07/21.
//

import UIKit

struct FTSearchBarModel {
    var placeholder: String
}

protocol FTSearchBarViewDelegate: AnyObject {
    func ftSearchBarSearch(with text:String)
}

class FTSearchBarView: UIView {
    
    weak var delegate: FTSearchBarViewDelegate?
    
    var model: FTSearchBarModel
    
    lazy var searchBar: UISearchBar = {
        let searchBar: UISearchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = model.placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.setTextField(color: .white)
        
        return searchBar
    }()
    
    lazy var searchButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 8.0, bottom: 6.0, right: 8.0)
        button.addTarget(self, action: #selector(searchButtonDidTapped), for: .touchUpInside)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 4.0
        
        return button
    }()
    
    init(with model: FTSearchBarModel) {
        self.model = model
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 8.0),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.leftAnchor.constraint(equalTo: searchBar.rightAnchor),
            searchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0),
            searchButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc
    func searchButtonDidTapped() {
        let searchText: String = searchBar.text ?? ""
        delegate?.ftSearchBarSearch(with: searchText)
    }
}
