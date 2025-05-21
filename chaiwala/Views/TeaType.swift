//
//  TeaType.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 5/4/25.
//

import Foundation
import SwiftUI

enum TeaType: Int32, CaseIterable, CustomStringConvertible {
    case black = 0
    case green
    case white
    case oolong
    case puErh
    case yellow
    case herbal
    case rooibos
    case yerbaMate
    case matcha
    case chai
    case flavored
    case blooming

    var description: String {
        switch self {
        case .black: return "Black"
        case .green: return "Green"
        case .white: return "White"
        case .oolong: return "Oolong"
        case .puErh: return "Pu-erh"
        case .yellow: return "Yellow"
        case .herbal: return "Herbal"
        case .rooibos: return "Rooibos"
        case .yerbaMate: return "Yerba Mate"
        case .matcha: return "Matcha"
        case .chai: return "Chai"
        case .flavored: return "Flavored"
        case .blooming: return "Blooming"
        }
    }
    
    var systemImage: String {
        switch self {
        case .black: return "cup.and.saucer.fill"
        case .green: return "leaf.fill"
        case .white: return "snow"
        case .oolong: return "drop.fill"
        case .puErh: return "flame.fill"
        case .yellow: return "sun.max.fill"
        case .herbal: return "leaf.arrow.circlepath"
        case .rooibos: return "drop.triangle.fill"
        case .yerbaMate: return "leaf.circle.fill"
        case .matcha: return "hare.fill"
        case .chai: return "steam"
        case .flavored: return "star.fill"
        case .blooming: return "flower.fill"
        }
    }

    static func fromString(_ name: String) -> TeaType? {
        return Self.allCases.first { $0.description.caseInsensitiveCompare(name) == .orderedSame }
    }

    static func fromInt(_ rawValue: Int32) -> TeaType? {
        return TeaType(rawValue: rawValue)
    }
}


struct TeaTypeDropDown: View {
    @Binding var selectedTea: TeaType

    var body: some View {
        Picker("Select Tea Type", selection: $selectedTea) {
            ForEach(TeaType.allCases, id: \.self) { tea in
                Text(tea.description).tag(tea)
            }
        }
        .pickerStyle(.menu)
        .padding(8)
        .background(warmCream)
        .cornerRadius(5)
        .foregroundColor(.white)
        .accentColor(softChai)
    }
}


#Preview {
    struct PreviewWrapper: View {
        @State private var tea: TeaType = .black

        var body: some View {
            TeaTypeDropDown(selectedTea: $tea)
        }
    }

    return PreviewWrapper()
}
