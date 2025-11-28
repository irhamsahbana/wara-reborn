//
//  CameraView.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import SwiftUI
import AVFoundation
import Combine

struct CameraView: UIViewRepresentable {
    @ObservedObject var viewModel: CameraViewModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        // If manager failed to initiate, return empty view
        guard let cameraManager = viewModel.cameraManager else {
            return view
        }
        
        // If manager success to initiate, return camera preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraManager.session)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        cameraManager.startSession()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
