//
//  EditGoalsItemViewController.swift
//  MyDay
//
//  Created by Рома Балаян on 18.08.2023.
//

import UIKit

class GoalTextFieldInputModel {
    public func onValueChanged(_ handler: @escaping (_: String) -> Void) {
        self.onValueChangedHandlers.append(handler)
    }
    
    init(placeholder: String = "") {
        self.placeholder = placeholder
    }
    
    public var placeholder: String = ""
    private var onValueChangedHandlers: [(_: String) -> Void] = []
}

class GoalNumberTextFieldInputModel {
    init(placeholder: String = "") {
        self.placeholder = placeholder
    }
    
    public var placeholder: String = ""
}

class GoalMenuTextFieldInputModel {
    init(placeholder: String = "") {
        self.placeholder = placeholder
    }
    
    public var placeholder: String = ""
}

enum GoalCounterInputType {
    case textField(_ model: GoalTextFieldInputModel)
    case numberTextField(_ model: GoalNumberTextFieldInputModel)
    case menuTextField(_ model: GoalMenuTextFieldInputModel)
}

class EditGoalsItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.instructionView.configureArrows()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !(self.isReady.value ?? false) {
            return
        }
        
        HapticsManager.shared.vibrate(for: .success)
        
        // TODO: DATE is wrong
        if let section = self.sectionsManager.getSection(by: DateModel(date: self.itemViewModel.date)) {
            section.update(self.itemViewModel)
            //dismiss(animated: true)
        } else {
            let section = GoalsSectionViewModel(date: DateModel(date: self.itemViewModel.date))
            self.sectionsManager.add(section: section)
            section.add(self.itemViewModel)
            //dismiss(animated: true)
        }
    }
    
    init(_ sectionsManager: ISectionsManager, goal: GoalsItemViewModel? = nil) {
        self.sectionsManager = sectionsManager
        
        self.itemViewModel = goal ?? GoalsItemViewModel(descriptions: ("Drink", "of water"), goalValue: 1000, currentValue: 0, stepValue: 50, date: self.sectionsManager.currentSection.value!.date.date, type: .Counter)
        
        self.currentView = UIView()
        
        self.inputs = [
            .textField(GoalTextFieldInputModel(placeholder: self.itemViewModel.descriptions.0)),
            .numberTextField(GoalNumberTextFieldInputModel(placeholder: String(format: "%.0f", self.itemViewModel.goalValue))),
            .textField(GoalTextFieldInputModel(placeholder: self.itemViewModel.descriptions.1)),
            .numberTextField(GoalNumberTextFieldInputModel(placeholder: String(format: "%.0f", self.itemViewModel.stepValue)))
        ]
        
        self.instructionView = AddGoalInstructionView(with: self.itemViewModel)
        
        super.init(nibName: .none, bundle: .none)
        
        self.isReady.onChanged {
            self.updateRightBarButton()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var sectionsManager: ISectionsManager
    private var itemViewModel: GoalsItemViewModel
    private var currentIndex: Int = 0
    private var currentView: UIView
    
    private let instructionView: AddGoalInstructionView
    
    private let input: UIView = {
        let view = UIView()
        return view
    }()
    
    private var inputViews: [UIView] = []
    private let inputs: [GoalCounterInputType]
    
    private var isReady: PropertyBinding<Bool> = PropertyBinding(false)
}

// MARK: - Initialize
private extension EditGoalsItemViewController {
    func initialize() {

        updateRightBarButton()
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        view.addSubview(instructionView)
        instructionView.layer.cornerRadius = 20

        self.setupInputsViews()

        instructionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(6)
            make.bottom.equalTo(inputViews.first!.snp.top).offset(-50)
            make.height.equalTo(200)
        }
    }
    
    func updateRightBarButton() {
        //UIBarButtonItem(systemItem: .close)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneBarButtonPressed))
        navigationItem.rightBarButtonItem?.isEnabled = self.isReady.value ?? false
    }
    
    func setupInputsViews() {
        
        for (index, input) in self.inputs.enumerated() {
            let inputView = UIView()
            
            inputView.backgroundColor = .darkGray
            inputView.layer.cornerRadius = 10
            inputView.layer.shadowColor = UIColor.black.cgColor
            inputView.layer.shadowRadius = 12
            inputView.layer.shadowOpacity = 0.3
            inputView.layer.shadowOffset = CGSize(width: 0, height: 0)
            inputView.isHidden = self.currentIndex != index
            
            if self.currentIndex == index {
                self.currentView = inputView
            }
            
            var subview: UIView = UIView()
            
            switch (input.self) {
            case .textField(let model):
                subview = UITextField()
                if let subview = subview as? UITextField {
                    subview.placeholder = model.placeholder
                    subview.backgroundColor = .clear
                    subview.delegate = self
                    
                    if self.currentIndex == index {
                        subview.becomeFirstResponder()
                    }
                }
                break
            case .numberTextField(let model):
                subview = UIView()
                let textField = UITextField()
                textField.placeholder = model.placeholder
                textField.keyboardType = .asciiCapableNumberPad
                textField.backgroundColor = .clear
                textField.delegate = self
                
                if self.currentIndex == index {
                    textField.becomeFirstResponder()
                }
                
                subview.addSubview(textField)
                
                let doneButton = UIButton()
                doneButton.backgroundColor = UIColor(named: "Primary")!
                doneButton.layer.cornerRadius = 8
                doneButton.tintColor = .white
                doneButton.setTitle("Done", for: .normal)
                doneButton.addAction(UIAction(handler: { _ in
                    textField.resignFirstResponder()
                }), for: .touchUpInside)
                doneButton.layer.zPosition = 9999
                
                
                subview.addSubview(doneButton)
                
                doneButton.snp.makeConstraints { make in
                    make.centerY.trailing.equalToSuperview()
                    make.width.equalTo(80)
                    make.height.equalTo(40)
                }
                
                textField.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                break
            case .menuTextField(var model):
                subview = UIView()

                break
            }
            
            inputView.addSubview(subview)
            
            self.view.addSubview(inputView)
            
            // Mb crash coz inputView is not added yet
            subview.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(18)
                make.top.bottom.equalToSuperview()
            }
            
            inputView.snp.makeConstraints { make in
                make.centerY.equalToSuperview().offset(-50)
                make.height.equalTo(80)
            }
            
            switch (input.self) {
            case .textField(var model):
                inputView.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(18)
                }
                break
            case .numberTextField(var model):
                inputView.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(70)
                }
                break
            case .menuTextField(var model):
                inputView.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(70)
                }
                break
            }
            
            self.inputViews.append(inputView)
        }
    }
    
    func updateInputViews() {
        
    }
    
    func setItemValue(_ value: String) {
        if self.currentIndex == 0 {
            self.itemViewModel.setDescriptionFirst(description: value)
        } else if self.currentIndex == 1 {
            self.itemViewModel.setGoalValue(value: value)
        } else if self.currentIndex == 2 {
            self.itemViewModel.setDescriptionSecond(description: value)
        } else if self.currentIndex == 3 {
            self.itemViewModel.setStepValue(value: value)
            self.isReady.value = true
        }
    }
    
    func onValueChanged(_ value: String) {
        setItemValue(value) // before currentIndex change
        
        openNextInput()
        self.instructionView.nextStep()
    }
    
    func openNextInput() {
        self.currentView.isHidden = true
        // dismiss
        if self.currentIndex >= self.inputViews.count - 1 {
            // show last view and done button
            navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        self.currentIndex += 1
        self.currentView = self.inputViews[self.currentIndex]
        self.currentView.isHidden = false
        
        if let field = self.currentView as? UITextField {
            field.becomeFirstResponder()
        }
    }
    
    @objc func onDoneBarButtonPressed() {
        dismiss(animated: true)
    }
}

extension EditGoalsItemViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        self.onValueChanged(text)
        
//        if text.isEmpty || text == "Quick Note" {
//            self.dismiss(animated: true)
//            return
//        }
//
//        self.itemViewModel.setTitle(title: text)
//
//        // TODO: DATE is wrong
//        if let section = self.sectionsManager.getSection(by: DateModel(date: self.itemViewModel.date)) {
//            section.update(self.itemViewModel)
//        } else {
//            let section = NotesSectionViewModel(date: DateModel(date: self.itemViewModel.date))
//            self.sectionsManager.add(section: section)
//            section.add(self.itemViewModel)
//        }
        
        //self.dismiss(animated: true)
    }
}
