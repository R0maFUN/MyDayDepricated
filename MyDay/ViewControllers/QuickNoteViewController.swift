//
//  QuickNoteViewController.swift
//  MyDay
//
//  Created by Рома Балаян on 13.08.2023.
//

import UIKit

class QuickNoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialize()
        
        textField.becomeFirstResponder()
    }
    
    init(_ sectionsManager: ISectionsManager, note: NotesItemViewModel? = nil) {
        self.sectionsManager = sectionsManager
        self.itemViewModel = note ?? NotesItemViewModel(title: "", editDate: Date(), date: sectionsManager.currentSection.value!.date.date, type: .QuickNote)
        
        self.textField.text = self.itemViewModel.title
        
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private var sectionsManager: ISectionsManager
    private var itemViewModel: NotesItemViewModel
    
    private let input: UIView = {
        let view = UIView()
        return view
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Quick Note",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)]
        )
        textField.textAlignment = .left
        textField.font = .systemFont(ofSize: 16, weight: .semibold)
        return textField
    }()

}

private extension QuickNoteViewController {
    func initialize() {
        //self.view.backgroundColor = .black.withAlphaComponent(0.6)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        textField.delegate = self
        
        input.addSubview(textField)
        
        input.backgroundColor = .darkGray
        input.layer.cornerRadius = 10
        input.layer.shadowColor = UIColor.black.cgColor
        input.layer.shadowRadius = 12
        input.layer.shadowOpacity = 0.3
        input.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        view.addSubview(input)
        
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.top.bottom.equalToSuperview()
        }
        
        input.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.centerY.equalToSuperview().offset(-80)
            make.height.equalTo(80)
        }
        
    }
}

extension QuickNoteViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        self.itemViewModel.setTitle(title: text)
        
        // TODO: DATE is wrong
        if let section = self.sectionsManager.getSection(by: DateModel(date: self.itemViewModel.date)) {
            section.update(self.itemViewModel)
        } else {
            let section = NotesSectionViewModel(date: DateModel(date: self.itemViewModel.date))
            self.sectionsManager.add(section: section)
            section.add(self.itemViewModel)
        }
        
        self.dismiss(animated: true)
    }
    
}
