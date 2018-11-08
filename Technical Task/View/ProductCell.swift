//
//  ProductCell.swift
//  Technical Task
//
//  Created by MacBook Pro on 11/7/18.
//  Copyright © 2018 Hassan. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
  
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var productImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none    
  }
  
  //remove cell old data
  func clearCellData()  {
    title.text = nil
    price.text = nil
    productImage.image = nil
  }
  
}
