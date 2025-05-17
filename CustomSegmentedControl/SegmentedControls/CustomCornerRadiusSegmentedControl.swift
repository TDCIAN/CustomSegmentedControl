//
//  CustomCornerRadiusSegmentedControl.swift
//  CustomSegmentedControl
//
//  Created by 김정민 on 5/17/25.
//

import UIKit

// UIColor를 UIImage로 변환하는 확장 (필수)
extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

class CustomCornerRadiusSegmentedControl: UISegmentedControl {
    // 원하는 inset 및 cornerRadius 값 지정
    var segmentInset: CGFloat = 4
    var customCornerRadius: CGFloat = 16 // 원하는 값으로 변경

    var selectedBackgroundColor: UIColor = .white
    var normalBackgroundColor: UIColor = .systemGray5
    var borderColor: UIColor = .systemGray3
    var borderWidth: CGFloat = 1

    override func layoutSubviews() {
        super.layoutSubviews()

        // 전체 배경 및 border
        self.backgroundColor = normalBackgroundColor
        self.layer.cornerRadius = customCornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true

        // 선택된 segment 배경 커스텀
        let foregroundIndex = self.numberOfSegments
        
        if self.subviews.indices.contains(foregroundIndex),
           let foregroundImageView = self.subviews[foregroundIndex] as? UIImageView {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = UIImage(color: selectedBackgroundColor)
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = customCornerRadius - segmentInset
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}
