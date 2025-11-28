//
//  SearchBar.swift
//  Wara
//
//  Created by Meow on 30/10/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search your favorite snacks", text: $text)
                .foregroundColor(.primary)
                .disableAutocorrection(true)
        }
        .padding(10)
        .background(.white)
        .cornerRadius(20)
    }
}
