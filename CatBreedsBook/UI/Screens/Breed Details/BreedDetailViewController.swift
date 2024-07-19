//
//  BreedDetailViewController.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//

import UIKit
import Combine

final class BreedDetailViewController: UITableViewController {
    
    private let viewModel: BreedDetailViewModel
    private let imageLoader: ImageLoaderProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: BreedDetailViewModel, imageLoader: ImageLoaderProtocol) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        title = viewModel.getBreedName()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        tableView.allowsSelection = false
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: DescriptionCell.identifier)
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.identifier)
    }

    private func bindViewModel() {
        viewModel.$imageURLs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.imageURLs.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.identifier, for: indexPath) as! DescriptionCell
            cell.configure(with: viewModel.breed?.breedDescription ?? "")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
            let url = viewModel.imageURLs[indexPath.row]
            cell.photoImageView.loadImage(from: url, with: imageLoader)
            return cell
        default:
            fatalError("Unexpected section")
        }
    }
}
