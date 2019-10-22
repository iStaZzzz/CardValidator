//
//  ViewController.swift
//  CardValidatorExample
//
//  Created by Stanislav Ivanov on 19.10.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import UIKit
import CardValidator

final class ViewController: UIViewController {

    private let cardValidator: CardValidatorProtocol = CardValidator.shared
    
    @IBOutlet private weak var numberTextField:  UITextField?
    @IBOutlet private weak var numberErrorLabel: UILabel?
    @IBOutlet private weak var numberBrandLabel: UILabel?
}


extension ViewController: UITextFieldDelegate {
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange, with: string)
           
            self.updateNumberStatus(number: updatedText)
        }
        
        return true
    }
}


extension ViewController {

    func updateNumberStatus(number: String) {

        let error: CardNumberError? = self.cardValidator.check(number: number)

        var errorText: String? = nil
        switch error {
            case .longNumber:    errorText = "Number is to long"
            case .shortNumber:   errorText = "Number is to short"
            case .luhnFailed:    errorText = "Number has wrong digits (Luhn check failed)"
            case .wrongSymbols:  errorText = "Number has wrong symbols"
            case .wrongBin:      errorText = "Number has wrong bank identifier"
         
            case .none: break
        }
         
        self.numberErrorLabel?.text = errorText
        
        let closure: CardInfoCompletion = { [weak self] (cardInfo: CardInfo?, error: Error?) in
            DispatchQueue.main.async {
                self?.numberBrandLabel?.text = cardInfo?.brand
            }
        }
        self.cardValidator.getInfo(number: number, completion: closure)
    }
}
