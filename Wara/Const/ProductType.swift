//
//  ProductType.swift
//  Wara
//
//  Created by Meow on 31/10/25.
//

enum ProductType: String {
    case HALAL = "Halal KMF"
    case SAFE_TO_CONSUME = "Safe To Consume"
    case DOUBTFULL = "Doubtful"
    case NON_HALAL = "Non-Halal"
}

enum ProductTypeV2: String {
    case kmf_certified = "Halal KMF"
    case no_haram = "Safe To Consume"
    case doubtful = "Doubtful"
    case haram = "Non-Halal"
}

import SwiftUI

extension ProductTypeV2 {
    var borderColor: Color {
        switch self {
        case .kmf_certified, .no_haram: return Color.green
        case .doubtful: return Color.yellow
        case .haram: return Color.red
        }
    }

    var labelColor: Color {
        switch self {
        case .kmf_certified, .no_haram: return Color.green
        case .doubtful: return Color.orange
        case .haram: return Color.red
        }
    }

    var labelIcon: String {
        switch self {
        case .kmf_certified: return "checkmark.circle.fill"
        case .no_haram: return "checkmark.circle.fill"
        case .doubtful: return "exclamationmark.triangle.fill"
        case .haram: return "xmark.octagon.fill"
        }
    }
}
