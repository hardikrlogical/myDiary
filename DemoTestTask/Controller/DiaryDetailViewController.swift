//
//  DiaryDetailViewController.swift
//  DemoTestTask
//
//  Created by rlogical-dev-35 on 18/11/20.
//  Copyright © 2020 rlogical-dev-35. All rights reserved.
//

import UIKit
import RealmSwift

class DiaryDetailViewController: UIViewController {
    //MARK:-  Variable & Outlets Declaration
    var arrdata : Diary!
    let realm = try! Realm()
    @IBOutlet weak var txtDiaryTitle: UITextView!
    @IBOutlet weak var txtDiaryDetail: UITextView!
    @IBOutlet weak var nslcTitleheight: NSLayoutConstraint!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        intialLayoutSetup()
    }
    
    //MARK:-  Setup Intial Layout
    func intialLayoutSetup() {
        txtDiaryTitle.text =  arrdata.title
        txtDiaryDetail.text =  arrdata.content
        nslcTitleheight.constant = txtDiaryTitle.contentSize.height
    }
    
   //MARK:-  Save Button Tapped
    @IBAction func btnSaveTap(_ sender: Any) {
        if txtDiaryTitle.text.count == 0 {
            CustomAlertController.show("Please enter Title")
        } else if txtDiaryDetail.text.count == 0 {
            CustomAlertController.show("Please enter Content")
        } else {
            try! realm.write {
                arrdata.title = txtDiaryTitle.text!
                arrdata.content = txtDiaryDetail.text!
                realm.add(arrdata, update: .modified)
            }
            CustomAlertController.showtitleMessage(title: kProjectName, message: "Update diary successfully") { (true) in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(.whiteNavigation, Menu: .newback)
        navigationTileSetup()
    }
    
    func navigationTileSetup() {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font = UIFont(name: "SFUIText-Medium", size: 17)!
        label.textAlignment = .center
        label.textColor = .black
        label.text = arrdata.title
        self.navigationItem.titleView = label
    }
    
   
}
