//
//  ThirdViewController.swift
//  CustomSegmentedControl
//
//  Created by 김정민 on 5/17/25.
//

import UIKit

final class ThirdViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        print("### ThirdViewController viewDidLoad")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("### ThirdViewController - viewDidAppear")
    }
}
