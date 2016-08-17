//
//  MyViewModel.swift
//  MVVM-Demo
//
//  Created by Pushkraj-MacMini on 03/08/16.
//  Copyright © 2016 Pushkraj-MacMini. All rights reserved.
//

import UIKit

@objc protocol MyViewModelDelegate{
	func sendResponse(responseObject: NSDictionary)
	func sendError(errorMessage:String)
}

class MyViewModel: NSObject, NetworkConnectionHandlerDelegate {
	var myModel :MyModel!
	var arrayInvoicesModel :NSMutableArray = []
	var viewModelDelegate: MyViewModelDelegate?

	/**
	This method will call API for getting invoice list
	*/
	func getInvoiceList() {

		let networkDelegateHandler = NetworkConnectionHandler()
		networkDelegateHandler.networkDelegate = self
		networkDelegateHandler.callAPIForInvoiceList(0)
	}

	func networkConnectionFinishedSuccessfully(responseObject: AnyObject, tag: NSInteger) {
		
		arrayInvoicesModel = parseDataIntoModel(responseObject as! NSDictionary)
		viewModelDelegate?.sendResponse(responseObject as! NSDictionary)
	}

	func networkConnectionDidFailWithError(errorMessage:String, tag: NSInteger) {
		viewModelDelegate?.sendError(errorMessage)
	}

	func networkRequestRejected(errorMessage:String, tag: NSInteger) {
		viewModelDelegate?.sendError(errorMessage)
	}

	func networkStatusInactive() {
		print("No internet connection")
	}

	func parseDataIntoModel(responseDictionary :NSDictionary) -> NSMutableArray {
		let arrayInvoices :NSMutableArray = []

		let tempArray = responseDictionary.valueForKey("invoices") as! NSArray

		for index in 0 ..< tempArray.count {
			myModel = MyModel()
			myModel.serviceConsumerName = tempArray[index]["service_consumer_name"] as! String
			myModel.serviceProviderName = tempArray[index]["service_provider_name"] as! String
			arrayInvoices.addObject(myModel)
		}

		return arrayInvoices
	}

	func getInvoiceObjectForIndex(index : Int) -> MyModel {
		var myModelObject = MyModel()
		myModelObject = arrayInvoicesModel[index] as! MyModel
		return myModelObject
	}

	func getCountOfInvoices() -> Int {
		return arrayInvoicesModel.count
	}
}
