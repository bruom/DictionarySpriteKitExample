//
//  Matriz.swift
//  LabelsTest
//
//  Created by Bruno Omella Mainieri on 5/15/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import Foundation

class Matriz<T> {
    let columns: Int
    let rows: Int
    // #2
    var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        
        array = Array<T?>(count:rows * columns, repeatedValue: nil)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[(row * columns) + column]
        }
        set(newValue) {
            array[(row * columns) + column] = newValue
        }
    }
}
