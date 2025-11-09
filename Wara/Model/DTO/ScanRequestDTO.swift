//
//  ScanRequestDTO.swift
//  Wara
//
//  Created by Meow on 09/11/25
//

import Foundation

/// Payload untuk request scan produk.
/// Mengirim teks OCR mentah yang diekstrak dari label bahan.
struct ScanRequestDTO: Encodable {
    let id: String
    let rawOCRText: String

    enum CodingKeys: String, CodingKey {
        case id
        case rawOCRText = "raw_ocr_text"
    }
}