//
//  ManualViewController.swift
//  autenticador
//
//  Created by Luiz Antônio da Silva Júnior on 06/01/21.
//
import UIKit
import Foundation

protocol AddOtpManuallyProtocol {
    func add(_ otp:Otp)
}

class ManualViewController : UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var seedTextField: UITextField!
    
    var delegate: AddOtpManuallyProtocol?
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func save(_ sender: UIButton) {
        if
            let name = nameTextField?.text,
            let seed = seedTextField?.text,
            let delegate = delegate {
                let otp = Otp(name, seed)
                delegate.add(otp)
                navigationController?.popViewController(animated: true)
        }
    }
}
