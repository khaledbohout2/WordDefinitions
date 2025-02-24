//
//  DictionaryView.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 24/02/2025.
//

import SwiftUI

struct DictionaryView: View {
    @StateObject private var viewModel: DictionaryViewModel

    init(viewModel: DictionaryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            TextField("Search for a word", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onSubmit { viewModel.searchWord() }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            List {
                Section(header: Text("Past Searches")) {
                    ForEach(viewModel.pastSearchWords, id: \.self) { word in
                        Button(action: { viewModel.retryPastSearch(word: word) }) {
                            HStack {
                                Text(word)
                                if !viewModel.isOnline {
                                    Image(systemName: "wifi.slash").foregroundColor(.red)
                                }
                            }
                        }
                    }
                }

                Section(header: Text("Definitions")) {
                    ForEach(viewModel.definitions, id: \.word) { word in
                        VStack(alignment: .leading) {
                            Text(word.word).font(.headline)
                            ForEach(word.meanings, id: \.partOfSpeech) { meaning in
                                Text(meaning.partOfSpeech).bold()
                                ForEach(meaning.definitions, id: \.definition) { definition in
                                    Text(definition.definition).padding(.leading, 10)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Dictionary")
    }
}
