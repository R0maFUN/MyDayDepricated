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
        
        textView.becomeFirstResponder()
    }
    
    init(_ sectionsManager: ISectionsManager, note: NotesItemViewModel? = nil) {
        self.sectionsManager = sectionsManager
        self.itemViewModel = note ?? NotesItemViewModel(title: "", editDate: Date(), date: sectionsManager.currentSection.value!.date.date, type: .QuickNote)
        
        self.textView.text = self.itemViewModel.title
        
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            textView.text = "Quick Note"
            textView.updateFloatingCursor(at: CGPoint(x: 0, y: 0))
        }
        
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var sectionsManager: ISectionsManager
    private var itemViewModel: NotesItemViewModel
    
    private let input: UIView = {
        let view = UIView()
        return view
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.textAlignment = .left
        textView.font = .systemFont(ofSize: 16, weight: .semibold)
        return textView
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
        
        textView.delegate = self
        
        textView.backgroundColor = .clear
        
        input.addSubview(textView)
        
        input.backgroundColor = .darkGray
        input.layer.cornerRadius = 10
        input.layer.shadowColor = UIColor.black.cgColor
        input.layer.shadowRadius = 12
        input.layer.shadowOpacity = 0.3
        input.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        view.addSubview(input)
        
        input.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.centerY.equalToSuperview().offset(-80)
            make.height.equalTo(80)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.top.bottom.equalToSuperview()
        }
        
    }
}

extension QuickNoteViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .white
        }
        
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        return true
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = UIColor.black
//        }
//    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        guard let text = textView.text else { return }
        
        if text.isEmpty || text == "Quick Note" {
            self.dismiss(animated: true)
            return
        }
        
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
