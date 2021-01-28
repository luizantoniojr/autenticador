//
//  NewOtpViewController.swift
//  autenticador
//
//  Created by Luiz Antônio da Silva Júnior on 05/01/21.
//

import Foundation
import UIKit

protocol AddOtpProtocol {
    func add(_ otp:Otp)
}

class NewOtpViewController:  UIViewController, AddOtpManuallyProtocol, AddOtpAutomaticallyProtocol {
    
    var delegate: AddOtpProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "manual",
            let viewController = segue.destination as? ManualViewController {
                    viewController.delegate = self
            }
        
            if segue.identifier == "scanner",
            let viewController = segue.destination as? ScannerViewController {
                    viewController.delegate = self
            }
    }
    
    func add(_ otp: Otp) {
        if let delegate = delegate {
            delegate.add(otp)
            navigationController?.popViewController(animated: true)
        }
    }
}
