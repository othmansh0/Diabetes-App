//
//  CodeTextFieldViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 1/1/22.
//
import UIKit

class CodeTextFieldViewController:  UITextField {

    var didEnterLastDigit: ((String) -> Void)?

    var defaultCharacter = "-"

    private var digitLabels = [UILabel]()
//    private lazy var tapRecgonizer: UITapGestureRecognizer = {
//        //lazy to add target
//        let recognizer = UITapGestureRecognizer()
//        //when tap is received it shows keyboard
//        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
//        return recognizer
//    }()
    
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    
    func configure(with digits: Int = 6) {
        configureTextField()
        
        let labelStackView = createLableStackView(with: digits)
        //add it to our textfield as subview and set constraints on it
        addSubview(labelStackView)
        //adds recognizer to textfield
        addGestureRecognizer(tapRecognizer)
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: topAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    
    //configure textfield
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode//fills the code automatically
        //call this everytime the text changes
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }

    private func createLableStackView(with count: Int) -> UIStackView {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal//place everything in stack hori
        stackView.alignment = .fill//fill up entire area
        stackView.distribution = .fillEqually //each label spaced equally
        stackView.spacing = 8
        
        for _ in 1 ... count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 40)
            label.backgroundColor = #colorLiteral(red: 0.9411765933, green: 0.9411765337, blue: 0.9411765337, alpha: 1)
            label.layer.masksToBounds = true
            label.numberOfLines = 10
            label.layer.cornerRadius = 10
            label.isUserInteractionEnabled = true
            //label.text = defaultCharacter
            
            //label.addGestureRecognizer(tapRecgonizer)
            
            stackView.addArrangedSubview(label)
            
            digitLabels.append(label)
        }
        return stackView
    }
//update each label when textfield changes
    @objc private func textDidChange() {
        
        //access text in textField
        guard let text = self.text, text.count <= digitLabels.count else { return }
        //loop over lables eveytime text changes and update values
        //we dont know which label should be updated so we update all of em
        
        //not exceed n.o of labels created
        //check if numbers are <= n.o of labels (6)
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            
           
            if i < text.count {
                //match each character with label
                //by adding the index of label to start index 0+3
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
                
            } else {//rest of empty labels,every backspace make current label remove current text
                //Removing a char decreases text.count so else gets excuted
                currentLabel.text?.removeAll()
                //currentLabel.text = defaultCharacter
            }
        }
        if text.count == digitLabels.count {
            
            didEnterLastDigit?(text)
        }
    }
    


}

extension CodeTextFieldViewController: UITextFieldDelegate {
    //make sure our text we dont exceed number of digits
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let charCount = textField.text?.count else { return false }
        //second condition for backspace
        return charCount < digitLabels.count || string == ""
    }
}
