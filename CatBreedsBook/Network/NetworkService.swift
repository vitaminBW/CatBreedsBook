//
//  NetworkService.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    
    func fetchBreeds() -> AnyPublisher<[Breed], Error>
}

final class NetworkService: NetworkServiceProtocol {
    
    func fetchBreeds() -> AnyPublisher<[Breed], Error> {
        guard let url = Bundle.main.url(forResource: "breeds", withExtension: "json") else {
            return Fail(error: NSError(domain: "Invalid URL", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        }
        
        return Future<[Breed], Error> { promise in
            do {
                let data = try Data(contentsOf: url)
                let breedsResponse = try JSONDecoder().decode(BreedsResponse.self, from: data)
                promise(.success(breedsResponse.breeds))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

struct BreedsResponse: Codable {
    
    let breeds: [Breed]
}
