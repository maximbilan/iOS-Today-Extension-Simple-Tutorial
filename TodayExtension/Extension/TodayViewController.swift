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
	
	private var data: Array<NSDictionary> = Array()
	
	@IBOutlet weak var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		loadData()
		
		self.preferredContentSize.height = 200
    }
	
	// MARK: - NCWidgetProviding
	
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

		loadData()
		
        completionHandler(NCUpdateResult.NewData)
    }
	
	func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
		return UIEdgeInsetsZero
	}
	
	// MARK: - Loading of data
	
	func loadData() {
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			
			self.data.removeAll()
			
			if let path = NSBundle.mainBundle().pathForResource("Data", ofType: "plist") {
				if let array = NSArray(contentsOfFile: path) {
					for item in array {
						self.data.append(item as! NSDictionary)
					}
				}
			}
			
			dispatch_async(dispatch_get_main_queue()) {
				self.tableView.reloadData()
			}
		}
	}
	
	// MARK: - TableView Data Source
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCellIdentifier", forIndexPath: indexPath) 
		
		let item = data[indexPath.row]
		cell.textLabel?.text = item["title"] as? String
		cell.textLabel?.textColor = UIColor.whiteColor()
		
		return cell
	}
	
}
