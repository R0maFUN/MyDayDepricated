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
        } else {
            let section = GoalsSectionViewModel(date: DateModel(date: self.itemViewModel.date))
            self.sectionsManager.add(section: section)
            section.add(self.itemViewModel)
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
        
        self.isNextEnabled.onChanged {
            self.updateBarButtons()
        }
        
        self.isBackEnabled.onChanged {
            self.updateBarButtons()
        }
        
        self.isReady.onChanged {
            self.updateBarButtons()
        }
        
        self.itemViewModel.onDescriptionFirstChanged {
            self.updateBarButtons()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private enum UIConstants {
        static let contentInset = 18.0
        static let segmentedTopOffset = 54.0
        static let instructionToInputOffset = 18.0
        static let inputToCenterOffset = 10.0
    }
    
    private var sectionsManager: ISectionsManager
    private var itemViewModel: GoalsItemViewModel
    private var currentIndex: Int = 0
    private var currentView: UIView
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        return control
    }()
    
    private let instructionView: AddGoalInstructionView
    
    private var inputViews: [UIView] = []
    private let inputs: [GoalCounterInputType]
    
    private var isReady: PropertyBinding<Bool> = PropertyBinding(false)
    private var isNextEnabled: PropertyBinding<Bool> = PropertyBinding(false)
    private var isBackEnabled: PropertyBinding<Bool> = PropertyBinding(false)
}

// MARK: - Initialize
private extension EditGoalsItemViewController {
    func initialize() {

        updateBarButtons()
        
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
            make.bottom.equalTo(inputViews.first!.snp.top).offset(-1 * UIConstants.instructionToInputOffset)
            make.height.equalTo(200)
        }
        
        self.setupSegmentedControl()
    }
    
    // MARK: - Setup Input Views
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
                    subview.textColor = .white
                    subview.tintColor = .white
                    subview.text = model.placeholder
                    subview.backgroundColor = .clear
                    subview.delegate = self
                    
                    subview.addTarget(self, action: #selector(textFieldTextChanged(textField:)), for: .editingChanged)
                    
                    if self.currentIndex == index {
                        subview.becomeFirstResponder()
                    }
                }
                break
            case .numberTextField(let model):
                subview = UIView()
                let textField = UITextField()
                textField.textColor = .white
                textField.tintColor = .white
                textField.text = model.placeholder
                textField.keyboardType = .asciiCapableNumberPad
                textField.backgroundColor = .clear
                textField.delegate = self
                
                textField.addTarget(self, action: #selector(textFieldTextChanged(textField:)), for: .editingChanged)
                
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
                    self.onNextInputRequested()
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
            case .menuTextField(_):
                subview = UIView()

                break
            }
            
            inputView.addSubview(subview)
            
            self.view.addSubview(inputView)
            
            // Mb crash coz inputView is not added yet
            subview.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(UIConstants.contentInset)
                make.top.bottom.equalToSuperview()
            }
            
            inputView.snp.makeConstraints { make in
                make.centerY.equalToSuperview().offset(-1 * UIConstants.inputToCenterOffset)
                make.height.equalTo(80)
            }
            
            switch (input.self) {
            case .textField(_):
                inputView.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(UIConstants.contentInset)
                }
                break
            case .numberTextField(_):
                inputView.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(70)
                }
                break
            case .menuTextField(_):
                inputView.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(70)
                }
                break
            }
            
            self.inputViews.append(inputView)
        }
    }
    
    // MARK: - Setup Segmented Control
    private func setupSegmentedControl() {
        self.segmentedControl.insertSegment(withTitle: "Amount", at: 0, animated: false)
        self.segmentedControl.insertSegment(withTitle: "Time", at: 1, animated: false)
        self.segmentedControl.insertSegment(withTitle: "Binary", at: 2, animated: false)
        
        self.segmentedControl.selectedSegmentIndex = 0
        
        self.segmentedControl.addTarget(self, action: #selector(onSegmentedControlValueChanged), for: .valueChanged)
        
        self.view.addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIConstants.contentInset)
            //make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(16)
            make.top.equalToSuperview().offset(UIConstants.segmentedTopOffset)
            make.height.equalTo(50)
        }
    }
    
    @objc final private func onSegmentedControlValueChanged() {
        
    }
}

// MARK: - Bar Buttons
private extension EditGoalsItemViewController {
    @objc final private func onDoneBarButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc private func onBackButtonPressed() {
        self.onPrevInputRequested()
    }
    
    @objc private func onNextButtonPressed() {
        self.onNextInputRequested()
    }
    
    func updateBarButtons() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(onBackButtonPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneBarButtonPressed))
        navigationItem.rightBarButtonItem?.isEnabled = self.isReady.value ?? false
        
        if self.isReady.value ?? false {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneBarButtonPressed))
            navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        
        if self.isNextEnabled.value ?? false {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(onNextButtonPressed))
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(onNextButtonPressed))
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        if self.isBackEnabled.value ?? false {
            navigationItem.leftBarButtonItem?.isEnabled = true
        } else {
            navigationItem.leftBarButtonItem?.isEnabled = false
        }
    }
}

// MARK: - TextField
extension EditGoalsItemViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            //textField.resignFirstResponder()
            self.onNextInputRequested()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // self.onNextInputRequested()
    }
    
    @objc final private func textFieldTextChanged(textField: UITextField) {
        guard let text = textField.text else { return }
        
        self.setItemValue(text)
        
        self.isNextEnabled.value = !text.isEmpty
    }
}

// MARK: - Set Item Value
private extension EditGoalsItemViewController {
    // create edit goals viewmodel with state to process this there
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
}

// MARK: - Input
private extension EditGoalsItemViewController {
    func onNextInputRequested() {
        openNextInput()
        self.instructionView.nextStep()
    }
    
    func onPrevInputRequested() {
        openPrevInput()
        self.instructionView.prevStep()
    }
    
    func openNextInput() {
        self.currentView.isHidden = true
        // dismiss
        if self.currentIndex >= self.inputViews.count - 1 {
            // done actions
            return
        }
        
        if self.currentIndex == self.inputViews.count - 2 {
            // show last view and done button
            self.isNextEnabled.value = false
            updateBarButtons()
        }
        
        self.currentIndex += 1
        self.currentView = self.inputViews[self.currentIndex]
        self.currentView.isHidden = false
        
        self.isBackEnabled.value = true
        updateBarButtons()
        
        self.currentView.subviews.forEach { subview in
            if let field = subview as? UITextField {
                field.becomeFirstResponder()
                return
            }
            
            subview.subviews.forEach { view in
                if let field = view as? UITextField {
                    field.becomeFirstResponder()
                    return
                }
            }
        }
    }
    
    func openPrevInput() {
        self.currentView.isHidden = true
        
        if self.currentIndex <= 0 {
            return
        }
        
        self.currentIndex -= 1
        self.currentView = self.inputViews[self.currentIndex]
        self.currentView.isHidden = false
        
        if self.currentIndex == 0 {
            self.isBackEnabled.value = false
            updateBarButtons()
        }
        
        if let field = self.currentView as? UITextField {
            field.becomeFirstResponder()
        }
    }
}
