//
//  TodayViewController.swift
//  Extension
//
//  Created by Maxim on 10/15/15.
//  Copyright © 2015 Maxim Bilan. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
	
	fileprivate var data: Array<NSDictionary> = Array()
	
	@IBOutlet weak var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if #available(iOSApplicationExtension 10.0, *) {
			extensionContext?.widgetLargestAvailableDisplayMode = .expanded
		}
		self.preferredContentSize.height = 200
		
		loadData()
    }
	
	// MARK: - NCWidgetProviding
	
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

		loadData()
		
        completionHandler(NCUpdateResult.newData)
    }
	
	func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
		return UIEdgeInsets.zero
	}
	
	@available(iOSApplicationExtension 10.0, *)
	func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
		if activeDisplayMode == .expanded {
			preferredContentSize = CGSize(width: maxSize.width, height: 300)
		}
		else if activeDisplayMode == .compact {
			preferredContentSize = maxSize
		}
	}
	
	// MARK: - Loading of data
	
	func loadData() {
		DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
			self.data.removeAll()
			
			if let path = Bundle.main.path(forResource: "Data", ofType: "plist") {
				if let array = NSArray(contentsOfFile: path) {
					for item in array {
						self.data.append(item as! NSDictionary)
					}
				}
			}
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	// MARK: - TableView Data Source
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellIdentifier", for: indexPath) 
		
		let item = data[indexPath.row]
		cell.textLabel?.text = item["title"] as? String
		cell.textLabel?.textColor = UIColor.white
		
		return cell
	}
	
}
