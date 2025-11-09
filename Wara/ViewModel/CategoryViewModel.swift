//
//  CategoryViewModel.swift
//  Wara
//
//  Created by Meow on 27/10/25.
//

import Foundation

@MainActor
class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let remoteSource = CategoryRemoteSource.shared

    func loadCategories() {
        isLoading = true
        errorMessage = nil

        remoteSource.fetchCategories { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false

                switch result {
                case .success(let dtos):
                    self.categories = dtos.map { dto in
                        // Gunakan englishName sebagai judul dan app_category_icon_url untuk ikon
                        let url = dto.appCategoryIconURL.flatMap { URL(string: $0) }
                        return Category(name: dto.englishName, iconURL: url, description: dto.appCategoryDescription)
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
