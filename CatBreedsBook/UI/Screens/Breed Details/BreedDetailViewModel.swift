//
//  BreedDetailViewModel.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//

import Foundation
import Combine
import UIKit

final class BreedDetailViewModel: ObservableObject {
    
    @Published var breed: Breed?
    @Published var imageURLs: [URL] = []
    
    private let repository: BreedRepositoryProtocol
    private let breedDTO: BreedDTO
    private var cancellables = Set<AnyCancellable>()

    init(repository: BreedRepositoryProtocol, breedDTO: BreedDTO) {
        self.repository = repository
        self.breedDTO = breedDTO
        
        fetchBreedDetails(with: breedDTO.id)
    }
    
    func getBreedName() -> String {
        return breedDTO.name
    }
    
    func fetchBreedDetails(with breedId: String) {
        repository.fetchBreed(by: breedDTO.id)
            .compactMap { $0 }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching breed details: \(error)")
                }
            }, receiveValue: { [weak self] breed in
                guard let self = self else { return }
                self.breed = breed
                
                self.imageURLs = breed.imageURLs.shuffled().compactMap { URL(string: $0) }
            })
            .store(in: &cancellables)
    }
}
