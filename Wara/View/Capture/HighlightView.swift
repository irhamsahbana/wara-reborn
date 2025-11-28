import SwiftUI
import UIKit

/// Preview view showing captured image with OCR text detection overlay.
///
/// **Purpose:**
/// After photo capture, this view displays the image with blue highlighted boxes
/// around detected Korean text regions, allowing users to verify OCR quality
/// before proceeding to ingredient analysis.
///
/// **Technical Details:**
/// - Uses Vision framework coordinate system (0-1 normalized, origin bottom-left)
/// - Converts coordinates to SwiftUI coordinate system (origin top-left)
/// - Applies scale and offset for proper overlay alignment
/// - Corrects image orientation to `.up` for consistent rendering
///
/// **Coordinate Conversion:**
/// ```
/// Vision (0,0 = bottom-left) → SwiftUI (0,0 = top-left)
/// x_swiftui = x_vision * imageWidth * scale + offsetX
/// y_swiftui = (1 - y_vision) * imageHeight * scale + offsetY
/// ```
///
/// **User Actions:**
/// - "Re-scan": Dismiss and return to camera
/// - "Check Product": Proceed to analysis with detected text
struct HighlightView: View {
    let recognizedTexts: [TextRecognitionResult]
    let originalImage: UIImage
    let onResult: () -> Void
    let onDismiss: () -> Void
    
    @State private var correctedImage: UIImage?

    var body: some View {
        NavigationView {
            ZStack {
                if let correctedImage = correctedImage {
                    Image(uiImage: correctedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(
                            GeometryReader { geometry in
                                let imageSize = correctedImage.size
                                let viewSize = geometry.size
                                let scale = min(viewSize.width / imageSize.width, viewSize.height / imageSize.height)
                                let offsetX = (viewSize.width - imageSize.width * scale) / 2
                                let offsetY = (viewSize.height - imageSize.height * scale) / 2

                                ZStack {
                                    ForEach(recognizedTexts) { textData in
                                        let points = [
                                            textData.topLeft,
                                            textData.topRight,
                                            textData.bottomRight,
                                            textData.bottomLeft
                                        ]

                                        let convertedPoints = points.map { point -> CGPoint in
                                            CGPoint(
                                                x: point.x * imageSize.width * scale + offsetX,
                                                y: (1 - point.y) * imageSize.height * scale + offsetY
                                            )
                                        }

                                        Path { path in
                                            path.move(to: convertedPoints[0])
                                            path.addLine(to: convertedPoints[1])
                                            path.addLine(to: convertedPoints[2])
                                            path.addLine(to: convertedPoints[3])
                                            path.closeSubpath()
                                        }
                                        .fill(Color.blue.opacity(0.25))
                                        .overlay(
                                            Path { path in
                                                path.move(to: convertedPoints[0])
                                                path.addLine(to: convertedPoints[1])
                                                path.addLine(to: convertedPoints[2])
                                                path.addLine(to: convertedPoints[3])
                                                path.closeSubpath()
                                            }
                                                .stroke(Color.blue.opacity(0.25), lineWidth: 1)
                                        )
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            }

                        )
                        .shadow(radius: 5)
                }
                
                VStack {
                    Spacer()
                    
                    VStack {
                        Button("Re-scan") {
                            onDismiss()
                        }
                        .buttonStyle(PrimaryButtonStyle(
                            backgroundColor: .white,
                            hasBorder: true,
                            borderColor: .blue
                        ))
                        
                        Button("Check Product") {
                            onResult()
                        }
                        .buttonStyle(PrimaryButtonStyle(
                            backgroundColor: Color.waraPrimary
                        ))
                    }
                    .padding()
                    .background(
                        Color.black
                            .ignoresSafeArea()
                    )
                }
            }
            .background(Color.black)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            self.correctedImage = originalImage.correctOrientation()
        }
    }
}

/// Utilitas gambar untuk menormalkan orientasi ke `.up` agar koordinat
/// konsisten saat menggambar overlay (bounding boxes) dan perhitungan layout.
extension UIImage {
    /// Mengembalikan gambar dengan orientasi `.up` dengan cara merender ulang
    /// ke graphics context baru. Jika sudah `.up`, mengembalikan gambar asli.
    /// Dipakai karena kamera sering menyimpan orientasi di metadata saja,
    /// sehingga perlu normalisasi sebelum overlay.
    func correctOrientation() -> UIImage {
        guard self.imageOrientation != .up else {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalizedImage ?? self
    }
}



