//
//  FTTabBarView.swift
//  TheFepiTest
//
//  Created by stefano.salim on 18/07/21.
//

import UIKit

struct FTTabBarModel {
    var titles: [String]
    var activeTabIndex: Int
}

protocol FTTabBarViewDelegate: AnyObject {
    func ftTabBarViewTabDidActive(at index:Int)
}

class FTTabBarView: UIView {
    
    weak var delegate: FTTabBarViewDelegate?
    var model: FTTabBarModel?
    var tabs: [UILabel]
    
    lazy var tabStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    init() {
        self.tabs = []
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupView(with model:FTTabBarModel) {
        self.model = model
        setupView()
    }
}

private extension FTTabBarView {
    
    func setupView() {
        
        guard let model = self.model else { return }
        
        populateTabStackView()
        addTabStackViewToView()
        setTabActive(at: model.activeTabIndex)
    }
    
    func addTabStackViewToView() {
        
        addSubview(tabStackView)
        NSLayoutConstraint.activate([
            tabStackView.topAnchor.constraint(equalTo: topAnchor),
            tabStackView.leftAnchor.constraint(equalTo: leftAnchor),
            tabStackView.rightAnchor.constraint(equalTo: rightAnchor),
            tabStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func populateTabStackView() {
        
        guard let model = self.model else { return }
        
        let titles: [String] = model.titles
        
        for i in 0 ..< titles.count {
            let titleLabel: UILabel = getTitleLabel(with: titles[i], index: i)
            setTapRecognizer(at: titleLabel)
            
            tabStackView.addArrangedSubview(titleLabel)
            tabs.append(titleLabel)
        }
    }
    
    func setTapRecognizer(at view:UIView) {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tabDidTapped(_:)))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    func tabDidTapped(_ sender:UITapGestureRecognizer) {
        guard let view: UIView = sender.view else { return }
        
        let index: Int = view.tag
        setTabActive(at: index)
    }
    
    func setTabActive(at index:Int) {
        if index < 0 || index >= tabs.count { return }
        
        for tab in tabs {
            tab.backgroundColor = (tab.tag == index) ? .ftGreyAccent : .white
            tab.textColor = (tab.tag == index) ? .white : .ftGreyAccent
        }
        
        delegate?.ftTabBarViewTabDidActive(at: index)
    }
    
    func getTitleLabel(with title:String, index:Int) -> UILabel {
        let titleLabel: UILabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        titleLabel.isUserInteractionEnabled = true
        titleLabel.text = title;
        titleLabel.tag = index
        titleLabel.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        return titleLabel
    }
}
