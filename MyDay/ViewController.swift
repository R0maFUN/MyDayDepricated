//
//  ViewController.swift
//  MyDay
//
//  Created by Рома Балаян on 11.07.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(someView)
        
        someView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(200)
        }
    }
    
    private let someView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()


}

