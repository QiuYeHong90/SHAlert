//
//  ViewController.swift
//  SHAlert
//
//  Created by yorkYuanCH on 05/19/2023.
//  Copyright (c) 2023 yorkYuanCH. All rights reserved.
//

import SHAlert
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnClick() {
        let actionSheet = SHAlertController.init(title: "title", message: "Msg", preferredStyle: SHAlertController.Style.actionSheet)
        
        actionSheet.addAction(SHAlertAction.init(title: "OK", style: SHAlertAction.Style.default, handler: { item in
            print("OK ===")
        }))
        if let itemAc = SwitchViewAction.createView() {
            itemAc.action = {
                [weak self] a in
                print("a ===")
            }
            actionSheet.addAction(SHAlertAction.init(title: nil, style: SHAlertAction.Style.custom(actionView: itemAc)))
        }
        
        actionSheet.addAction(SHAlertAction.init(title: "OK2", style: SHAlertAction.Style.destructive, handler: { item in
            print("OK ===")
        }))
        
        
        actionSheet.addAction(SHAlertAction.init(title: "Cancel", style: SHAlertAction.Style.cancel, handler: { item in
            print("OK ===")
        }))
        self.present(actionSheet, animated: true)
    }

    
    @IBAction func btnClick1() {
        
        let actionSheet = TipAlertViewController.init(style: BaseSHAlertViewController.Style.actionSheet)
        
        self.present(actionSheet, animated: true)
    }
}

