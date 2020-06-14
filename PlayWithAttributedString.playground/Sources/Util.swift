import UIKit

public enum ParagraphAttribute {
    case alignment(NSTextAlignment)
    case lineSpacing(CGFloat)
    case lineBreakMode(NSLineBreakMode)
}

public enum StringAttribute {
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

public extension Array where Element == StringAttribute {
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
