//
//  FirstViewController.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 22/04/2017.
//
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        demo()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func demo() {
        let tasoClient = TasoClient()
        tasoClient.getTeam(id: 141460)?
            .then { response -> Void in
                log.debug("Status code: \(response.statusCode)")
                if let data = response.data, let message = String(data: data, encoding: .utf8) {
                    log.debug("Message: \(message)")
                }
            }.catch { error in
                log.error(error)
        }
    }
}

