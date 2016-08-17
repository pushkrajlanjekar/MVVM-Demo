//
//  MyDataSourceHandller.swift
//  MVVM-Demo
//
//  Created by Pushkraj-MacMini on 17/08/16.
//  Copyright © 2016 Pushkraj-MacMini. All rights reserved.
//

import UIKit

class MyDataSourceHandller: NSObject, UITableViewDelegate, UITableViewDataSource {
	var myViewModelObj :MyViewModel!
	var myModel :MyModel!

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return myViewModelObj.getCountOfInvoices()
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
		myModel = myViewModelObj.getInvoiceObjectForIndex(indexPath.row)
		cell.textLabel?.text = myModel.serviceProviderName

		return cell
	}
}
