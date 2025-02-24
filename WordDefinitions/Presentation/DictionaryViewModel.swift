//
//  DictionaryViewModel.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 24/02/2025.
//

import Combine
import Foundation

class DictionaryViewModel: ObservableObject {
    @Published var definitions: [WordDefinition] = []
    @Published var searchText: String = ""
    @Published var errorMessage: String?
    @Published var pastSearchWords: [String] = []
    @Published var isOnline: Bool = true

    private let fetchWordUseCase: FetchWordUseCase
    private let fetchPastSearchWordsUseCase: FetchPastSearchWordsUseCase
    private let checkNetworkStatusUseCase: CheckNetworkStatusUseCase
    private var cancellables = Set<AnyCancellable>()

    init(
        fetchWordUseCase: FetchWordUseCase,
        fetchPastSearchWordsUseCase: FetchPastSearchWordsUseCase,
        checkNetworkStatusUseCase: CheckNetworkStatusUseCase
    ) {
        self.fetchWordUseCase = fetchWordUseCase
        self.fetchPastSearchWordsUseCase = fetchPastSearchWordsUseCase
        self.checkNetworkStatusUseCase = checkNetworkStatusUseCase

        observeNetworkStatus()
        loadPastSearchWords()
    }

    func searchWord() {
        guard !searchText.isEmpty else { return }

        if !isOnline {
            errorMessage = "No internet connection."
            return
        }

        fetchWordUseCase.execute(word: searchText)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    self.definitions.removeAll()
                }
            }, receiveValue: { definitions in
                self.definitions = definitions
                self.errorMessage = nil
                self.loadPastSearchWords() // Refresh past searches
            })
            .store(in: &cancellables)
    }

    private func loadPastSearchWords() {
        fetchPastSearchWordsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching past searches: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] pastWords in
                self?.pastSearchWords = pastWords
            })
            .store(in: &cancellables)
    }

    private func observeNetworkStatus() {
        checkNetworkStatusUseCase.execute()
            .receive(on: DispatchQueue.main)
            .assign(to: &$isOnline)
    }

    func retryPastSearch(word: String) {
        guard isOnline else {
            errorMessage = "No internet connection. Please try again later."
            return
        }
        searchText = word
        searchWord()
    }
}

