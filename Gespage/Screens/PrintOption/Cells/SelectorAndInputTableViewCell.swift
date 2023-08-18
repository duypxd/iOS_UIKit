//
//  SelectorAndInputTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 15/08/2023.
//

import UIKit

class SelectorAndInputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var paperSizeView: UIView!
    @IBOutlet weak var paperSizeLabel: UILabel!
    @IBOutlet weak var numberOfCopies: UITextField!
    
    var tapAction: (() -> Void)?
    var onChangedNumberOfCopies: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configurePaperSizeView()
        configureTextField()
        configureNumberPadToolbar()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectorViewTapped))
        paperSizeView.addGestureRecognizer(tapGesture)
        
        numberOfCopies.addTarget(self, action: #selector(onChangedNumberCopies(_:)), for: .editingChanged)
    }
    
    @IBAction func onChangedNumberCopies(_ textField: UITextField) {
        if textField == numberOfCopies {
            numberOfCopies.text = textField.text ?? ""
            onChangedNumberOfCopies?(textField.text ?? "")
        }
    }
    
    @objc func selectorViewTapped() {
        tapAction?()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }
}

// MARK: - Private Extensions
private extension SelectorAndInputTableViewCell {
    func configurePaperSizeView() {
        StyleHelper.selectorLayer(layer: paperSizeView.layer)
    }
    
    func configureTextField() {
        numberOfCopies.delegate = self
        numberOfCopies.keyboardType = .numberPad
        numberOfCopies.returnKeyType = .done
        
        StyleHelper.selectorLayer(layer: numberOfCopies.layer)
        
        numberOfCopies.backgroundColor = .white
        numberOfCopies.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        numberOfCopies.leftViewMode = .always
        numberOfCopies.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        numberOfCopies.rightViewMode = .always
    }
}

// MARK: - Setup TextField keyboard
extension SelectorAndInputTableViewCell: UITextFieldDelegate {
    func configureNumberPadToolbar() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let toolbar = UIToolbar()
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton]
        toolbar.sizeToFit()
        numberOfCopies.inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonTapped() {
        numberOfCopies.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
