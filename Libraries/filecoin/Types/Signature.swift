//
//  Signature.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/21.
//

import Foundation

struct Signature:Codable {
    let type: Int
    let data: String
    
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case data = "Data"
    }
}
