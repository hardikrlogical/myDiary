//
//  MyDiaryListViewController.swift
//  DemoTestTask
//
//  Created by rlogical-dev-35 on 18/11/20.
//  Copyright © 2020 rlogical-dev-35. All rights reserved.
//

import UIKit
import MBProgressHUD
import RealmSwift
import RxSwift
class MyDiaryListViewController: UIViewController {
    
    //MARK:-  Variable & Outlets Declaration
    var HUD = MBProgressHUD()
    var arrDiarylist: Results<Diary>!
    private var dictData: [String: [Diary]] = [:]
    private var arrKeys = [String]()
    private(set) var disposeBag: DisposeBag = DisposeBag()

    let realm = try! Realm()
    @IBOutlet weak var tblDiaryList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setIntialLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        arrDiarylist = realm.objects(Diary.self)
        tblDiaryList.reloadData()
        super.viewWillAppear(true)
    }
    
    //MARK:-  Setup Intial Layout
    func setIntialLayout() {
        self.view.addSubview(HUD)
        let font = UIFont(name: "SFUIText-Medium", size: 17)!
        let attributes = [NSAttributedString.Key.font: font]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        let records = realm.objects(Diary.self)
        if records.count > 0 {
            self.arrDiarylist = records
            makeSectionedData()
        } else {
            ApiCallForGetDiaryList()
        }
    }
    
    
//    //MARK:- Api Call For Get Diary List
//    func ApiCallForGetDiaryList() {
//        HUD.show(animated: true)
//        if Reachability.isConnectedToNetwork() {
//            ApiManager.sharedManager.requsetForGet(urlQuery: KDiaryList) { (response, error, status) in
//                if error == nil, let dictResponse = response as? NSArray {
//                    self.HUD.hide(animated: true)
//                    self.saveDatainRealm(dataArray: dictResponse)
//                    self.tblDiaryList.reloadData()
//                } else {
//                    self.HUD.hide(animated: true)
//                    CustomAlertController.show(kError)
//                }
//            }
//        }else {
//            HUD.hide(animated: true)
//            CustomAlertController.showtitleMessage(title: kErrorNetwork, message: kNoInternet)
//        }
//    }
    
    
    
    //MARK:- Api Call For Get Diary List
    func ApiCallForGetDiaryList() {
        HUD.show(animated: true)
        if Reachability.isConnectedToNetwork() {
            ApiManager.sharedManager.requsetForGet(urlQuery: KDiaryList).subscribe({ [weak self] response in
                
                guard let self = self else {
                    return
                }
                switch response {
                case let .next((response, error, status)):
                    print(status)
                    
                    if error == nil, let dictResponse = response as? NSArray {
                        self.HUD.hide(animated: true)
                        self.saveDatainRealm(dataArray: dictResponse)
                        self.tblDiaryList.reloadData()
                    } else {
                        self.HUD.hide(animated: true)
                        CustomAlertController.show(kError)
                    }
                    break
                // data
                case let .error(error):
                    print(error)
                    self.HUD.hide(animated: true)
                    break
                // error
                case .completed:
                    break
                }
            }).disposed(by: disposeBag)
        }
        else {
            HUD.hide(animated: true)
            CustomAlertController.showtitleMessage(title: kErrorNetwork, message: kNoInternet)
        }
    }
    
    
    //MARK:-  Save Data in Realm
    func saveDatainRealm(dataArray:NSArray) {
        let realm = try! Realm()
        for data in dataArray {
            let record = Diary(
                id:NSUtility.getStringObjectForKey("id", From: data as? NSDictionary),
                title: NSUtility.getStringObjectForKey("title", From: data as? NSDictionary),
                content: NSUtility.getStringObjectForKey("content", From: data as? NSDictionary),
                date:NSUtility.getStringObjectForKey("date", From: data as? NSDictionary),
                isSync: "false"
            )
            
            if realm.isInWriteTransaction == true {
                realm.add(record)
            } else {
                try! realm.write {
                    realm.add(record)
                }
            }
        }
        let records = realm.objects(Diary.self)
        arrDiarylist = records
        makeSectionedData()
        tblDiaryList.reloadData()
    }
    
    private func makeSectionedData() {
        
        let formatter = DateFormatter()
        var dictData: [String: [Diary]] = [:]
        
        for obj in arrDiarylist {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let strDt = obj.date
            if let dt = formatter.date(from: strDt) {
                formatter.dateFormat = "MMM"
                var date = formatter.string(from: dt)
                
                if Calendar.current.isDate(dt, equalTo: Date(), toGranularity: .day) {
                    date = "TODAY"
                }
                else if Calendar.current.isDate(dt, equalTo: Calendar.current.date(byAdding: .day, value: -1, to: Date())!    , toGranularity: .day) {
                    date = "YESTERDAY"
                }
                if var arrMsgs = dictData[date], !arrMsgs.isEmpty {
                    arrMsgs.append(obj)
                    dictData[date] = arrMsgs
                } else {
                    dictData[date] = [obj]
                }
            }
        }
        
        self.dictData = dictData
        let keys = Array(dictData.keys)
        
        let sortedDic = keys.sorted { (aDic, bDic) -> Bool in
            formatter.dateFormat = "MMM"
            let dt = formatter.date(from: aDic)
            let dt1 = formatter.date(from: bDic)
            return dt! < dt1!
        }
        arrKeys = sortedDic
    }
}


extension MyDiaryListViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = arrKeys[section]
        return (dictData[key] ?? []).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dictData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryCell
        
        let key = arrKeys[indexPath.section]
        let arr = dictData[key] ?? []
        let arrData = arr[indexPath.row]
        
        cell.lblTitle.text = arrData.title.uppercased()
        cell.lblDiaryDescription.text = arrData.content
        
        let date = arrData.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        let getdate = dateFormatter.date(from:date)
        let convertedDate =  NSUtility.timeConvertFromDate(date: getdate ?? Date())
        cell.lblTime.text =  convertedDate
        
        cell.btnEdit.tag = indexPath.section
        cell.btnEdit.addTarget(self, action: #selector(self.editButtonTapped), for: .touchUpInside)
        cell.btnEdit.accessibilityLabel = "\(indexPath.row)"
        
        cell.btnDelete.tag = indexPath.section
        cell.btnDelete.accessibilityLabel = "\(indexPath.row)"
        cell.btnDelete.addTarget(self, action: #selector(self.deleteButtonTapped), for: .touchUpInside)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
    
    //MARK:-  Edit Button Tapped
    @objc func editButtonTapped(_ sender: UIButton) {
        let key = arrKeys[sender.tag]
        let arr = dictData[key] ?? []
        let indexrow = Int(sender.accessibilityLabel!)!
        let arrData = arr[indexrow]
        
        let detailVC = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "DiaryDetailViewController") as! DiaryDetailViewController
        detailVC.arrdata = arrData
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
     //MARK:-  Delete Button Tapped
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let key = arrKeys[sender.tag]
        let arr = dictData[key] ?? []
        let indexrow = Int(sender.accessibilityLabel!)!
        let arrData = arr[indexrow]
        if self.realm .isInWriteTransaction == true {
            self.realm.delete(arrData)
        } else {
            try! self.realm.write {
                self.realm.delete(arrData)
            }
        }
        
        
        arrDiarylist = realm.objects(Diary.self)
        makeSectionedData()
        tblDiaryList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        let obj = arrKeys[section]
        headerCell.lblTodayTomm.text = obj
        return headerCell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


class HeaderCell: UITableViewCell {
    @IBOutlet weak var lblTodayTomm: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class DiaryCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblDiaryDescription: UILabel!
    @IBOutlet weak var btnDelete: NSButton!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
