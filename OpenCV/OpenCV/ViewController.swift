//
//  ViewController.swift
//  OpenCV
//
//  Created by 田小椿 on 2018/3/30.
//  Copyright © 2018年 com.openCV.mirror. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var beautyOne: UIImageView!
    @IBOutlet weak var beautyTwo: UIImageView!
    @IBOutlet weak var beautyThree: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.gray
        initUI()
    }

   
    
    func initUI() {
        beautyTwo.image = OpenCV.cvtColorBGR2GRAY(UIImage(named: "beauty")!)
        beautyThree.image = OpenCV.cvtColorBGR2Mult(UIImage(named: "beauty")!)
        
    }


}

