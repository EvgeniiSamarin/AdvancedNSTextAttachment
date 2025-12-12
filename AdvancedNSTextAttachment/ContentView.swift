//
//  ContentView.swift
//  AdvancedNSTextAttachment
//
//  Created by Евгений Самарин on 22.11.2025.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TextContentView()
                .navigationTitle("Advanced NSTextAttachment")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct TextContentView: View {
    private static let fontSize: CGFloat = 48
    private static let font = UIFont.systemFont(ofSize: fontSize)
    
    @State private var attrText: NSMutableAttributedString = {
        let text = NSMutableAttributedString(
            string: "Hello! Tap the button to add a cat → ",
            attributes: [.font: TextContentView.font]
        )
        return text
    }()
    
    @State private var useCustomAttachment: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            AttributedText(attributedText: $attrText)
                .padding(.horizontal, 16)
            
            Toggle(isOn: $useCustomAttachment) {
                Text(useCustomAttachment ? "Custom Attachment (Animated)" : "System Attachment (Static)")
                    .font(.headline)
            }
            .padding(.horizontal, 24)
            
            Button(
                action: {
                    // Create a new object so SwiftUI sees the change
                    let newText = NSMutableAttributedString(attributedString: attrText)
                    
                    let attachment: NSTextAttachment
                    if useCustomAttachment {
                        // Custom attachment with animated view
                        attachment = CatTextAttachment()
                    } else {
                        // System attachment with static image
                        let staticImage = UIImage(named: "1-dance_cat") ?? UIImage()
                        attachment = NSTextAttachment(image: staticImage)
                    }
                    
                    let attrAttachment = NSMutableAttributedString(attachment: attachment)
                    attrAttachment.addAttribute(.font, value: Self.font, range: NSRange(location: 0, length: attrAttachment.length))
                    newText.append(attrAttachment)
                    attrText = newText
                },
                label: {
                    VStack {
                        Text(useCustomAttachment ? "Add animated cat 🎬" : "Add static cat 🖼️")
                        if useCustomAttachment {
                            CatImageView()
                                .frame(width: 56, height: 56)
                        } else {
                            Image(uiImage: UIImage(named: "1-dance_cat") ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 56, height: 56)
                        }
                    }
                }
            )
        }
    }
}

private struct CatImageView: UIViewRepresentable {
    var size: CGFloat = 56

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.animationImages = Array(1...144).compactMap { UIImage(named: "\($0)-dance_cat") }
        imageView.animationRepeatCount = 0
        imageView.contentMode = .scaleAspectFit
        imageView.startAnimating()
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        if !uiView.isAnimating {
            uiView.startAnimating()
        }
    }
}

final class CatTextAttachment: NSTextAttachment {
    override init(data contentData: Data?, ofType uti: String?) {
        super.init(data: contentData, ofType: uti)
        self.allowsTextAttachmentView = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var usesTextAttachmentView: Bool { true }

    override func viewProvider(
        for parentView: UIView?,
        location: any NSTextLocation,
        textContainer: NSTextContainer?
    ) -> NSTextAttachmentViewProvider? {
        CatTextAttachmentViewProvider(
            textAttachment: self,
            parentView: parentView,
            textLayoutManager: textContainer?.textLayoutManager,
            location: location
        )
    }
}

final class CatTextAttachmentViewProvider: NSTextAttachmentViewProvider {
    override init(
      textAttachment: NSTextAttachment,
      parentView: UIView?,
      textLayoutManager: NSTextLayoutManager?,
      location: any NSTextLocation
    ) {
      super.init(
        textAttachment: textAttachment,
        parentView: parentView,
        textLayoutManager: textLayoutManager,
        location: location
      )
      tracksTextAttachmentViewBounds = true
    }

    override func loadView() {
        let imageView = UIImageView()
        imageView.animationImages = Array(1...144).compactMap { UIImage(named: "\($0)-dance_cat") }
        imageView.animationRepeatCount = 0
        imageView.contentMode = .scaleAspectFit
        imageView.startAnimating()
        self.view = imageView
    }

    override func attachmentBounds(
      for attributes: [NSAttributedString.Key: Any],
      location: any NSTextLocation,
      textContainer: NSTextContainer?,
      proposedLineFragment: CGRect,
      position: CGPoint
    ) -> CGRect {
      // Get font from attributes or use system default
      let font = attributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
      let lineHeight = font.lineHeight
      
      return CGRect(
        x: .zero,
        y: font.descender, // Offset down to align with baseline
        width: lineHeight,
        height: lineHeight
      )
    }
}

#Preview {
    ContentView()
}
