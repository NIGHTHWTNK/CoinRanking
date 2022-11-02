//
//  CoinCellTableViewCell.swift
//  coinRank
//
//  Created by Nighthwtnk on 10/29/22.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class CoinCellTableViewCell: UITableViewCell {

    @IBOutlet weak var CoinImageView: UIImageView!
    @IBOutlet weak var CoinNameLabel: UILabel!
    @IBOutlet weak var CoinsymbolLabel: UILabel!
    @IBOutlet weak var CoinPriceLabel: UILabel!
    @IBOutlet weak var CoinChangeLabel: UILabel!
    @IBOutlet weak var ChangeImageView: UIImageView!
    
    var coin: Coins? {
        didSet {
            if let coin = coin {
                guard let url = URL(string: coin.iconUrl!) else {return}
                Alamofire.request(url).responseImage{(response) in
                    if let image = response.result.value{

                        DispatchQueue.main.async {
                            self.CoinImageView?.image = image
                        }
                    }
                }
                self.CoinNameLabel.text = coin.name
                self.CoinsymbolLabel.text = coin.symbol

                let coinPrice = Float(coin.price!)
                let priceCoin = String(format: "%.5f", coinPrice!)
                self.CoinPriceLabel.text = "$\(priceCoin)"
                self.CoinPriceLabel.textColor = UIColor.black

                
                let coinChange = Float(coin.change!)
                let changeCoin = String(format: "%.2f", coinChange!)
                self.CoinChangeLabel.text = "\(changeCoin)"
                if coinChange ?? 0 > 0 {
                    self.CoinChangeLabel.textColor = UIColor.green
                    ChangeImageView.image = UIImage(systemName: "arrow.up")
                    ChangeImageView.tintColor = UIColor.systemGreen


                } else {
                    self.CoinChangeLabel.textColor = UIColor.red
                    ChangeImageView.image = UIImage(systemName: "arrow.down")
                    ChangeImageView.tintColor = UIColor.systemRed
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
