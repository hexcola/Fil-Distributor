//
//  CID.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/21.
//

import Foundation
import Blake2

struct CID: Codable {
    // example: bafy2bzacedadr3vsnghn7svbtwlpaognjshykkdn4ugkwerxij3b667mz7wvu
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case value = "/"
    }
    
    func bytes() -> [UInt8]? {
        if value.count != 62 {
            return nil
        }
        
        do {
            // Need to remove the first letter
            var temp = value
            temp.removeFirst()
            let data = try Base32.decode(string: temp.uppercased())
            return [UInt8](data)
        } catch {
            print(error)
            return nil
        }
    }
}
