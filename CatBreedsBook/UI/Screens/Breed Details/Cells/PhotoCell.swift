//
//  PhotoCell.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//

import UIKit

class PhotoCell: UITableViewCell {
    
    static let identifier = "PhotoCell"

    let photoImageView: LoadingImageView = {
        let imageView = LoadingImageView(frame: .zero)
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            photoImageView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.cancelImageLoad()
    }
}
