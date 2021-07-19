//
//  SearchResultViewModel.swift
//  TheFepiTest
//
//  Created by stefano.salim on 18/07/21.
//

protocol SearchResultViewModelDelegate: AnyObject {
    
    func searchResultReachingEndOfList()
}

extension SearchResultViewModelDelegate {
    func searchResultReachingEndOfList() {}
}

final class SearchResultViewModel {
    var action: SearchResultViewModelAction?
    
    var dataSource: SearchResultDataSource
    
    weak var delegate: SearchResultViewModelDelegate?
    
    init(with dataSource: SearchResultDataSource) {
        self.dataSource = dataSource
    }
}

extension SearchResultViewModel: SearchResultViewModelProtocol {

    func onLoad() {
        
        action?.updateDataSource(dataSource)
        action?.setupView()
    }
    
    func onReachingEndOfList() {
        
        delegate?.searchResultReachingEndOfList()
    }
}
