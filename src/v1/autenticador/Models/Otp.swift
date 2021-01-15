//
//  Otp.swift
//  autenticador
//
//  Created by Luiz Antônio da Silva Júnior on 05/01/21.
//

import Foundation
import SwiftOTP

class Otp: NSObject, NSCoding {
    
    let name: String
    let seed: String
    
    init(_ name: String, _ seed: String) {
        self.name = name
        self.seed = seed
    }
    
    //UIW6LVA2ABMN37S3KDHZFS7TM4RMIFIW
    func generate() -> String {
        if let data = base32DecodeToData(seed) {
            let totp = TOTP(secret: data, digits: 6, timeInterval: 30, algorithm: .sha1)
            if let otp = totp?.generate(time: Date()) {
                return otp
            }
        }
        return "Erro"
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(seed, forKey: "seed")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as! String
        seed = coder.decodeObject(forKey: "seed") as! String
    }
}
