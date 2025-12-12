# 🐱 Advanced NSTextAttachment

> Display animated custom views inside NSAttributedString using iOS 15+ APIs

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 📖 Overview

This project demonstrates how to embed **animated custom views** directly inside text using `NSTextAttachment` and `NSTextAttachmentViewProvider`. Perfect for creating rich text experiences with inline animations, interactive elements, or SwiftUI views.

<p align="center">
  <img src="demo.gif" alt="Dancing cat in text demo" width="300"/>
</p>

## ✨ Features

- 🎬 **Animated Content** — Embed animated UIImageView inside text
- 📐 **Dynamic Sizing** — Attachment automatically scales with font size
- 🔄 **Baseline Alignment** — Proper vertical alignment with text
- ⚡ **iOS 15+ APIs** — Uses modern `NSTextAttachmentViewProvider`
- 🎛️ **Toggle Demo** — Compare static vs animated attachments

## 🚀 Getting Started

### Requirements

- iOS 15.0+
- Xcode 14+
- Swift 5.9+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/EvgeniiSamarin/AdvancedNSTextAttachment.git
```

2. Open `AdvancedNSTextAttachment.xcodeproj` in Xcode

3. Build and run on simulator or device

## 🛠️ How It Works

### 1. Custom NSTextAttachment

```swift
final class CatTextAttachment: NSTextAttachment {
    override var usesTextAttachmentView: Bool { true }
    
    override func viewProvider(
        for parentView: UIView?,
        location: any NSTextLocation,
        textContainer: NSTextContainer?
    ) -> NSTextAttachmentViewProvider? {
        CatTextAttachmentViewProvider(...)
    }
}
```

### 2. Custom View Provider

```swift
final class CatTextAttachmentViewProvider: NSTextAttachmentViewProvider {
    override func loadView() {
        let imageView = UIImageView()
        imageView.animationImages = // ... animation frames
        imageView.startAnimating()
        self.view = imageView
    }
    
    override func attachmentBounds(...) -> CGRect {
        let font = attributes[.font] as? UIFont
        let lineHeight = font?.lineHeight ?? 17
        return CGRect(x: 0, y: font?.descender ?? 0, width: lineHeight, height: lineHeight)
    }
}
```

### 3. Usage

```swift
let attachment = CatTextAttachment()
let attrString = NSAttributedString(attachment: attachment)
textView.attributedText = attrString
```

## 📁 Project Structure

```
AdvancedNSTextAttachment/
├── ContentView.swift           # Main demo view with toggle
├── AttributedText.swift        # UIViewRepresentable wrapper
├── Assets.xcassets/
│   └── danceCat/              # 144 animation frames
└── AdvancedNSTextAttachmentApp.swift
```

## 📝 Related Article

📰 **[Read the full article on Medium](https://medium.com/@e8geniosss/advanced-nstextattachment-displaying-custom-views-in-nsattributedstring-a442516a8af9)** — Deep dive into NSTextAttachment APIs with step-by-step explanations.

## 📄 License

This project is available under the MIT License. See the [LICENSE](LICENSE) file for more info.

## 👨‍💻 Author

**Evgenii Samarin**

- [LinkedIn](https://www.linkedin.com/in/EvgeniySamarin)
- [GitHub](https://github.com/EvgeniiSamarin)

---

⭐ If you found this helpful, please star the repository!
