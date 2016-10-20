//
//  UIConfiguration+Extension.swift
//  Monster
//
//  Created by Kevin Nguyen on 10/13/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // Hides keyboard when tapped outside
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func displayAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}
