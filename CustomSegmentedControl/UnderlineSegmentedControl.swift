//
//  UnderlineSegmentedControl.swift
//  CustomSegmentedControl
//
//  Created by 김정민 on 5/17/25.
//

import UIKit

final class UnderlineSegmentedControl: UISegmentedControl {
    
    private lazy var underlineView: UIView = {
        let width: CGFloat = self.bounds.width / CGFloat(self.numberOfSegments)
        let height: CGFloat = 5
        let xPosition: CGFloat = CGFloat(self.selectedSegmentIndex * Int(width))
        let yPosition: CGFloat = self.bounds.height - height
        
        let frame: CGRect = CGRect(
            x: xPosition,
            y: yPosition,
            width: width,
            height: height
        )
        
        let view = UIView(frame: frame)
        view.backgroundColor = .systemBlue
        
        self.addSubview(view)
        self.clipsToBounds = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        removeBackgroundAndDivider()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)

        removeBackgroundAndDivider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func removeBackgroundAndDivider() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let underlineFinalXPosition: CGFloat = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
        
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.underlineView.frame.origin.x = underlineFinalXPosition
            }
        )
    }
}
