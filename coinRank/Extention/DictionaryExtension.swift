//
//  DictionaryExtension.swift
//  coinRank
//
//  Created by Nighthwtnk on 10/30/22.
//

import Foundation

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

