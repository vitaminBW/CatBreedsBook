//
//  LoadingImageView.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 19.07.2024.
//

import UIKit
import Combine

class LoadingImageView: UIImageView {
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var cancellable: AnyCancellable?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        cancellable?.cancel()
    }

    func loadImage(from url: URL, with imageLoader: ImageLoaderProtocol) {
        image = nil
        loadingIndicator.startAnimating()
        cancellable = Future<UIImage?, Never> { promise in
            Task {
                let image = await imageLoader.loadImage(from: url)
                promise(.success(image))
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] image in
            self?.loadingIndicator.stopAnimating()
            self?.image = image ?? UIImage(named: "placeholder_image")
        }
    }

    func cancelImageLoad() {
        cancellable?.cancel()
        cancellable = nil
        loadingIndicator.stopAnimating()
        image = UIImage(named: "placeholder_image")
    }
}
