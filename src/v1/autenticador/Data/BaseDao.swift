//
//  BaseDao.swift
//  autenticador
//
//  Created by Luiz Antônio da Silva Júnior on 12/01/21.
//

import Foundation

class BaseDao {
    
    let fileName: String
    
    init(fileName: String) {
        self.fileName =  fileName
    }
    
    func save(_ items: [Any]) throws {
        if let path = getPath() {
            let data = try NSKeyedArchiver.archivedData(withRootObject: items, requiringSecureCoding: false)
            try data.write(to: path)
        }
    }
    
    func get() throws -> [Any] {
        if let path = getPath() {
            let data = try Data(contentsOf: path)
            if let items = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Any] {
                return items
            }
        }
        return Array<Any>()
    }
    
    func delete(at index: Int) throws {
        var items = try get()
        items.remove(at: index)
        try save(items)
    }
    
    private func getPath() -> URL? {
        let directories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let directory = directories.first else {
            return nil
        }
        return directory.appendingPathComponent(fileName)
    }
}
