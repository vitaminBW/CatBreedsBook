//
//  BreedListViewController.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//

import Foundation
import UIKit
import Combine

final class BreedListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: BreedListViewModel
    private let imageLoader: ImageLoaderProtocol
    private let router: RouterProtocol
    
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: BreedListViewModel, imageLoader: ImageLoaderProtocol, router: RouterProtocol) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        self.router = router
        super.init(nibName: "BreedListViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
        
        viewModel.fetchBreeds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }

    private func setupUI() {
        title = "main_breeds_list_title".localized
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BreedTableViewCell.self, forCellReuseIdentifier: BreedTableViewCell.identifier)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
    }

    private func bindViewModel() {
        viewModel.$breeds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension BreedListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BreedTableViewCell.identifier, for: indexPath) as? BreedTableViewCell else {
            return UITableViewCell()
        }
        let breedDTO = viewModel.breeds[indexPath.row]
        cell.configure(with: breedDTO, imageLoader: imageLoader)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let breedDTO = viewModel.breeds[indexPath.row]
        router.navigateToBreedDetail(with: breedDTO)
    }
}
