//
//  BreedTableViewCell.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//

import Foundation
import UIKit

class BreedTableViewCell: UITableViewCell {

    static let identifier = "BreedTableViewCell"

    private let breedImageView: LoadingImageView = {
        let imageView = LoadingImageView(frame: .zero)
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let breedNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let breedDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "breedCellBackgroundColor")
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.addSubview(breedImageView)
        containerView.addSubview(breedNameLabel)
        containerView.addSubview(breedDescriptionLabel)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            breedImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            breedImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            breedImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            breedImageView.heightAnchor.constraint(equalToConstant: 200),
            
            breedNameLabel.topAnchor.constraint(equalTo: breedImageView.bottomAnchor, constant: 10),
            breedNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            breedNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            breedDescriptionLabel.topAnchor.constraint(equalTo: breedNameLabel.bottomAnchor, constant: 5),
            breedDescriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            breedDescriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            breedDescriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        breedImageView.cancelImageLoad()
    }
    
    func configure(with breedDTO: BreedDTO, imageLoader: ImageLoaderProtocol) {
        breedNameLabel.text = breedDTO.name
        breedDescriptionLabel.text = breedDTO.description
        if let url = breedDTO.imageURL {
            breedImageView.loadImage(from: url, with: imageLoader)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        containerView.backgroundColor = selected ? UIColor.gray.withAlphaComponent(0.5) : UIColor(named: "breedCellBackgroundColor")
    }
}
