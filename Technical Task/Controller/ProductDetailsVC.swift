//
//  ProductDetailsVC.swift
//  Technical Task
//
//  Created by MacBook Pro on 11/7/18.
//  Copyright © 2018 Hassan. All rights reserved.
//

import UIKit

class ProductDetailsVC: UIViewController {
    
    @IBOutlet weak var productTitle: UINavigationItem!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productImageHeight: NSLayoutConstraint!
    @IBOutlet weak var productImageWidth: NSLayoutConstraint!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    
    var product : Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let product = product else {
            return
        }
        
        //show product data
        productTitle.title = product.name
        productImageHeight.constant = CGFloat((product.image.height as NSString).doubleValue)
        productImageWidth.constant = CGFloat((product.image.width as NSString).doubleValue)
        productImage.image = product.image.image
        productPrice.text  = "\(product.price)"
        productDescription.text = product.productDescription
        
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true , completion: nil)
    }
    
}
