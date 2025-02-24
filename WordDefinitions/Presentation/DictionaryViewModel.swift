//
//  DictionaryViewModel.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 24/02/2025.
//

import Combine
import Foundation

// MARK: - Presentation Layer
class DictionaryViewModel: ObservableObject {
    @Published var definitions: [WordDefinition] = []
    @Published var searchText: String = ""
    @Published var errorMessage: String?

    private let fetchWordUseCase: FetchWordUseCase
    private var cancellables = Set<AnyCancellable>()

    init(useCase: FetchWordUseCase) {
        self.fetchWordUseCase = useCase
    }

    func searchWord() {
        fetchWordUseCase.execute(word: searchText)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { definitions in
                self.definitions = definitions
                self.errorMessage = nil
            })
            .store(in: &cancellables)
    }
}
