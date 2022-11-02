//
//  CoinService.swift
//  coinRank
//
//  Created by Nighthwtnk on 10/29/22.
//

import Foundation
import Alamofire

//class CoinService: BaseService {
//    func getCoins(completionHandler: @escaping (CoinModel) -> Void, errorHandler: @escaping (Error) -> Void) {
//        let url: String = ServiceURLs.apiPublic + "/v2/coins"
//        let params: [String: Any] = [:]
//
//        request(url, method: .get, parameters: params, completionHandler: { response in
//            let section = CoinModel(response)
//            print(section)
//            completionHandler(section)
//            print(response)
//        }) { error in
//            errorHandler(error)
//        }
//    }
//}
