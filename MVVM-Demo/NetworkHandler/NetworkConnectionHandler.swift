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

	func getRequestBodyWithRequestType(requestType: String, forURL: NSURL, parameters: NSDictionary) -> NSMutableURLRequest {

		let request = NSMutableURLRequest(URL: forURL)
		request.HTTPMethod = requestType
		//let dataParameters : NSData = NSKeyedArchiver.archivedDataWithRootObject(parameters)
		//request.HTTPBody = dataParameters
		request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
		request.setValue("Token XXXXXXX", forHTTPHeaderField:"Authorization")
		return request
	}

	func callWebServiceForSession(session: NSURLSession, request: NSMutableURLRequest, withTag: NSInteger) {
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

	func getInvoiceList(withTag: NSInteger) {

		let url:NSURL = NSURL(string: "http://test-servd.weboapps.com/en/api/v4/users/757/invoices/")!
		let session = NSURLSession.sharedSession()
		let request = self.getRequestBodyWithRequestType("GET", forURL: url, parameters: [:])
		callWebServiceForSession(session, request: request, withTag: withTag)
	}

	func getNotificationsList(withTag: NSInteger) {

		let url:NSURL = NSURL(string: "http://test-servd.weboapps.com/en/api/v4/users/757/notifications/")!
		let session = NSURLSession.sharedSession()
		let request = self.getRequestBodyWithRequestType("GET", forURL: url, parameters: [:])
		callWebServiceForSession(session, request: request, withTag: withTag)
	}
}
