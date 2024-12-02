//
//  PhoneNumberInputView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 02.12.24.
//

import SwiftUI
import PhoneNumberKit

struct PhoneNumberInputView: View {
    @State private var phoneNumber: String = ""
    @Binding var isValid: Bool
    
    var body: some View {
        PhoneNumberTextFieldWrapper(phoneNumber: $phoneNumber, isValid: $isValid)
            .padding()
            .frame(height: 60)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isValid ? .green : .red, lineWidth: 1)
            )
    }
}

struct PhoneNumberTextFieldWrapper: UIViewRepresentable {
    @Binding var phoneNumber: String
    @Binding var isValid: Bool
    
    let phoneNumberKit = PhoneNumberUtility()
    
    func makeUIView(context: Context) -> PhoneNumberTextField {
        let textField = PhoneNumberTextField()
        textField.withFlag = true
        textField.withPrefix = true
        textField.withExamplePlaceholder = true
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: PhoneNumberTextField, context: Context) {
        uiView.text = phoneNumber
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PhoneNumberTextFieldWrapper
        
        init(_ parent: PhoneNumberTextFieldWrapper) {
            self.parent = parent
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            if let phoneNumber = textField.text {
                self.parent.phoneNumber = phoneNumber
                self.parent.isValid = self.parent.validatePhoneNumber(phoneNumber)
            }
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            if let phoneNumber = textField.text {
                self.parent.phoneNumber = phoneNumber
                self.parent.isValid = self.parent.validatePhoneNumber(phoneNumber)
            }
        }
    }
}

extension PhoneNumberTextFieldWrapper {
    func validatePhoneNumber(_ number: String) -> Bool {
        return phoneNumberKit.isValidPhoneNumber(number)
    }
}

#Preview {
    PhoneNumberInputView(isValid: .constant(true))
    PhoneNumberInputView(isValid: .constant(false))
}
