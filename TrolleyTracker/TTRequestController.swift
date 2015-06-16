import Foundation
import Alamofire

class MyRequestController {
		
	func sendRequest() {
		
		// Read Location (GET http://104.131.44.166/api/v1/trolly/1/location)

		// Create manager
		var manager = Manager.sharedInstance

		// Add Headers
		manager.session.configuration.HTTPAdditionalHeaders = [
			"Cache-Control":"no-cache",
			"Authorization":"Basic SU9TQ2xpZW50OklPU2lzdGhlYmVzdCEx",
			"Content-Type":"application/json",
		]
		
		// Fetch Request
		Alamofire.request(.GET, "http://104.131.44.166/api/v1/trolly/1/location", parameters: nil)
		.validate(statusCode: 200..<300)
		.responseJSON{(request, response, JSON, error) in
			if (error == nil)
			{
				println("HTTP Response Body: \(JSON)")
			}
			else
			{
				println("HTTP HTTP Request failed: \(error)")
			}
		}
		
	}
}
