//
//  Otp.swift
//  autenticador
//
//  Created by Luiz Antônio da Silva Júnior on 05/01/21.
//

import Foundation

class Otp: NSObject, NSCoding {
    
    let name: String
    let value: Int32
    
    init(_ name: String, _ value: Int32) {
        self.name = name
        self.value = value
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(value, forKey: "value")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as! String
        value = coder.decodeInt32(forKey: "value")
    }
}
