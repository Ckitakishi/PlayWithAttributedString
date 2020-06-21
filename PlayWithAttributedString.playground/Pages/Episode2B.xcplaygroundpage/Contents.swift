//: [Previous](@previous)

import UIKit
import PlaygroundSupport

let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))

PlaygroundPage.current.liveView = containerView
containerView.backgroundColor = .white

struct AttributedString {
    var attributedString: NSAttributedString
    
    mutating func append(_ newStr: AttributedString) {
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttributedString.append(newStr.attributedString)
        self.attributedString = mutableAttributedString
    }
    
    mutating func append(contentsOf newStrs: [AttributedString]) {
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        newStrs.forEach { str in
            mutableAttributedString.append(str.attributedString)
        }
        self.attributedString = mutableAttributedString
    }
}

extension AttributedString: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        self.attributedString = NSAttributedString(string: stringLiteral)
    }
}

// ExpressibleByStringInterpolation inherits from ExpressibleByStringLiteral
extension AttributedString: ExpressibleByStringInterpolation {
    init(stringInterpolation: StringInterpolation) {
        self.attributedString = NSAttributedString(attributedString: stringInterpolation.attributedString)
    }
    
    // Custom String Interpolation Type
    struct StringInterpolation: StringInterpolationProtocol {
        var attributedString: NSMutableAttributedString
        
        init(literalCapacity: Int, interpolationCount: Int) {
            self.attributedString = NSMutableAttributedString()
        }

        mutating func appendLiteral(_ literal: String) {
            let attrString = NSAttributedString(string: literal)
            self.attributedString.append(attrString)
        }
        
        mutating func appendInterpolation(_ string: String, stringAttributes: [StringAttribute]) {
            let attrString = NSAttributedString(string: string,
                                                stringAttributes: stringAttributes)
            self.attributedString.append(attrString)
        }
    }
}

var attrString1: AttributedString = """
\("踟蹰不如", stringAttributes: [ .foregroundColor(.systemGray), .font(.systemFont(ofSize: 14.0)) ])
\("停止抱歉", stringAttributes: [ .foregroundColor(.systemGray2), .font(.systemFont(ofSize: 14.0)) ])

"""

let attrString2: AttributedString = """
\("再过秋天", stringAttributes: [ .foregroundColor(.systemGray3), .font(.systemFont(ofSize: 14.0)) ])
\("烂了蜿蜒", stringAttributes: [ .foregroundColor(.systemGray4), .font(.systemFont(ofSize: 14.0)) ])
"""

attrString1.append(attrString2)

let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
label.attributedText = attrString1.attributedString
label.numberOfLines = 0
label.sizeToFit()
containerView.addSubview(label)

//: [Next](@next)
