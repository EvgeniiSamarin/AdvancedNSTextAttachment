//
//  AttributedText.swift
//  AdvancedNSTextAttachment
//
//  Created by Евгений Самарин on 22.11.2025.
//

import SwiftUI
import UIKit

struct AttributedText: UIViewRepresentable {
    @Binding var attributedText: NSMutableAttributedString

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        textView.setContentHuggingPriority(.required, for: .vertical)
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
        textView.delegate = context.coordinator
        textView.attributedText = attributedText
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedText
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: AttributedText
        var isUpdatingFromBinding = false

        init(_ parent: AttributedText) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.attributedText = .init(attributedString: textView.attributedText) 
        }
    }
}
