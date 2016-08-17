//
//  NetworkConnectionHandler.swift
//  MVVM-Demo
//
//  Created by Pushkraj-MacMini on 03/08/16.
//  Copyright © 2016 Pushkraj-MacMini. All rights reserved.
//

import UIKit

protocol NetworkConnectionHandlerDelegate {
	func networkConnectionFinishedSuccessfully(responseObject: AnyObject, tag: NSInteger)
	func networkConnectionDidFailWithError(errorMessage:String, tag: NSInteger)
	func networkRequestRejected(errorMessage:String, tag: NSInteger)
	func networkStatusInactive()
}

class NetworkConnectionHandler: NSObject {

	var networkDelegate: NetworkConnectionHandlerDelegate!

	func callAPIForInvoiceList(withTag: NSInteger) {
		let url:NSURL = NSURL(string: "http://test-servd.weboapps.com/en/api/v4/users/757/invoices/")!
		let session = NSURLSession.sharedSession()

		let request = NSMutableURLRequest(URL: url)
		request.HTTPMethod = "GET"
		request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
		request.setValue("Token ACs3erd52df94e59c1825593e5efe108b1ccc8", forHTTPHeaderField:"Authorization")

		let task = session.dataTaskWithRequest(request) {
			(
			let data, let response, let error) in

			guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
				print("error")
				return
			}
			do {
				if let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
					self.sendResponseToSender(jsonDictionary, tag: withTag)
				}
			}
			catch let error as NSError {
				print(error.localizedDescription)
				self.sendErrorToSender(response!, tag: withTag)
			}
		}
		task.resume()
	}

	func sendErrorToSender(response: AnyObject, tag: NSInteger) {
		networkDelegate?.networkConnectionDidFailWithError(response.valueForKey("message") as! String, tag: tag)
	}

	func sendResponseToSender(response: AnyObject, tag: NSInteger) {
		if (response.valueForKey("status") as! NSInteger == 200) {
			networkDelegate?.networkConnectionFinishedSuccessfully(response, tag: tag)
		}
		else {
			networkDelegate?.networkRequestRejected(response.valueForKey("message") as! String, tag: tag)
		}
	}
}
