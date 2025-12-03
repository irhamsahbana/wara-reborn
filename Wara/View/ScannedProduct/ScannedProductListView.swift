//
//  ScannedProductListView.swift
//  Wara
//
//  Created by Meow on 11/11/25
//

import SwiftUI

/// Displays user's favorited/scanned products in a searchable grid.
///
/// **Features:**
/// - Pull-to-dismiss gesture (swipe down)
/// - Search bar with debounced API calls (400ms delay)
/// - Lazy grid with pagination (loads more on scroll)
/// - Long-press to unfavorite with confirmation dialog
///
/// **User Interactions:**
/// - Tap product → navigates to `ScanResultView`
/// - Long press (0.5s) → shows unfavorite confirmation
/// - Swipe down / tap "Back To Scan" → dismisses view
///
/// **Pagination:**
/// Configured with `configureDefaultPaginate(20)` for 20 items per page.
/// Automatically loads next page when user scrolls near bottom.
///
/// **Optimistic UI:**
/// When unfavoriting, item is removed immediately from UI,
/// then API call is made in background.
struct ScannedProductListView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var query: String = ""
    @StateObject private var viewModel = ScannedProductsViewModel()
    @State private var searchWorkItem: DispatchWorkItem? = nil
    @State private var itemToUnfavorite: ScannedProductsViewModel.ScannedProductGridItem? = nil
    @State private var showUnfavoriteDialog = false
    @State private var hasInitialized = false
    @State private var isAtTop = true
    @State private var isDragging = false
    @State private var wasAtTopAtDragStart = false
    @State private var latestScrollY: CGFloat = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                GeometryReader { proxy in
                    Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named("scannedScroll")).minY)
                }
                .frame(height: 0)
                header
                searchBar

                if viewModel.items.isEmpty && !viewModel.isLoading {
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    emptyState
                } else {
                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                        spacing: 12
                    ) {
                        ForEach(viewModel.items) { item in
                            NavigationLink(
                                destination: ScanResultView(
                                    onDismiss: {},
                                    rawOCRText: "",
                                    fallbackImage: nil,
                                    scanResultId: item.id,
                                    sourceCategory: item.sourceCategory
                                )
                            ) {
                                ScannedProductListView.ProductCard(item: item)
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    itemToUnfavorite = item
                                    showUnfavoriteDialog = true
                                } label: {
                                    Label("Remove from Saved", systemImage: "heart.slash")
                                }
                            }
                            .onAppear {
                                viewModel.loadNextPageIfNeeded(currentItemId: item.id)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                }
            }
            .padding(.top, 8)
        }
        .coordinateSpace(name: "scannedScroll")
        .refreshable {
            dismiss()
        }
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { y in
            latestScrollY = y
            isAtTop = y >= 0
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 10)
                .onChanged { _ in
                    if !isDragging {
                        isDragging = true
                        wasAtTopAtDragStart = isAtTop
                    }
                }
                .onEnded { value in
                    if wasAtTopAtDragStart && value.translation.height > 30 && latestScrollY > 0 {
                        dismiss()
                    }
                    isDragging = false
                }
        )
        .navigationTitle("")
        .navigationBarHidden(true)
        .background(Color.waraBackground.ignoresSafeArea())
        .overlay {
            if showUnfavoriteDialog, let item = itemToUnfavorite {
                CustomAlertView(
                    title: "Remove from Saved Products",
                    message: "Remove '\(item.englishName)' from your saved products?",
                    cancelText: "Cancel",
                    destructiveText: "Remove",
                    onCancel: {
                        itemToUnfavorite = nil
                        showUnfavoriteDialog = false
                    },
                    onDestructive: {
                        unfavoriteItem(item)
                        showUnfavoriteDialog = false
                    }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                .animation(.easeInOut(duration: 0.2), value: showUnfavoriteDialog)
            }
        }
        .onAppear {
            if !hasInitialized {
                viewModel.configureDefaultPaginate(3)
                viewModel.resetAndLoadInitial(query: "")
                hasInitialized = true
            }
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "chevron.up")
                .foregroundColor(.primary)
                .font(.headline.weight(.medium))
            HStack(spacing: 8) {
                Image(systemName: "camera.fill")
                    .foregroundColor(.primary)
                Text("Back To Scan")
                    .font(.body.weight(.medium))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 16)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            dismiss()
        }
        .gesture(
            DragGesture(minimumDistance: 10)
                .onEnded { value in
                    if value.translation.height > 30 {
                        dismiss()
                    }
                }
        )
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField(
                "Search your saved products",
                text: $query,
                prompt: Text("Search your saved products").foregroundColor(.gray)
            )
                .textFieldStyle(.plain)
                .font(.body.weight(.medium))
                .foregroundColor(.gray)
                .onChange(of: query) { oldValue, newValue in
                    searchWorkItem?.cancel()
                    let work = DispatchWorkItem { [weak viewModel] in
                        viewModel?.resetAndLoadInitial(query: newValue)
                    }
                    searchWorkItem = work
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: work)
                }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
        )
        .padding(.horizontal, 16)
    }
    
    private func unfavoriteItem(_ item: ScannedProductsViewModel.ScannedProductGridItem) {
        // Optimistic UI update - remove immediately
        viewModel.removeItem(id: item.id)
        
        // Call API to unfavorite
        viewModel.toggleFavorite(itemId: item.id, isKmf: item.isKmf) { success in
            if !success {
                // If API fails, optionally reload to restore item
                // viewModel.resetAndLoadInitial(query: query)
            }
        }
        
        itemToUnfavorite = nil
    }
}

private extension ScannedProductListView {
    var emptyState: some View {
        VStack(spacing: 16) {
            Image(ImageAssets.lovePackagedFood)
                .resizable()
                .scaledToFit()
                .frame(height: 160)

            Text("Your saved products will appear here.\nTap on the heart icon next to the products image to save")
                .font(.body.weight(.medium))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 24)
        .padding(.bottom, 32)
    }
}

// MARK: - Nested Types & Components

extension ScannedProductListView {
    struct ProductCard: View {
        let item: ScannedProductsViewModel.ScannedProductGridItem

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .frame(height: 90)
                        .overlay(
                            CachedRemoteImageView(id: item.id, url: item.imageURL, contentMode: .fit, cornerRadius: 8, placeholderColor: Color(.systemGray6))
                        )
                }

                Text(item.englishName)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(item.category)
                    .font(.caption)
                    .foregroundColor(.primary)
                
                Spacer(minLength: 0)

                HStack(spacing: 6) {
                    Image(systemName: item.status.labelIcon)
                        .foregroundColor(item.status.labelColor)
                    Text(item.status.rawValue)
                        .font(.caption)
                        .foregroundColor(item.status.labelColor)
                    Spacer()
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(item.status.borderColor, lineWidth: 2)
            )
        }
    }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

#Preview {
    NavigationStack {
        ScannedProductListView()
    }
}
