//
//  Router.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//

import Foundation
import UIKit

protocol RouterProtocol {
    
    func navigateToBreedDetail(with breedDTO: BreedDTO)
    func createBreedListView() -> UIViewController
}

final class Router: RouterProtocol {
    
    private let navigationController: UINavigationController
    private let container: DependencyContainer
    
    init(navigationController: UINavigationController, container: DependencyContainer) {
        self.navigationController = navigationController
        self.container = container
        
        setupNavigationBar()
    }
    
    func navigateToBreedDetail(with breedDTO: BreedDTO) {
        let breedDetailViewModel = container.resolve(BreedDetailViewModel.self, argument: breedDTO)
        let breedDetailViewController = BreedDetailViewController(viewModel: breedDetailViewModel, imageLoader: container.resolve(ImageLoaderProtocol.self))
        navigationController.pushViewController(breedDetailViewController, animated: true)
    }
    
    func createBreedListView() -> UIViewController {
        let breedListViewModel = container.resolve(BreedListViewModel.self)
        let breedListViewController = BreedListViewController(viewModel: breedListViewModel, imageLoader: container.resolve(ImageLoaderProtocol.self), router: self)
        return breedListViewController
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor(named: "navBarColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationBar.tintColor = .white
    }
}
