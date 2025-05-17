//
//  FirstViewController.swift
//  CustomSegmentedControl
//
//  Created by 김정민 on 5/17/25.
//

import UIKit

final class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemRed
        
        print("### FirstViewController - viewDidLoad")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("### FirstViewController - viewDidAppear")
    }
    
}
