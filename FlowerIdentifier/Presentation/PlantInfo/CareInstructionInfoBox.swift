//
//  CareInstructionInfoBox.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthamer on 03/12/2023.
//

import SwiftUI

struct CareInstructionsBox: View {
    enum Mode {
        case problems
        case instructions
        case uses
        
        var copyTitle: String {
            return switch self {
            case .problems:
                "Health problems"
            case .instructions:
                "Care instructions"
            case .uses:
                "Uses"
            }
        }
        
        var copyButtonTitle: String {
            return switch self {
            case .problems:
                "Copy Problems"
            case .instructions:
                "Copy Instructions"
            case .uses:
                "Copy Uses"
            }
        }
    }
    
    let mode: Mode
    let plantName: String
    let instructions: [String]
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 0) {
                ForEach(0..<instructions.count, id: \.self, content: instructionField)
            }
            .cornerRadius(style: .small, strokeColor: Color.separator, strokeWidth: 0.5)
            
            CopyableTextButton(text: mode.copyButtonTitle, textToCopy: formattedInstructionsForCopying())
                .font(.system(.body, design: .rounded, weight: .semibold))
        }
    }
    
    private func instructionField(for index: Int) -> some View {
        HStack(spacing: 24) {
            Text(String(index + 1))
                .foregroundStyle(Color.subtitle)
                .font(.system(.headline, design: .rounded))
            
            Text(instructions[index])
                .font(.system(.body, design: .rounded, weight: .regular))
                .foregroundStyle(Color.title)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(index % 2 == 0 ? Color(.secondarySystemFill) : Color(.quaternarySystemFill))
    }
    
    private func formattedInstructionsForCopying() -> String {
        var numberedInstructions = instructions
        for (index, instruction) in numberedInstructions.enumerated() {
            var instruction = instruction
            instruction.insert(contentsOf: "\(index + 1). ", at: instruction.startIndex)
            numberedInstructions[index] = instruction
        }
        
        let joinedInstructions = numberedInstructions.joined(separator: "\n")
        let instructionsWithTitle = "\(mode.copyTitle) for \(plantName):\n\(joinedInstructions)"
        
        return instructionsWithTitle
    }
}
