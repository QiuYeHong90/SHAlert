//
//  TipAlertViewController.swift
//  DemoLearn
//
//  Created by Ray on 2023/5/12.
//

import SHAlert
import UIKit

class TipAlertViewController: BaseSHAlertViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnClick(_ sender: Any) {
        
        
        
        let actionSheet = TestNormalViewController.init()
        
       
        self.present(actionSheet, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let animat = self.animationController(forPresented: self, presenting: self, source: self)
//        animat
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
