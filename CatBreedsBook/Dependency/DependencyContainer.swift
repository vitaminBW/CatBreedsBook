//
//  DependencyContainer.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//

import Foundation
import CoreData
import Swinject

class DependencyContainer {
    
    private let container: Container
    
    init() {
        container = Container()
        registerDependencies()
    }
    
    private func registerDependencies() {
        container.register(NetworkServiceProtocol.self) { _ in
            NetworkService()
        }
        
        container.register(CoreDataHelperProtocol.self) { _ in
            CoreDataHelper(containerName: "CatBreedsBook")
        }
        
        container.register(ImageRepositoryProtocol.self) { _ in
            let storage = CombinedImageStorage(memoryLimit: 50 * 1024 * 1024)
            return CombinedImageRepository(storage: storage)
        }
        
        container.register(BreedRepositoryProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            let coreDataHelper = resolver.resolve(CoreDataHelperProtocol.self)!
            return BreedRepository(networkService: networkService, coreDataHelper: coreDataHelper)
        }
        
        container.register(BreedListViewModel.self) { resolver in
            let breedRepository = resolver.resolve(BreedRepositoryProtocol.self)!
            return BreedListViewModel(repository: breedRepository)
        }
        
        container.register(BreedDetailViewModel.self) { (resolver, breedDTO: BreedDTO) in
            let breedRepository = resolver.resolve(BreedRepositoryProtocol.self)!
            return BreedDetailViewModel(repository: breedRepository, breedDTO: breedDTO)
        }
        
        container.register(ImageLoaderProtocol.self) { resolver in
            let imageRepository = resolver.resolve(ImageRepositoryProtocol.self)!
            return ImageLoader(imageRepository: imageRepository)
        }
    }
    
    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = container.resolve(serviceType) else {
            fatalError("Dependency not found: \(serviceType)")
        }
        return service
    }
    
    func resolve<Service, Argument>(_ serviceType: Service.Type, argument: Argument) -> Service {
        guard let service = container.resolve(serviceType, argument: argument) else {
            fatalError("Dependency not found: \(serviceType)")
        }
        return service
    }
}
