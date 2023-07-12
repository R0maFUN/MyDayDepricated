//
//  MainViewController.swift
//  MyDay
//
//  Created by Рома Балаян on 12.07.2023.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(datesCollectionView)
        
        datesCollectionView.backgroundColor = .red
        
        datesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(70)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    // MARK: - Private Properties
    
    private let datesCollectionView: DatesCollectionView = {
        let view = DatesCollectionView()
        return view
    }()

}
