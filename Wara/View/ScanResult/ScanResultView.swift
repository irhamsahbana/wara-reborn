//
//  ScanResultView.swift
//  Wara
//
//  Created by Meow on 30/10/25.
//

import SwiftUI
import UIKit

/// Main coordinator view for displaying scan results.
///
/// This view handles two scenarios:
/// 1. **Front Label Scan**: Shows product candidates when front packaging is detected
/// 2. **Back Label Scan**: Shows detailed ingredient analysis and product information
///
/// **Data Flow:**
/// - If `scanResultId` is provided → loads existing scan result from API
/// - If `rawOCRText` is provided → performs new scan analysis
///
/// **UI States:**
/// - Loading: Shows progress animation (0-90% fake progress, 90-100% when complete)
/// - Error: Displays error message with retry option
/// - Front Label: Delegates to `ScanResultFrontView` for product selection
/// - Back Label: Delegates to `ScanResultBackView` for ingredient details
/// - Unknown: Shows rescan prompt when label type cannot be determined
///
/// **Sheets:**
/// - Contribution sheet: Allows users to suggest edits
/// - Alternative detail sheet: Shows detailed info for alternative products
struct ScanResultView: View {
    let onDismiss: () -> Void
    let rawOCRText: String
    let fallbackImage: UIImage?
    let scanResultId: String?
    let sourceCategory: String?
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = ScanResultViewModel()
    @State private var showSheet = false
    @State private var showAlternativeDetail = false
    @State private var loadingProgress: Double = 0.0
    @State private var loadingTimer: Timer?
    
    init(onDismiss: @escaping () -> Void, rawOCRText: String, fallbackImage: UIImage?, scanResultId: String? = nil, sourceCategory: String? = nil) {
        self.onDismiss = onDismiss
        self.rawOCRText = rawOCRText
        self.fallbackImage = fallbackImage
        self.scanResultId = scanResultId
        self.sourceCategory = sourceCategory
    }

    var body: some View {
        Group {
            if let data = viewModel.data, data.label?.lowercased() == "front" {
                ScanResultFrontView(
                    onBack: { onDismiss(); dismiss() },
                    onCaptureBack: { onDismiss(); dismiss() },
                    imageURL: viewModel.frontImageURL,
                    fallbackImage: fallbackImage,
                    candidates: data.productCandidates ?? []
                )
            } else {
                NavigationView {
                    VStack(spacing: 0){
                        CustomAppBar(
                            title: viewModel.isLoading && viewModel.data == nil ? "Loading" : "Details",
                            onBack: { onDismiss(); dismiss() },
                            onFavorite: { viewModel.toggleScannedProductFavorite() },
                            isFavoriteEnabled: viewModel.data != nil,
                            isFavorited: viewModel.isScannedProductFavorited
                        )
                        
                        if viewModel.isLoading && viewModel.data == nil {
                            ScanLoadingView(progress: loadingProgress)
                        } else if let err = viewModel.errorMessage, viewModel.data == nil {
                            ScanErrorView(errorMessage: err, onBack: onDismiss)
                        } else if let data = viewModel.data, (data.label?.lowercased() ?? "") != "back" && scanResultId == nil {
                            ScanResultUnknownView(
                                onRescan: { onDismiss() }
                            )
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        } else {
                            ScanResultBackView(
                                viewModel: viewModel,
                                fallbackImage: fallbackImage,
                                onDismiss: onDismiss,
                                showAlternativeDetail: $showAlternativeDetail
                            )
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            BottomSheetContributeView(isPresented: $showSheet)
        }
        .sheet(isPresented: $showAlternativeDetail) {
            VStack(spacing: 12) {
                if viewModel.isLoadingAlternativeDetail {
                    ProgressView()
                        .padding()
                } else if let detail = viewModel.selectedAlternativeDetailData {
                    AlternativeDetailView(detail: detail, fallbackImage: fallbackImage)
                } else {
                    Text(viewModel.alternativeDetailErrorMessage ?? "Failed to load alternative product")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .task {
            if let id = scanResultId, !id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                await viewModel.loadScanResultById(id, category: sourceCategory)
            } else {
                await viewModel.scan(rawOCRText: rawOCRText)
                let label = (viewModel.data?.label?.lowercased() ?? "back")
                viewModel.uploadCapturedPhoto(image: fallbackImage, packagingLabel: label)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onChange(of: viewModel.isLoading) { oldValue, newValue in
            if newValue {
                startLoadingProgress()
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    loadingProgress = 1.0
                }
                stopLoadingTimer()
            }
        }
    }
    
    // MARK: - Loading Progress Helpers
    @MainActor
    private func startLoadingProgress() {
        loadingTimer?.invalidate()
        loadingProgress = 0.0
        loadingTimer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { [weak viewModel] timer in
            Task { @MainActor in
                // Fill up to 90% while loading, then hold
                if viewModel?.isLoading == true {
                    let target = 0.90
                    if loadingProgress < target {
                        loadingProgress = min(target, loadingProgress + 0.015)
                    } else {
                        loadingProgress = target
                    }
                } else {
                    // Complete to 100% when finished
                    loadingProgress = 1.0
                    timer.invalidate()
                    loadingTimer = nil
                }
            }
        }
    }

    private func stopLoadingTimer() {
        loadingTimer?.invalidate()
        loadingTimer = nil
    }
}

#Preview {
    ScanResultView(onDismiss: {}, rawOCRText: "Sample OCR", fallbackImage: nil)
}
