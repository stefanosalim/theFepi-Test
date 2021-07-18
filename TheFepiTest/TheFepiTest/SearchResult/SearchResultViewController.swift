//
//  SearchResultViewController.swift
//  TheFepiTest
//
//  Created by stefano.salim on 18/07/21.
//

import UIKit

class SearchResultViewController: UIViewController {

    public var viewModel: SearchResultViewModelProtocol
    
    lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(FTCardViewCell.self, forCellWithReuseIdentifier: FTCardViewCell.description())
        collectionView.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
        
        return collectionView
    }()
    
    init(with viewModel: SearchResultViewModelProtocol) {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
}

private extension SearchResultViewController {
    
    func addCollectionViewToView() {
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SearchResultViewController: SearchResultViewModelAction {
    
    func setupView() {
        addCollectionViewToView()
    }
    
    func updateDataSource(_ dataSource: SearchResultDataSource) {
        collectionView.dataSource = dataSource
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size: CGSize = CGSize(width: UIScreen.main.bounds.width - 32.0, height: FTCardViewCell.getHeight())
        return size
    }
}

