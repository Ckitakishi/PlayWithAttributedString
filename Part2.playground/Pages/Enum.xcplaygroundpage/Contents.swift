//: [Previous](@previous)

import UIKit
import PlaygroundSupport

let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))

PlaygroundPage.current.liveView = containerView
containerView.backgroundColor = .white

extension NSAttributedString {
    convenience init(image: UIImage, offsetX: CGFloat, offsetY: CGFloat, scale: CGFloat = 1.0) {
        let attachment = NSTextAttachment()
        
        let size: CGSize = {
            guard scale != 1.0 else { return image.size }
            return image.size.applying(CGAffineTransform(scaleX: scale, y: scale))
        }()
        
        attachment.bounds = .init(origin: .init(x: offsetX, y: offsetY), size: size)
        attachment.image = image
        
        self.init(attachment: attachment)
    }
}

// [Enum] Define attributes using enum to help build NSAttributedString
enum AttributedString {
    case string(String, [StringAttribute]?)
    case image(UIImage, offsetX: CGFloat = 0.0, offsetY: CGFloat = 0.0, scale: CGFloat = 1.0)
    
    static func assemble(_ attrStrings: [AttributedString]) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: "")
        attrStrings.forEach { (attrString: AttributedString) in
            switch attrString {
            case .string(let string, let attributes):
                mutableAttributedString.append(.init(string: string, attributes: attributes?.attributesDictionary))
            case .image(let image, let offsetX, let offsetY, let scale):
                mutableAttributedString.append(.init(image: image, offsetX: offsetX, offsetY: offsetY, scale: scale))
            }
        }
        return mutableAttributedString
    }
}

let label = UILabel()
label.attributedText = AttributedString.assemble([
    .image(UIImage(named: "stop") ?? UIImage(), offsetX: 0.0, offsetY: -8.0, scale: 0.5),
    .string("踟蹰不如", [ .foregroundColor(.gray) ]),
    .string("停止抱歉", [ .foregroundColor(.orange) ])
])
label.sizeToFit()
containerView.addSubview(label)

//: [Next](@next)
