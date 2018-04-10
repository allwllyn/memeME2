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
    
    override func viewDidLoad()
    {
        super .viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target:self, action: #selector(startOver))
    }
    
    var myMemes = (UIApplication.shared.delegate as! AppDelegate).myMemes
    
    @objc func startOver()
    {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "baseController")
        
        self.present(controller!, animated: false, completion: nil)
    }
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
            return (UIApplication.shared.delegate as! AppDelegate).myMemes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailController") as! MemeDetailController
        
        detailController.meme = myMemes[(indexPath as NSIndexPath).row]
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for:indexPath)
        
        let meme = (UIApplication.shared.delegate as! AppDelegate).myMemes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        cell.imageView?.image = meme.originalImage
        
        return cell
    }
}
