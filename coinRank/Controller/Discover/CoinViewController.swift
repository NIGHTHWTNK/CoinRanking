//
//  CoinViewController.swift
//  coinRank
//
//  Created by Nighthwtnk on 10/29/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class CoinViewController: UIViewController {
    
    @IBOutlet weak var coinRankTableView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var coins: [Coins] = []
    var filter: [Coins] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        coinRankTableView.dataSource = self
        coinRankTableView.delegate = self
        loadData()
        SearchBar.delegate = self
        self.coinRankTableView.separatorStyle = .none

    }
    
    private func loadData() {
        getCoin()
    }

    func getCoin() {
        let url = ServiceURLs.apiPublic + "/v2/coins"
        Alamofire.request(url, method: .get).responseJSON { [self](respond) in
            switch respond.result
            {
            case.success(_):
                let result = try! JSON(data:respond.data!)
                let coinArray = result["data"]["coins"]
                coinArray.array?.forEach({ (coin) in
                    let get = Coins(JSON(coin.self))
                    self.coins.append(get)
                    self.coinRankTableView.reloadData()
                    
                })
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureRefreshControl() {
        coinRankTableView.refreshControl = UIRefreshControl()
        coinRankTableView.refreshControl?.addTarget(self, action:
            #selector(handleRefreshControl),
            for: .valueChanged)
    }

    @objc func handleRefreshControl() {
        DispatchQueue.main.async {
            self.coinRankTableView.refreshControl?.endRefreshing()
            self.loadData()
        }
    }
    
}

extension CoinViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.coins.count
        if filter.isEmpty != true {
            return filter.count
        } else {
            return coins.count
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell", for: indexPath) as! CoinCellTableViewCell
        if filter.isEmpty != true {
            cell.coin = filter[indexPath.row]
            return cell
        } else {
            cell.coin = coins[indexPath.row]
            return cell
        }
}
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section = \(indexPath.section)  Row = \(indexPath.row)")
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "CoinDetailVC") as! CoinDetailViewController
        if filter.isEmpty != true {
            detailVC.coin = filter[indexPath.row]
            self.present(detailVC, animated: true, completion: nil)
        } else {
            detailVC.coin = coins[indexPath.row]
            self.present(detailVC, animated: true, completion: nil)

        }
    }
}


extension CoinViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter = coins.filter({ filter -> Bool in
            return filter.name!.lowercased().contains(searchText.lowercased())
        })
        coinRankTableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        SearchBar.resignFirstResponder()
    }
}
