//
//  ProductsListVC.swift
//  Technical Task
//
//  Created by MacBook Pro on 11/7/18.
//  Copyright © 2018 Hassan. All rights reserved.
//

import UIKit
import Alamofire

class ProductsListVC: UIViewController {
    
    var productsData: [Product] = []
    @IBOutlet weak var productsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productsTable.dataSource = self
        self.productsTable.delegate = self
        
        //if there is network available load data from api
        if Reachability.isConnectedToNetwork() {
            
            getProductsData()
            
        }else {
            
            if let data = UserDefaults.standard.data(forKey: "productsData") {
                self.productsData = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Product]
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //if there is no internet connection
        //will inform the user that there is no network connection
        
        if !Reachability.isConnectedToNetwork() {
            
            showToast(message: "No Internet !!")
            
        }
        
    }
    
    //get products data From api
    func getProductsData(){
        
        self.productsData = []
        
        var url = "https://limitless-forest-98976.herokuapp.com"
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        showToast(message: "Loading Data")
        
        Alamofire.request(url).responseJSON { response in
            
            let result = response.result.value
            
            if let jsonResult = result as? Dictionary<String, AnyObject> {
                
                if let productsData = jsonResult["data"] as? [AnyObject] {
                    
                    for productData in productsData {
                        
                        let product = Product()
                        product.parseData(productData: productData)
                        
                        self.productsData.append(product)
                        
                    }
                    //update view with new data
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.productsTable.reloadData()
                    })
                }
            }
        }
        
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 175, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //pass product data to product details View controller
        if let destination = segue.destination as? ProductDetailsVC {
            if let index = sender as? Int {
                destination.product = productsData[index]
            }
        }
        
    }
    
}

// MARK: - UITableViewDataSource
extension ProductsListVC: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)as? ProductCell {
            
            let product  = productsData[indexPath.row]
            
            cell.clearCellData()
            
            cell.title.text = product.name
            cell.price.text = "\(product.price)"
            
            if let image = product.image.image {
                
                cell.productImage.image = image
                
            } else {
                
                product.downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                    if state == true {
                        DispatchQueue.main.async {
                            //tableView.reloadRows(at: index, with: .automatic)
                            tableView.reloadData()
                            
                            //save table data here
                            let syncProductsData = NSKeyedArchiver.archivedData(withRootObject: self.productsData)
                            UserDefaults.standard.set(syncProductsData, forKey: "productsData")
                            UserDefaults.standard.synchronize()
                            
                        }
                    }
                })
                
            }
            
            return cell
            
        }else {
            
            return UITableViewCell()
            
        }
        
    }
    
}

// MARK: - UITableViewDelegate
extension ProductsListVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: indexPath.row)
    }
    
}


