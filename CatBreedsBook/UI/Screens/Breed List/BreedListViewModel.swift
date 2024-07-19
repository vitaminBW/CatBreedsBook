//
//  BreedListViewModel.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//

import Foundation
import Combine
import UIKit

struct BreedDTO {
    
    let id: String
    let name: String
    let description: String
    let imageURL: URL?
}

final class BreedListViewModel: ObservableObject {
    
    @Published var breeds: [BreedDTO] = []
    
    private let repository: BreedRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: BreedRepositoryProtocol) {
        self.repository = repository
    }

    func fetchBreeds() {
        repository.fetchBreeds()
            .map { breeds in
                breeds.map { breed in
                    BreedDTO(
                        id: breed.id,
                        name: breed.name,
                        description: breed.breedDescription,
                        imageURL: URL(string: breed.imageURLs.randomElement() ?? "")
                    )
                }.shuffled()
            }
            .catch { error -> Just<[BreedDTO]> in
                print("Error fetching breeds: \(error)")
                return Just([])
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$breeds)
    }
}
