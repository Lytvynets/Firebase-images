//
//  ViewController.swift
//  TestApp
//
//  Created by Vlad Lytvynets on 11.09.2022.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ViewController: UIViewController {
    
    var signup: Bool = true {
        willSet {
            if newValue {
                self.titleLabel.text = "Реєстрація"
                self.nameTextField.isHidden = false
                self.enterButton.setTitle("Вхід", for: .normal)
            } else {
                self.titleLabel.text = "Вхід"
                self.nameTextField.isHidden = true
                self.enterButton.setTitle("Реєстрація", for: .normal)
            }
        }
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var eMailTextField: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.eMailTextField.delegate = self
        self.passwordTextFiled.delegate = self
        
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Помилка", message: "Заповніть поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func enterButtonAction(_ sender: UIButton) {
        self.signup = !signup
    }
}


// MARK: - UITextFielsDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let name = nameTextField.text!
        let password = passwordTextFiled.text!
        let email = eMailTextField.text!
        
        if signup {
            if !name.isEmpty && !password.isEmpty && !email.isEmpty {
                Auth.auth().createUser(withEmail: email, password: password) { userResult, error in
                    if error == nil {
                        if let userResult = userResult {
                            print(userResult.user.uid)
                            let ref = Database.database().reference().child("users")
                            ref.child(userResult.user.uid).onDisconnectUpdateChildValues(["name": name ,"email": email])
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }else{
                showAlert()
            }
        }else{
            if !password.isEmpty && !email.isEmpty {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    //  print("RESULT: \(String(describing: result?.user.uid))")
                    if error == nil {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }else{
                showAlert()
            }
        }
        return true
    }
}
