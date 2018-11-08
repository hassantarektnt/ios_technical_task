//
//  Product.swift
//  Technical Task
//
//  Created by MacBook Pro on 11/7/18.
//  Copyright © 2018 Hassan. All rights reserved.
//

import UIKit

class Product : NSObject , NSCoding{
    
    var name : String, productDescription : String
    var image : Image
    var price : Double
    
    override init() {
        name = ""
        productDescription = ""
        image = Image(link: "", height: "" ,width : "" , image : nil)
        price = 0.0
    }
    
    //function to parse data from api json
    func parseData(productData: AnyObject){
        
        self.name = (productData["name"] as? String)!
        self.productDescription = (productData["productDescription"] as? String)!
        
        if let imageData = productData["image"] as? Dictionary<String, AnyObject>  {
            
            self.image.link     = (imageData["link"] as? String)!
            self.image.height   = (imageData["height"] as? String)!
            self.image.width    = (imageData["width"] as? String)!
            
        }
        
        self.price = (productData["price"] as? Double)!
        
    }
    
    //download image from api and then store it
    func downloadImage(indexpathRow: Int, completion: @escaping (Bool, Int) -> Swift.Void)  {
        
        let imageURL = URL.init(string: image.link)
        URLSession.shared.dataTask(with: imageURL!, completionHandler: { (data, response, error) in
            if error == nil {
                self.image.image = UIImage.init(data: data!)
                completion(true, indexpathRow)
            }
        }).resume()
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: "name")
        aCoder.encode(productDescription, forKey: "productDescription")
        aCoder.encode(image.image, forKey: "image.image")
        aCoder.encode(image.link, forKey: "image.link")
        aCoder.encode(image.height, forKey: "image.height")
        aCoder.encode(image.width, forKey: "image.width")
        aCoder.encode(String(price), forKey: "price")

    }
    
    required init(coder aDecoder: NSCoder) {
        
        name = aDecoder.decodeObject(forKey: "name") as! String
        productDescription = aDecoder.decodeObject(forKey: "productDescription") as! String
        image = Image(link: "", height: "" ,width : "" , image : nil)
        image.image = (aDecoder.decodeObject(forKey: "image.image") as! UIImage)
        image.link = aDecoder.decodeObject(forKey: "image.link") as! String
        image.height = aDecoder.decodeObject(forKey: "image.height") as! String
        image.width = aDecoder.decodeObject(forKey: "image.width") as! String
        price = Double(aDecoder.decodeObject(forKey: "price" ) as! String )!
       
    }
    
}

struct Image {
    var link :String , height : String , width : String
    var image : UIImage?
}

