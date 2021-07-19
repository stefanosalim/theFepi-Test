//
//  SearchResultContract.swift
//  TheFepiTest
//
//  Created by stefano.salim on 18/07/21.
//
import Foundation

protocol SearchResultViewModelAction: AnyObject {
    func setupView()
    func updateDataSource(_ dataSource: SearchResultDataSource)
}

protocol SearchResultViewModelProtocol: AnyObject {
    var action: SearchResultViewModelAction? {get set}
    
    func onLoad()
    
    func onReachingEndOfList()
}


