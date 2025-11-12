//
//  ScannedProductsView.swift
//  Wara
//
//  Created by Rizkydwiputra on 12/11/25.
//

import SwiftUI

// Model ringan untuk kebutuhan UI grid.
// Map saja dari model riil jika sudah tersedia.
struct ScannedProductGridItem: Identifiable, Hashable {
    let id: String
    let englishName: String
    let category: String
    let imageURL: URL?
    let status: ProductType
    let isKmf: Bool
}

// Chip status kecil di bagian bawah kartu.
private struct StatusChipView: View {
    let status: ProductType
    let isKmf: Bool
    
    private var labelText: String {
        if isKmf { return "Halal KMF" }
        switch status {
        case .HALAL: return "Halal KMF"
        case .SAFE_TO_CONSUME: return "Safe"
        case .DOUBTFULL: return "Doubtful"
        case .NON_HALAL: return "Non-Halal"
        }
    }
    
    private var color: Color {
        switch status {
        case .HALAL, .SAFE_TO_CONSUME: return Color("green2")
        case .DOUBTFULL: return Color("yellow")
        case .NON_HALAL: return .red
        }
    }
    
    private var iconName: String {
        switch status {
        case .HALAL, .SAFE_TO_CONSUME: return "checkmark.circle.fill"
        case .DOUBTFULL: return "exclamationmark.triangle.fill"
        case .NON_HALAL: return "xmark.octagon.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: iconName)
                .font(.caption)
            Text(labelText)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color("chipBackground"))
        .clipShape(Capsule())
    }
}

// Kartu item untuk grid.
private struct ScannedProductCardView: View {
    let item: ScannedProductGridItem
    
    private var borderColor: Color {
        switch item.status {
        case .HALAL, .SAFE_TO_CONSUME: return Color("green2")
        case .DOUBTFULL: return Color("yellow")
        case .NON_HALAL: return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CachedRemoteImageView(id: item.id, url: item.imageURL, contentMode: .fit, cornerRadius: 12)
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                .padding(.horizontal, 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.englishName)
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                Text(item.category)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            
            StatusChipView(status: item.status, isKmf: item.isKmf)
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
        }
        .background(Color("chipBackground"))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(borderColor, lineWidth: 3)
        )
        .cornerRadius(14)
    }
}

struct ScannedProductsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchQuery: String = ""
    
    // Dummy data sementara untuk tampilan
    private var dummyData: [ScannedProductGridItem] = [
        ScannedProductGridItem(id: "1", englishName: "Korean Snack", category: "Snack", imageURL: URL(string: "https://picsum.photos/200/200?1"), status: .SAFE_TO_CONSUME, isKmf: false),
        ScannedProductGridItem(id: "2", englishName: "Strawberry Sticky Rice Cake", category: "Rice Cake", imageURL: URL(string: "https://picsum.photos/200/200?2"), status: .HALAL, isKmf: true),
        ScannedProductGridItem(id: "3", englishName: "Korean Snack", category: "Snack", imageURL: URL(string: "https://picsum.photos/200/200?3"), status: .DOUBTFULL, isKmf: false),
        ScannedProductGridItem(id: "4", englishName: "Korean Snack", category: "Snack", imageURL: URL(string: "https://picsum.photos/200/200?4"), status: .DOUBTFULL, isKmf: false),
        ScannedProductGridItem(id: "5", englishName: "Korean Snack", category: "Snack", imageURL: URL(string: "https://picsum.photos/200/200?5"), status: .SAFE_TO_CONSUME, isKmf: false),
        ScannedProductGridItem(id: "6", englishName: "Strawberry Sticky Rice Cake", category: "Rice Cake", imageURL: URL(string: "https://picsum.photos/200/200?6"), status: .HALAL, isKmf: true),
        ScannedProductGridItem(id: "7", englishName: "Korean Snack", category: "Snack", imageURL: URL(string: "https://picsum.photos/200/200?7"), status: .DOUBTFULL, isKmf: false),
        ScannedProductGridItem(id: "8", englishName: "Korean Snack", category: "Snack", imageURL: URL(string: "https://picsum.photos/200/200?8"), status: .DOUBTFULL, isKmf: false)
    ]
    
    private var filteredItems: [ScannedProductGridItem] {
        let q = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return dummyData }
        return dummyData.filter {
            $0.englishName.localizedCaseInsensitiveContains(q)
            || $0.category.localizedCaseInsensitiveContains(q)
        }
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            // Centered Back To Scan header
            ZStack {
                HStack { Spacer() }
                VStack(spacing: 4) {
                    Image(systemName: "chevron.up")
                        .font(.headline)
                    HStack(spacing: 6) {
                        Image(systemName: "camera.fill")
                        Text("Back To Scan")
                            .font(.body.weight(.semibold))
                    }
                }
                .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 6)
            .padding(.bottom, 2)
            .contentShape(Rectangle())
            .onTapGesture { dismiss() }
            
            // Search bar: white pill with subtle shadow like the mock
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search your scanned product", text: $searchQuery)
                    .foregroundColor(.primary)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
            )
            .padding(.horizontal, 16)
            
            // Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(filteredItems) { item in
                        ScannedProductCardView(item: item)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    NavigationView {
        ScannedProductsView()
    }
}
