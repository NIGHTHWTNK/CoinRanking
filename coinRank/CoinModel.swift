//
//  CoinModel.swift
//  coinRank
//
//  Created by Nighthwtnk on 10/29/22.
//

import Foundation
import SwiftyJSON

struct CoinModel {

    let status: String?
    let data: Data?

    init(_ json: JSON) {
        status = json["status"].stringValue
        data = Data(json["data"])
    }

}

struct Stats {

    let total: Int?
    let totalCoins: Int?
    let totalMarkets: Int?
    let totalExchanges: Int?
    let totalMarketCap: String?
    let total24hVolume: String?

    init(_ json: JSON) {
        total = json["total"].intValue
        totalCoins = json["totalCoins"].intValue
        totalMarkets = json["totalMarkets"].intValue
        totalExchanges = json["totalExchanges"].intValue
        totalMarketCap = json["totalMarketCap"].stringValue
        total24hVolume = json["total24hVolume"].stringValue
    }

}

struct Data {
    let coins: [Coins]?

    init(_ json: JSON) {
        coins = json["coins"].arrayValue.map { Coins($0) }
    }
}

struct Coins {

    let uuid: String?
    let symbol: String?
    let name: String?
    let color: String?
    let iconUrl: String?
    let marketCap: String?
    let price: String?
    let listedAt: Int?
    let tier: Int?
    let change: String?
    let rank: Int?
    let sparkline: [String]?
    let lowVolume: Bool?
    let coinrankingUrl: String?
    let Volume: String?
    let btcPrice: String?

    init(_ json: JSON) {
        uuid = json["uuid"].stringValue
        symbol = json["symbol"].stringValue
        name = json["name"].stringValue
        color = json["color"].stringValue
        iconUrl = json["iconUrl"].stringValue
        marketCap = json["marketCap"].stringValue
        price = json["price"].stringValue
        listedAt = json["listedAt"].intValue
        tier = json["tier"].intValue
        change = json["change"].stringValue
        rank = json["rank"].intValue
        sparkline = json["sparkline"].arrayValue.map { $0.stringValue }
        lowVolume = json["lowVolume"].boolValue
        coinrankingUrl = json["coinrankingUrl"].stringValue
        Volume = json["24hVolume"].stringValue
        btcPrice = json["btcPrice"].stringValue
    }
}
