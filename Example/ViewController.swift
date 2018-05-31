//
//  ViewController.swift
//  Example
//
//  Created by 刘朋朋 on 2018/5/31.
//  Copyright © 2018年 Lone. All rights reserved.
//

import UIKit
import Mnemonic

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mnemonic = Mnemonic(language: .english)
        
        print(mnemonic.toString())
        
        do {
            print(try mnemonic.toSeed())
        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
}

