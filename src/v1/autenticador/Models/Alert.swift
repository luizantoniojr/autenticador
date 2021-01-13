//
//  Alert.swift
//  autenticador
//
//  Created by Luiz Antônio da Silva Júnior on 12/01/21.
//

import UIKit

import Foundation

class Alert {
    
    var viewController: UIViewController
    
    init(controller: UIViewController) {
        self.viewController = controller
    }
    
    func show(title: String = "Atenção", message: String) {
        self.show(title: title, message: message, actions: nil)
    }
    
    func show(title: String = "Atenção", message: String, actions: [UIAlertAction]?) {
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        } else {
            let btnOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(btnOk)
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
