//
//  Otp.swift
//  autenticador
//
//  Created by Luiz Antônio da Silva Júnior on 05/01/21.
//

import Foundation

class Otp: NSObject, NSCoding {
    
    let name: String
    let seed: String
    
    init(_ name: String, _ seed: String) {
        self.name = name
        self.seed = seed
    }
    
    func generate() -> Int32 {
        return 123456
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
