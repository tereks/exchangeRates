//
//  ContentBasedNVC.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import UIKit

open class ContentBasedNVC: UINavigationController {

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        guard let topController = topViewController else {
            return .lightContent
        }
        return topController.preferredStatusBarStyle
    }
}
