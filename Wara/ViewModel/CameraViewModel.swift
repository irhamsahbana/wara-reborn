//
//  CameraViewModel.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//
import UIKit
import Combine
import SwiftUI
import AVFoundation

@MainActor
/// Main ViewModel for the scanning process.
/// Orchestrates camera, OCR, and ingredient detection, and manages UI state.
class CameraViewModel: ObservableObject {
    /// Scanning status and OCR/detection processing results.
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
    @Published var lastCapturedImage: UIImage?
    
    // MARK: - Initialization
    init() {
        self.ocrService = OCRService()
        self.detectionService = DetectionService()
        
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
        guard case ScanState.idle = scanState else { return } // Early exit if state is not idle
        
        scanState = .capturing
        
        guard let cameraManager = self.cameraManager else {
            print("Camera not available")
            return
        }
        
        cameraManager.capture()
    }
    
    func processImage(_ image: UIImage) {
        scanState = .processing
        
        // Run async work without blocking the UI:
        // - Call async functions (`ocrService.extractKoreanTextWithBoxes`,
        //   `detectionService.analyzeIngredients`) from a non-async context (camera callback).
        // - Using `Task {}` executes heavy work off the main call stack,
        //   keeping UI interactions responsive.
        // - The ViewModel is `@MainActor`, so state updates like `self.scanState`
        //   execute safely on the MainActor (automatic actor hopping).
        Task {
            if cameraManager != nil {
                cameraManager!.stopSession()
            }
            
            do {
                guard let normalizedImage = image.normalizedImage() else {
                    self.scanState = .error("Failed to normalize image.")
                    return
                }

                // Save the last successfully processed image as a fallback
                self.lastCapturedImage = normalizedImage
                
                let extractedTextsWithBoxes = try await ocrService.extractKoreanTextWithBoxes(
                    from: normalizedImage
                )
                let combinedText = extractedTextsWithBoxes.map { $0.text }.joined(separator: " ")

                // Save combined OCR to be sent to the scan API
                self.lastCombinedOCRText = combinedText
                
                let result = await detectionService.analyzeIngredients(text: combinedText)
                
                self.scanState = .preview(extractedTextsWithBoxes, normalizedImage, result)
            } catch let ocrError as OCRError {
                self.scanState = .error(mapOcrErrorToString(ocrError))
            } catch {
                self.scanState = .error(
                    "An unknown error occurred: \(error.localizedDescription)"
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
            return "Failed to process image."
        case .noTextFound:
            return "No text could be detected."
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
