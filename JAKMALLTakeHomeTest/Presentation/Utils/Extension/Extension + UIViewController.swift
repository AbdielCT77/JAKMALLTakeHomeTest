//
//  Extension + UIViewController.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 03/03/23.
//

import UIKit

var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        vSpinner?.removeFromSuperview()
        vSpinner = nil
    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(
            frame: CGRect(x: self.view.frame.size.width/2 - 75,
                          y: self.view.frame.size.height-100,
                          width: 150, height: 35
                         ))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = .systemFont(ofSize: 12)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 8.0,
                       delay: 0.1,
                       options: .curveEaseOut,
                       animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showDialog(title: String, desc: String) {
        // create the alert
        let alert = UIAlertController(
            title: title,
            message: desc,
            preferredStyle: UIAlertController.Style.alert
        )

        // add an action (button)
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default,
                handler: nil)
        )

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

