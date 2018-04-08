//
//  MemeTableController.swift
//  memeME2
//
//  Created by Andrew Llewellyn on 4/8/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import Foundation
import UIKit

class MemeTableController: UITableViewController
{
    
    var myMemes = (UIApplication.shared.delegate as! AppDelegate).myMemes
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   
   {
                return (UIApplication.shared.delegate as! AppDelegate).myMemes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailController") as! MemeDetailController
        
        detailController.meme = myMemes[(indexPath as NSIndexPath).row]
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
