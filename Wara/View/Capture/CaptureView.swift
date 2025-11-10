//
//  HalalLensView.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import PhotosUI
import SwiftUI

struct CaptureView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: CameraViewModel
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isShowingShowcaseAnimation: Bool = true
    @State private var showDialog = false
    
    init() {
        _viewModel = StateObject(
            wrappedValue: CameraViewModel(
                modelContext: PersistenceController.shared.container.mainContext
            )
        )
    }
    
    private var areControlsHidden: Bool {
        switch viewModel.scanState {
        case .idle, .capturing:
            return false
        case .processing, .preview, .success, .error:
            return true
        }
    }
    
    var body: some View {
        ZStack {
            CameraView(viewModel: viewModel)
                .ignoresSafeArea()
           
            VStack {
                ZStack {
                    // Back button
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showDialog = true
                            }
                        }) {
                            Image(systemName: "info.circle.fill")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: 80)
                
                Spacer()
                
                if(isShowingShowcaseAnimation) {
                    ShowcaseAnimation(isShowcaseAnimation: $isShowingShowcaseAnimation)
                }
                
                Spacer()

                // Detection status near capture controls
                HStack(alignment: .center, spacing: 8) {
                    if viewModel.isIngredientLabelDectected {
                        ZStack {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 24, height: 24)
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.green)
                        }
                    } else {
                        ZStack {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 24, height: 24)
                            Image(systemName: "exclamationmark")
                                .font(.caption.bold())
                                .foregroundColor(Color.yellow)
                        }
                    }

                    Text(
                        viewModel.isIngredientLabelDectected
                        ? "Ingredient Label Detected"
                        : "Please Find Ingredient Label"
                    )
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.black)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(viewModel.isIngredientLabelDectected ? Color.green : Color.yellow)
                .clipShape(.capsule)
                .font(.subheadline)
                .fontWeight(.medium)
                .transition(.scale)
                .id(
                    "detectionStatusText_"
                    + (viewModel.isIngredientLabelDectected
                       ? "detected" : "scanning")
                )
                
                HStack(alignment: .center, spacing: 60) {
                    // Tombol Impor Galeri
                    PhotosPicker(
                        selection: $selectedPhotoItem,
                        matching: .images
                    ) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .frame(width: 64, height: 64)
                    .background(.black.opacity(0.2))
                    .clipShape(Circle())
                    .accessibilityLabel("Ambil foto dari galeri")
                    
                    // Tombol Capture
                    Button(action: {
                        viewModel.capture()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 65, height: 65)
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .frame(width: 75, height: 75)
                        }
                    }.accessibilityLabel("Tekan untuk ambil foto dari kamera")
                    
                    // Tombol Senter
                    Button(action: viewModel.toggleTorch) {
                        Image(
                            systemName: viewModel.isTorchOn
                            ? "bolt.fill" : "bolt.slash.fill"
                        )
                        .font(.title)
                        .foregroundColor(.white)
                    }
                    .frame(width: 64, height: 64)
                    .background(.black.opacity(0.2))
                    .clipShape(Circle())
                }
                .padding(.top, 32)
                .padding(.bottom, 4)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.1))
                .accessibilityHidden(areControlsHidden)
            }
            .frame(maxWidth: .infinity)
            
            // Lapisan untuk menampilkan hasil atau status
            switch viewModel.scanState {
            case .idle:
                EmptyView()
            case .capturing:
                EmptyView()
            case .processing:
                ProcessingView()
            case .preview(let recognizedTexts, let image, let analyzeResult):
                HighlightView(
                    recognizedTexts: recognizedTexts,
                    originalImage: image,
                    onResult: {
                        viewModel.scanState = .success(analyzeResult)
                    },
                    onDismiss: viewModel.resetState
                )
            case .success(let result):
                ScanResultView(
                    onDismiss: viewModel.resetState,
                    rawOCRText: viewModel.lastCombinedOCRText,
                    fallbackImage: viewModel.lastCapturedImage
                )
            case .error(let message):
                ErrorView(message: message, onDismiss: viewModel.resetState)
            }
        }
        .background(.black)
        .animation(.bouncy, value: viewModel.isIngredientLabelDectected)
        .onChange(of: selectedPhotoItem) {
            Task {
                if let data = try? await selectedPhotoItem?.loadTransferable(
                    type: Data.self
                ),
                   let image = UIImage(data: data)
                {
                    viewModel.processImage(image)
                    selectedPhotoItem = nil
                }
            }
        }
        .customDialog(isShown: $showDialog) {
            ZStack(alignment: .topTrailing) {
                InstructionView()
                
                Button(action: {
                    showDialog = false
                }) {
                    Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.18), radius: 6, x: 0, y: 3)
                }
            }

        }
                    
                   
    }
}

#Preview {
    CaptureView()
}
