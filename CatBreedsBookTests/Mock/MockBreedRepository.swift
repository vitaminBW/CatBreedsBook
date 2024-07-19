//
//  MockBreedRepository.swift
//  CatBreedsBookTests
//
//  Created by Vitaliy Bal on 19.07.2024.
//

import Foundation
import Combine

@testable import CatBreedsBook

class MockBreedRepository: BreedRepositoryProtocol {
    
    var breeds: [Breed] = []
    var breed: Breed?
    var error: Error?

    func fetchBreeds() -> AnyPublisher<[Breed], Error> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return Just(breeds).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
    
    func fetchBreed(by id: String) -> AnyPublisher<Breed?, Error> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return Just(breed).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
}
