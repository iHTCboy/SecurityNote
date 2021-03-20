//
//  ITAdvancelDetailViewController.swift
//  iTalker
//
//  Created by HTC on 2019/4/24.
//  Copyright © 2019 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit


enum ITAdvancelType {
    case iHTCboyApp
}

class ITAdvancelDetailViewController: UIViewController {

    // MARK:- Lify Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var advancelType: ITAdvancelType = .iHTCboyApp
    var dataArray: Array<Dictionary<String, Any>> = Array()
    
    // MARK:- 懒加载
    lazy var tableView: UITableView = {
        var tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
        tableView.estimatedRowHeight = 55
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}


extension ITAdvancelDetailViewController
{
    func setupUI() {
        view.addSubview(tableView)
        let constraintViews = [
            "tableView": tableView
        ]
        let vFormat = "V:|-0-[tableView]-0-|"
        let hFormat = "H:|-0-[tableView]-0-|"
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: vFormat, options: [], metrics: [:], views: constraintViews)
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: hFormat, options: [], metrics: [:], views: constraintViews)
        view.addConstraints(vConstraints)
        view.addConstraints(hConstraints)
        view.layoutIfNeeded()
        
        switch advancelType {
        case .iHTCboyApp:
            dataArray = getJsonData(title: "iHTCboyApp")
            break
        }
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getJsonData(title: String) -> Array<Dictionary<String, Any>> {
        if let file = Bundle.main.url(forResource: title, withExtension: "json") {
            do {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? Array<Dictionary<String, Any>> {
                    var array: Array<Dictionary<String, Any>> = Array()
                    for obj in object {
                        array.append(["title": obj["issue_title"] as! String, "subtitle": obj["issue_subtitle"] ?? "", "data": obj["issue_list"] as Any])
                    }
                    return array
                } else {
                    print("JSON is invalid")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        print("no file")
        return Array()
    }

}

// MARK: Tableview Delegate
extension ITAdvancelDetailViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dict = dataArray[section]
        let array = dict["data"] as! Array<Dictionary<String, String>>
        return array.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return DeviceType.IS_IPAD ? 65 : 55
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dict = self.dataArray[section]
        let titile = (dict["title"] as! String)
        let subtitle = dict["subtitle"] as! String
        let view = TableHeaderView.initView(title: titile, subtitle: subtitle, height: 40)
        view.backgroundColor = .clear
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGroupedBackground
        }
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "ITAdvanceLearningViewCell")
        if (cell  == nil) {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "ITAdvanceLearningViewCell")
            cell?.accessoryType = .disclosureIndicator
            if #available(iOS 13.0, *) {
                cell?.backgroundColor = .secondarySystemGroupedBackground
            } else {
                cell?.backgroundColor = .white
            }
            cell?.selectedBackgroundView = UIView.init(frame: cell!.frame)
            cell?.selectedBackgroundView?.backgroundColor = kColorAppOrange.withAlphaComponent(0.7)
            cell?.textLabel?.font = UIFont.systemFont(ofSize: DeviceType.IS_IPAD ? 20:16.5)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: DeviceType.IS_IPAD ? 16:12.5)
            cell?.detailTextLabel?.sizeToFit()
            #if targetEnvironment(macCatalyst)
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 20)
            #endif
        }

        let dict = dataArray[indexPath.section]
        let array = dict["data"] as! Array<Dictionary<String, String>>
        let data = array[indexPath.row]
        cell!.textLabel?.text = data["title"]
        
        if let subtitle = data["author"] {
            cell?.detailTextLabel?.text = subtitle
        }

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let dict = dataArray[indexPath.section]
        let array = dict["data"] as! Array<Dictionary<String, String>>
        let data = array[indexPath.row]
        IAppleServiceUtil.openWebView(url: data["url"] ?? "", tintColor: .orange, vc: self)
    }
}
