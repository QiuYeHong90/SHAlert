//
//  SwitchViewAction.swift
//  DemoLearn
//
//  Created by Ray on 2023/5/11.
//
import SHAlert
import UIKit

class SwitchViewAction: UIView,SHActionProtocol {
    var action: ((SwitchViewAction) -> Void)?
    static func createView() -> SwitchViewAction? {
        return Bundle.main.loadNibNamed("SwitchViewAction", owner: nil)?.first as? SwitchViewAction
    }
    
    @IBOutlet weak var switchBtn: UISwitch!
    

    
    @IBAction func switchAction(_ sender: Any) {
        action?(self)
        
    }
    
}
