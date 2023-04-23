//
//  RMCharacterInfoCollectionViewCell.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 22/04/23.
//

import UIKit

final class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterInfoCollectionViewCell"
    
    private let valueLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Earth"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .light)
        return label
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let iconImage:UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "globe.americas")
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    private let titleContainer:UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.addSubviews(titleContainer,valueLabel,iconImage)
        titleContainer.addSubview(titleLabel)
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),
            
            titleLabel.leftAnchor.constraint(equalTo: titleContainer.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: titleContainer.rightAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor),
            
            iconImage.heightAnchor.constraint(equalToConstant: 30),
            iconImage.widthAnchor.constraint(equalToConstant: 30),
            iconImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 35 ),
            iconImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            
            valueLabel.leftAnchor.constraint(equalTo: iconImage.rightAnchor,constant: 10),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -10),
            valueLabel.centerYAnchor.constraint(equalTo: iconImage.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
        iconImage.image = nil
        iconImage.tintColor = .label
        titleLabel.textColor = .label
    }
    
    public func configure(with viewModel: RMCharacterInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.displayValue
        iconImage.image = viewModel.iconImage
        iconImage.tintColor = viewModel.tintColor
        titleLabel.textColor = viewModel.tintColor
    }
}
