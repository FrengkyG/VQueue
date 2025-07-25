//
//  BoothViewModel.swift
//  VQueue
//
//  Created by Frengky Gunawan on 25/07/25.
//

import Foundation
import Combine

class BoothViewModel: ObservableObject {
    @Published var booth: Booth?
    @Published var isFetchBoothLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func fetchBooth(by id: String) {
        guard let url = URL(string: "\(AppConstants.baseLocalUrl)/user/booth/\(id)") else {
            self.errorMessage = "Invalid URL"
            return
        }

        isFetchBoothLoading = true
        errorMessage = nil

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                let response = result.response as? HTTPURLResponse
                guard let statusCode = response?.statusCode, statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: BoothResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isFetchBoothLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.booth = response.data
            })
            .store(in: &cancellables)
    }
}
