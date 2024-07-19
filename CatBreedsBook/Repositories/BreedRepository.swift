//
//  BreedRepository.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//

import Foundation
import Combine
import CoreData

protocol BreedRepositoryProtocol {
    
    func fetchBreeds() -> AnyPublisher<[Breed], Error>
    func fetchBreed(by id: String) -> AnyPublisher<Breed?, Error>
}

final class BreedRepository: BreedRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let coreDataHelper: CoreDataHelperProtocol
    
    private var cancellables = Set<AnyCancellable>()

    init(networkService: NetworkServiceProtocol, coreDataHelper: CoreDataHelperProtocol) {
        self.networkService = networkService
        self.coreDataHelper = coreDataHelper
    }

    func fetchBreeds() -> AnyPublisher<[Breed], Error> {
        let fetchRequest: NSFetchRequest<MOBreed> = MOBreed.fetchRequest()
        
        return Future<[Breed], Error> { [weak self] promise in
            guard let self = self else { return }
            
            let context = self.coreDataHelper.context
            context.perform {
                do {
                    let results = try context.fetch(fetchRequest)
                    
                    if results.isEmpty {
                        self.networkService.fetchBreeds()
                            .sink(receiveCompletion: { completion in
                                if case let .failure(error) = completion {
                                    promise(.failure(error))
                                }
                            }, receiveValue: { breeds in
                                self.saveBreedsToCoreData(breeds)
                                promise(.success(breeds))
                            })
                            .store(in: &self.cancellables)
                    } else {
                        let breeds = results.map { $0.toBreed() }
                        promise(.success(breeds))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchBreed(by id: String) -> AnyPublisher<Breed?, Error> {
        let fetchRequest: NSFetchRequest<MOBreed> = MOBreed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        return Future<Breed?, Error> { [weak self] promise in
            guard let self = self else { return }
            
            let context = self.coreDataHelper.context
            context.perform {
                do {
                    let results = try context.fetch(fetchRequest)
                    let breed = results.first?.toBreed()
                    promise(.success(breed))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func saveBreedsToCoreData(_ breeds: [Breed]) {
        let context = self.coreDataHelper.context
        context.perform {
            breeds.forEach { breed in
                let moBreed = MOBreed(context: context)
                moBreed.id = breed.id
                moBreed.name = breed.name
                moBreed.breedDescription = breed.breedDescription
                moBreed.photos = Set(breed.imageURLs.map { url -> MOPhoto in
                    let photo = MOPhoto(context: context)
                    photo.url = url
                    photo.breed = moBreed
                    return photo
                })
            }
            
            do {
                try context.save()
            } catch {
                print("Failed to save breeds to Core Data: \(error)")
            }
        }
    }
}
