//
//  SearchResultViewModel.swift
//  TheFepiTest
//
//  Created by stefano.salim on 18/07/21.
//

final class SearchResultViewModel {
    var action: SearchResultViewModelAction?
    
    var dataSource: SearchResultDataSource
    
    init(with dataSource: SearchResultDataSource) {
        self.dataSource = dataSource
    }
}

extension SearchResultViewModel: SearchResultViewModelProtocol {

    func onLoad() {
        
        action?.updateDataSource(dataSource)
        action?.setupView()
    }
}
