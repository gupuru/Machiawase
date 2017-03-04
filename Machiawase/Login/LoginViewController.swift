//
//  LoginViewController.swift
//  Machiawase
//
//  Created by naru on 2017/03/04.
//  Copyright © 2017年 hazukit. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    private let ref = FIRDatabase.database().reference()
    
    struct Constants {
        static let SideMargin: CGFloat = 16.0
        static let NameFont: UIFont = UIFont.systemFont(ofSize: 28.0)
        static let ButtonFont: UIFont = UIFont.systemFont(ofSize: 18.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Login"
        
        self.view.addSubview(self.nameTextField)
        self.view.addSubview(self.createButton)
        
    }
    
    lazy var nameTextField: UITextField = {
        let frame: CGRect = CGRect(x: Constants.SideMargin, y: 120.0, width: (UIScreen.main.bounds.width - Constants.SideMargin*2), height: ceil(Constants.NameFont.lineHeight))
        let textField: UITextField = UITextField(frame: frame)
        textField.font = Constants.NameFont
        textField.textColor = UIColor(white: 0.2, alpha: 1.0)
        textField.textAlignment = .center
        textField.placeholder = "Max 5 characters"
        
        let lineFrame: CGRect = CGRect(x: 0.0, y: frame.height - 0.5, width: frame.width, height: 0.5)
        let line: UIView = UIView(frame: lineFrame)
        line.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        line.backgroundColor = UIColor.gray
        textField.addSubview(line)
        
        return textField
    }()
    
    lazy var createButton: UIButton = {
        let frame: CGRect = CGRect(x: 0.0, y: self.nameTextField.frame.maxY + 52.0, width: UIScreen.main.bounds.width, height: 44.0)
        let button: UIButton = UIButton(type: .system)
        button.frame = frame
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(self.onCreateButtonClicked(sender:)), for: .touchUpInside)
        button.titleLabel?.font = Constants.ButtonFont
        return button
    }()
    
    // MARK: Actions
    
    func onCreateButtonClicked(sender: UIButton) {
        
        // 未入力
        guard let name: String = self.nameTextField.text, name.characters.count > 0 else {
            let title: String = "Error"
            let message: String = "Please enter name."
            let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction( UIAlertAction(title: "OK", style: .default, handler: nil ))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        // 5文字よりも多い文字数
        guard name.characters.count <= 5 else {
            let title: String = "Error"
            let message: String = "Please enter name within 5 characters."
            let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction( UIAlertAction(title: "OK", style: .default, handler: nil ))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        // ログイン処理
        if let loginName: String = self.nameTextField.text  {
            let firebaseId = ref.child("users").childByAutoId().key
            
            setUserInfo(name: loginName, id: firebaseId)
            
            let post = ["name": loginName]
            
            let childUpdates = ["/users/\(firebaseId)": post]
            ref.updateChildValues(childUpdates)
            
            let cameraViewController: CameraViewController = CameraViewController()
            self.present(cameraViewController, animated: true, completion: nil)
        }
    
    }
    
    private func setUserInfo(name: String, id: String) {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(id, forKey: "firebaseId")
        userDefaults.set(name, forKey: "name")
    }
    
}
