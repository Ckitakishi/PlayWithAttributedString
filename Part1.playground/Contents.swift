import UIKit
import PlaygroundSupport

let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))

PlaygroundPage.current.liveView = containerView
containerView.backgroundColor = .white

// Normal
let label = UILabel()

let paragraphStyle = NSMutableParagraphStyle()
paragraphStyle.lineSpacing = 1.0
paragraphStyle.lineBreakMode = .byTruncatingTail
paragraphStyle.alignment = .center

label.attributedText = NSAttributedString(
    string: "卮言春天 破碎秋千",
    // The type of value is `Any`, means compiler won't check the type for you
    attributes: [
        .font: UIFont.systemFont(ofSize: 12.0, weight: .regular),
        // If set color to `UIColor.gray.cgColor` mistakenly, app will crash if language is English, but nothing will happen if language is set to Chinese or Japanese
        .foregroundColor: UIColor.gray,
        .paragraphStyle: paragraphStyle
])

label.sizeToFit()
containerView.addSubview(label)

// Build a type-safe wrapper for NSAttributedString
enum ParagraphAttribute {
    case alignment(NSTextAlignment)
    case lineSpacing(CGFloat)
    case lineBreakMode(NSLineBreakMode)
}

enum StringAttribute {
    case font(UIFont)
    case foregroundColor(UIColor)
    case underlineStyle(NSUnderlineStyle)
    case underlineColor(UIColor?) // The default value is nil
    case kern(CGFloat)
    case paragraphStyle([ParagraphAttribute])
    // ...
    
    var keyAndValue: (NSAttributedString.Key, Any?) {
        switch self {
        case .font(let value):
            return (.font, value)
        case .foregroundColor(let value):
            return (.foregroundColor, value)
        case .underlineStyle(let value):
            return (.underlineStyle, value.rawValue)
        case .underlineColor(let optionalValue):
            return (.underlineColor, optionalValue)
        case .kern(let value):
            return (.kern, value as NSNumber)
        case .paragraphStyle(let value):
            return (.paragraphStyle, self.configureParagraphStyle(value))
        }
        // ...
    }
    
    // [ParagraphAttribute] => NSMutableParagraphStyle
    private func configureParagraphStyle(_ attributes: [ParagraphAttribute]) -> NSMutableParagraphStyle {
        
        let paragraphStyle = NSMutableParagraphStyle()

        attributes.forEach {
            switch $0 {
            case .alignment(let value):
                paragraphStyle.alignment = value
            case .lineSpacing(let value):
                paragraphStyle.lineSpacing = value
            case .lineBreakMode(let value):
                paragraphStyle.lineBreakMode = value
            }
        }
        
        return paragraphStyle
    }
}

extension Array where Element == StringAttribute {
    // StringAttribute => [NSAttributedString.Key: Any]
    var attributesDictionary: [NSAttributedString.Key: Any] {
        var attributesDict: [NSAttributedString.Key: Any] = [:]
        
        self.forEach { attribute in
            let (key, value) = attribute.keyAndValue
            attributesDict[key] = value
        }
        
        return attributesDict
    }
}

extension NSAttributedString {
    convenience init(string str: String, stringAttributes attrs: [StringAttribute]) {
        self.init(string: str, attributes: attrs.attributesDictionary)
    }
}

let label2 = UILabel(frame: CGRect(x: 0, y: 30, width: 0, height: 0))

label2.attributedText = NSAttributedString(
    string: "卮言春天 破碎秋千",
    stringAttributes: [
        .font(.systemFont(ofSize: 12.0, weight: .regular)),
        .foregroundColor(.gray),
        .paragraphStyle([
              .lineSpacing(1.0),
              .lineBreakMode(.byTruncatingTail),
              .alignment(.center)
        ])
])

label2.sizeToFit()
containerView.addSubview(label2)
