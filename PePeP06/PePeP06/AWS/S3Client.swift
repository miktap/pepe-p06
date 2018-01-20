//
//  S3Client.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 14/01/2018.
//

import Foundation
import AWSCore
import AWSS3

protocol S3ClientDelegate {
    /**
     * S3 client has downloaded Taso API key.
     *
     * - Parameter api_key: Taso API key
     */
    func apiKeyReceived(api_key: String)
}

class S3Client {
    // MARK: - Properties
    
    var delegate: S3ClientDelegate?
    
    
    // MARK: - Methods
    
    func getTasoAPIKey() {
        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        completionHandler = { (task, URL, data, error) -> Void in
            if let error = error {
                log.error(error.localizedDescription)
            }
            
            if let data = data, let message = String(data: data, encoding: .utf8) {
                log.debug("S3 client successfully downloaded Taso API key")
                self.delegate?.apiKeyReceived(api_key: message)
            }
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.downloadData(
            fromBucket: "pepep06",
            key: "taso_api_key.txt",
            expression: nil,
            completionHandler: completionHandler
        )
    }
}
