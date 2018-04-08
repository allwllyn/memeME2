//
//  MemeDetailController.swift
//  memeME2
//
//  Created by Andrew Llewellyn on 4/8/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailController: UIViewController
{
    var meme: Meme!
    
    @IBOutlet weak var detailView: UIImageView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        self.detailView.image = meme.memedImage
    }
}
