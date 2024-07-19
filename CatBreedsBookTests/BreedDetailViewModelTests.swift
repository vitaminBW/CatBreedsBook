//
//  BreedDetailViewModelTests.swift
//  CatBreedsBookTests
//
//  Created by Vitaliy Bal on 19.07.2024.
//

import XCTest
import Combine

@testable import CatBreedsBook

class BreedDetailViewModelTests: XCTestCase {
    
    var viewModel: BreedDetailViewModel!
    var mockBreedRepository: MockBreedRepository!
    var mockImageLoader: MockImageLoader!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockBreedRepository = MockBreedRepository()
        mockImageLoader = MockImageLoader()
        let breedDTO = BreedDTO(id: "1", name: "Breed1", description: "Description1", imageURL: URL(string: "url1"))
        viewModel = BreedDetailViewModel(repository: mockBreedRepository, breedDTO: breedDTO)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockBreedRepository = nil
        mockImageLoader = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchBreedDetailsSuccess() {
        // Given
        let breed = Breed(id: "1", name: "Breed1", breedDescription: "Description1", imageURLs: ["url1"])
        mockBreedRepository.breed = breed

        // When
        let expectation = self.expectation(description: "Fetch breed details")
        viewModel.$breed
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchBreedDetails(with: breed.id)
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(viewModel.breed?.name, breed.name)
        XCTAssertEqual(viewModel.breed?.breedDescription, breed.breedDescription)
    }

    func testFetchBreedDetailsFailure() {
        let error = NSError(domain: "", code: -1, userInfo: nil)
        mockBreedRepository.error = error

        // When
        let expectation = self.expectation(description: "Fetch breed details failure")
        viewModel.$breed
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchBreedDetails(with: "1")
        
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNil(viewModel.breed)
    }
}
