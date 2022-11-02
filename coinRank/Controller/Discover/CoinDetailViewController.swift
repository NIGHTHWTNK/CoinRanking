//
//  CoinDetailViewController.swift
//  coinRank
//
//  Created by Nighthwtnk on 11/2/22.
//

import UIKit
import Alamofire
import AlamofireImage

class CoinDetailViewController: UIViewController {

    //@IBOutlet weak var websiteBtn: UIButton!
    @IBOutlet weak var CoinImageView: UIImageView!
    @IBOutlet weak var CoinNameLabel: UILabel!
    @IBOutlet weak var CoinPriceLabel: UILabel!
    @IBOutlet weak var CoinMaketLabel: UILabel!
    
    var coin: Coins?

    @IBAction func uuidWebsiteBtn(_ sender: Any) {
        let url = NSURL(string: coin?.coinrankingUrl ?? "")
        UIApplication.shared.openURL(url! as URL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: (coin?.iconUrl!)!) else {return}
        Alamofire.request(url).responseImage{(response) in
            if let image = response.result.value{

                DispatchQueue.main.async {
                    self.CoinImageView?.image = image
                }
            }
        }
        
        self.CoinNameLabel.text = "\(coin?.name ?? "") (\(coin?.symbol ?? ""))"
        
        let coinPrice = Float((coin?.price)!)
        let priceCoin = String(format: "%.2f", coinPrice!)
        self.CoinPriceLabel.text = "$ \(priceCoin)"
        
        let coinMarket = Float((coin?.marketCap)!)
        let marketCoin = (coinMarket ?? 0)/10000000000
        let marketCap = String(format: "%.2f", marketCoin)
        self.CoinMaketLabel.text = "$ \(marketCap) Billion"
        
    }
}
