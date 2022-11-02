//
//  BaseViewDelegate.swift
//  coinRank
//
//  Created by Nighthwtnk on 10/29/22.
//

import Foundation

@objc protocol BaseViewDelegate: NSObjectProtocol {
    // require functions
    func startLoading()
    func finishLoading()
    
}
