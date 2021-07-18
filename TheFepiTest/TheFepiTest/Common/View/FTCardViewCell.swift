//
//  FTCardViewCell.swift
//  TheFepiTest
//
//  Created by stefano.salim on 18/07/21.
//

import UIKit

struct FTCardViewCellModel {
    var imageUrl: String?
    var title: String
    var subtitle: String
    var infoText: String?
    var multipleInfoText: [String]?
    var isMultipleInfoText: Bool
}

extension FTCardViewCellModel {
    
    init() {
        imageUrl = nil
        title = ""
        subtitle = ""
        isMultipleInfoText = false
    }
}

class FTCardViewCell: UICollectionViewCell {
    
    var model: FTCardViewCellModel
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .ftGreyLight
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    lazy var midContentStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16.0
        
        return stackView
    }()
    
    lazy var rightContentStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16.0
        stackView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        stackView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .horizontal)
        
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16.0)
        
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11.0)
        
        return label
    }()
    
    override init(frame: CGRect) {
        model = FTCardViewCellModel()
        
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(with model: FTCardViewCellModel) {
        self.model = model
        
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        setupRightInfo()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for arrangedSubview in rightContentStackView.arrangedSubviews {
            rightContentStackView.removeArrangedSubview(arrangedSubview)
        }
    }
}

extension FTCardViewCell {
    
    class func getHeight() -> CGFloat {
        return 96.0
    }
}

private extension FTCardViewCell {
    
    func setupView() {
        
        addImageView()
        addMidContentStackView()
        addRightInfoStackView()
        setupRoundedCard()
    }
    
    func setupRoundedCard() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 4.0
    }
    
    func addImageView() {
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            imageView.widthAnchor.constraint(equalToConstant: 64.0),
            imageView.heightAnchor.constraint(equalToConstant: 64.0)
        ])
    }
    
    func addMidContentStackView() {
        
        contentView.addSubview(midContentStackView)
        NSLayoutConstraint.activate([
            midContentStackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            midContentStackView.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8.0)
        ])
    }
    
    func addRightInfoStackView() {
        
        contentView.addSubview(rightContentStackView)
        NSLayoutConstraint.activate([
            rightContentStackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            rightContentStackView.leftAnchor.constraint(equalTo: midContentStackView.rightAnchor, constant: 8.0),
            rightContentStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0)
        ])
    }
    
    func setupRightInfo() {
        
        if self.model.isMultipleInfoText {
            
            guard let multipleInfoText = model.multipleInfoText else { return }
            
            for infoText in multipleInfoText {
                let infoTextLabel = getInfoTextLabel(for: true, text: infoText)
                rightContentStackView.addArrangedSubview(infoTextLabel)
            }
        }
        else {
            guard let infoText = model.infoText else { return }
            
            let infoTextLabel = getInfoTextLabel(for: true, text: infoText)
            rightContentStackView.addArrangedSubview(infoTextLabel)
        }
    }
    
    func getInfoTextLabel(for multipleInfoText:Bool, text:String) -> UILabel {
        
        let label: UILabel = UILabel()
        label.font = (multipleInfoText) ? .systemFont(ofSize: 12.0) : .systemFont(ofSize: 11.0)
        label.textColor = .ftPinkLight
        label.text = text
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .horizontal)
        
        return label
    }
}
