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
    let digits: Int
    let period: Int
    
    init(_ name: String, _ seed: String) {
        self.name = name
        self.seed = seed
        self.digits = 6
        self.period = 30
    }
    
    init(_ name: String, _ seed: String, _ digits: Int, _ period: Int) {
        self.name = name
        self.seed = seed
        self.digits = digits
        self.period = period
    }
    
    //UIW6LVA2ABMN37S3KDHZFS7TM4RMIFIW
    func generate() -> String {
        if let data = base32DecodeToData(seed) {
            let totp = TOTP(secret: data, digits: self.digits, timeInterval: self.period, algorithm: .sha1)
            if let otp = totp?.generate(time: Date()) {
                return otp
            }
        }
        return "Erro"
    }
    
    func getProgress() -> Float {
        let timeNow = Date().timeIntervalSince1970 / Double(self.period)
        let progress = timeNow.truncatingRemainder(dividingBy: 1)
        return Float(progress)
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(seed, forKey: "seed")
        coder.encode(digits, forKey: "digits")
        coder.encode(period, forKey: "period")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as! String
        seed = coder.decodeObject(forKey: "seed") as! String
        digits = coder.decodeInteger(forKey: "digits")
        period = coder.decodeInteger(forKey: "period")
    }
}
