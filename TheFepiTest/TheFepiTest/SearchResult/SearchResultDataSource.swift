//
//  SearchResultDataSource.swift
//  TheFepiTest
//
//  Created by stefano.salim on 18/07/21.
//

import Foundation
import UIKit

class SearchResultDataSource: NSObject, UICollectionViewDataSource {
    
    var cellModels: [FTCardViewCellModel]
    
    override init() {
        cellModels = []
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellModels.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let searchResultCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: FTCardViewCell.description(), for: indexPath) as? FTCardViewCell else {
            
            return UICollectionViewCell()
        }
        
        searchResultCardCell.setupView(with: cellModels[indexPath.item])
        
        return searchResultCardCell
    }
}
