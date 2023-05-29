//
//  TestNormalViewController.swift
//  SHAlert_Example
//
//  Created by Ray on 2023/5/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class TestNormalViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        initCommmon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommmon()
    }
    @IBAction func dismissClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func initCommmon() {
        self.modalPresentationStyle = .fullScreen
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
