//
//  BreedListViewModelTests.swift
//  CatBreedsBookTests
//
//  Created by Vitaliy Bal on 19.07.2024.
//

import XCTest
import Combine

@testable import CatBreedsBook

final class BreedListViewModelTests: XCTestCase {
    
    var viewModel: BreedListViewModel!
    var mockBreedRepository: MockBreedRepository!
    var mockImageLoader: MockImageLoader!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockBreedRepository = MockBreedRepository()
        mockImageLoader = MockImageLoader()
        viewModel = BreedListViewModel(repository: mockBreedRepository)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockBreedRepository = nil
        mockImageLoader = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchBreedsSuccess() {
        let breeds = [
            Breed(id: "1", name: "Breed1", breedDescription: "Description1", imageURLs: ["url1"]),
            Breed(id: "2", name: "Breed2", breedDescription: "Description2", imageURLs: ["url2"])
        ]
        mockBreedRepository.breeds = breeds

        let expectation = self.expectation(description: "Fetch breeds")
        viewModel.$breeds
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchBreeds()
        
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(viewModel.breeds.count, breeds.count)
    }

    func testFetchBreedsFailure() {
        let error = NSError(domain: "", code: -1, userInfo: nil)
        mockBreedRepository.error = error

        let expectation = self.expectation(description: "Fetch breeds failure")
        viewModel.$breeds
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchBreeds()
        
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(viewModel.breeds.count, 0)
    }

}
