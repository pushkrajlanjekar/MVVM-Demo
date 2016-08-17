//
//  ViewController.swift
//  MVVM-Demo
//
//  Created by Pushkraj-MacMini on 03/08/16.
//  Copyright © 2016 Pushkraj-MacMini. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MyViewModelDelegate {

	private let myDataSource = MyDataSourceHandller()
	var myViewModel :MyViewModel!

	var arrayInvoicesModel :NSMutableArray = []
	@IBOutlet weak var tableViewInvoiceList: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		myViewModel = MyViewModel()
		myViewModel.viewModelDelegate = self
		myViewModel.getInvoiceList()
	}

	func sendResponse(responseObject: NSDictionary) {
		if myViewModel.getCountOfInvoices() > 0 {

			tableViewInvoiceList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

			myDataSource.myViewModelObj = myViewModel

			tableViewInvoiceList.delegate = myDataSource
			tableViewInvoiceList.dataSource = myDataSource
			dispatch_async(dispatch_get_main_queue()) {
				self.tableViewInvoiceList.reloadData()
			}
		}
		else {
			showAlertViewWithMessage("No records found")
		}
	}

	func sendError(errorMessage: String) {
		showAlertViewWithMessage(errorMessage)
	}

	func showAlertViewWithMessage(message: String) {
		let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
		self.presentViewController(alert, animated: true, completion: nil)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

