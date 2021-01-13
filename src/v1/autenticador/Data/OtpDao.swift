//
//  OtpDao.swift
//  autenticador
//
//  Created by Luiz Antônio da Silva Júnior on 12/01/21.
//

import Foundation

class OtpDao {
    
    let dao = BaseDao(fileName: String(describing: Otp.self))
    
    func save(_ itens: [Otp]) throws {
        try dao.save(itens)
    }
    
    func get() throws -> [Otp] {
        return try dao.get() as! [Otp];
    }
    
    func delete(at index: Int) throws {
        try dao.delete(at: index)
    }
}
