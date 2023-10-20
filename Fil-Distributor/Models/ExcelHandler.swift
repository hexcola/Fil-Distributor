//
//  ExcelHandler.swift
//  Fil-Distributor
//
//  Created by Neo on 2023/10/20.
//

import Foundation
import CoreXLSX

struct ExcelHandler {
    
    func parseExcel(filename: String) -> [Receiver]? {
        print(filename)
        
        guard let file = XLSXFile(filepath: filename) else {
            print("XLSX file at \(filename) is corrupted or does not exist")
            return nil
        }
    
        var receivers:[Receiver] = []
        
        for wbk in try! file.parseWorkbooks(){
            for (name, path) in try! file.parseWorksheetPathsAndNames(workbook: wbk) {
                if let worksheetName = name {
                    print("This worksheet has a name: \(worksheetName)")
                }
                
                let worksheet = try! file.parseWorksheet(at: path)
                if let sharedStr = try! file.parseSharedStrings() {
                    for row in worksheet.data?.rows ?? [] {
                        
                        if row.cells.count > 8 {
                            let toAddr = row.cells[4].stringValue(sharedStr)!
                            
                            if toAddr != "提现地址" {
                                let amount = Double(row.cells[7].value!)
                                receivers.append(Receiver(address: toAddr, amount: amount!))
//                                print("\(toAddr) ---> \(amount!)")
            //                    for c in row.cells {
            //                        if c.
            //                        print(c)
            //                    }
                            }
                        }

                    }
                }
            }
        }
        return receivers
    }
}
