//
//  CameraViewModel.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//
import UIKit
import Combine
import SwiftData
import SwiftUI
import AVFoundation

@MainActor
/// ViewModel utama untuk proses pemindaian.
/// Mengorkestrasi kamera, OCR, dan deteksi bahan serta mengelola state UI.
class CameraViewModel: ObservableObject {
    /// Status pemindaian dan hasil pemrosesan OCR/deteksi.
    enum ScanState {
        case idle
        case capturing
        case processing
        case preview([TextRecognitionResult], UIImage, DetectionResult)
        case success(DetectionResult)
        case error(String)
    }
    
    // MARK: - Manager & Services
    let cameraManager: CameraManager?
    private let ocrService: OCRService
    private let detectionService: DetectionService
    
    // MARK: - States
    @Published var scanState: ScanState = .idle
    @Published var isTorchOn: Bool = false
    @Published var isIngredientLabelDectected: Bool = false
    @Published var lastCombinedOCRText: String = ""
    
    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.ocrService = OCRService()
        self.detectionService = DetectionService(modelContext: modelContext)
        
        // Skip camera hardware setup during SwiftUI Previews
        if Env.isPreview {
            self.cameraManager = nil
            return
        }

        do {
            let cameraManager = CameraManager()
            try cameraManager.setup()
            self.cameraManager = cameraManager
            
            cameraManager.onImageCaptured = self.processImage
            cameraManager.onFrameCaptured = self.processFrame
        } catch {
            self.cameraManager = nil
        }
    }
    
    // MARK: - Methods
    func capture() {
        guard case ScanState.idle = scanState else { return } // Early exit if state are not idle
        
        scanState = .capturing
        
        guard let cameraManager = self.cameraManager else {
            print("Camera not available")
            return
        }
        
        cameraManager.capture()
    }
    
    func processImage(_ image: UIImage) {
        scanState = .processing
        
        // Jalankan operasi async tanpa memblok UI:
        // - Kita memanggil fungsi async (`ocrService.extractKoreanTextWithBoxes`,
        //   `detectionService.analyzeIngredients`) dari konteks non-async (callback kamera).
        // - Menggunakan `Task {}` mengeksekusi pekerjaan berat di luar call stack utama,
        //   sehingga interaksi UI tetap responsif.
        // - ViewModel ber-`@MainActor`, jadi pembaruan state seperti `self.scanState`
        //   akan dieksekusi aman pada MainActor (actor-hopping otomatis).
        Task {
            if cameraManager != nil {
                cameraManager!.stopSession()
            }
            
            do {
                guard let normalizedImage = image.normalizedImage() else {
                    self.scanState = .error("Gagal menormalkan gambar.")
                    return
                }
                
                let extractedTextsWithBoxes = try await ocrService.extractKoreanTextWithBoxes(
                    from: normalizedImage
                )
                let combinedText = extractedTextsWithBoxes.map { $0.text }.joined(separator: " ")

                // Simpan OCR gabungan untuk dikirim ke API scan
                self.lastCombinedOCRText = combinedText
                
                let result = await detectionService.analyzeIngredients(text: combinedText)
                
                self.scanState = .preview(extractedTextsWithBoxes, normalizedImage, result)
            } catch let ocrError as OCRError {
                self.scanState = .error(mapOcrErrorToString(ocrError))
            } catch {
                self.scanState = .error(
                    "Terjadi kesalahan tidak dikenal: \(error.localizedDescription)"
                )
            }
        }
    }
    
    func processFrame(_ sampleBuffer: CMSampleBuffer) {
        do {
            let extractedText = try self.ocrService.extractKoreanText(from: sampleBuffer)
            let hasIngredients = self.detectionService.hasIngredientsLabel(in: extractedText)

            if(hasIngredients) {
                DispatchQueue.global(qos: .userInteractive).async {
                    // Trigger soft haptic
                    let softImpact = UIImpactFeedbackGenerator(style: .soft)
                    softImpact.impactOccurred()
                }
            }
            
            // Update UI on main thread
            DispatchQueue.main.async {
                self.isIngredientLabelDectected = hasIngredients
            }
        } catch {
            DispatchQueue.main.async {
                self.isIngredientLabelDectected = false
            }
        }
    }
    
    func resetState() {
        cameraManager?.startSession()
        scanState = .idle
    }
    
    func toggleTorch() {
        guard let cameraManager = self.cameraManager else { return }  // Early exit if camera manager not found
        cameraManager.toggleTorch()
        isTorchOn = !isTorchOn
    }

    private func mapOcrErrorToString(_ error: OCRError) -> String {
        switch error {
        case .imageProcessingFailed:
            return "Gagal memproses gambar."
        case .noTextFound:
            return "Tidak ada teks yang dapat dideteksi."
        }
    }
}

extension UIImage {
    func normalizedImage() -> UIImage? {
        guard imageOrientation != .up else { return self }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
