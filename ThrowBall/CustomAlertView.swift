//
//  CustomAlertView.swift
//  ThrowBall
//
//  Created by iOS Student on 11/1/16.
//  Copyright © 2016 Duong. All rights reserved.
//

import UIKit

class CustomAlertView: UIViewController {

    var alertView: UIView!
    var animator : UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var snapBehavior: UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: self.view)
        createAlert()
    }

    func createAlert() {
        let alertWidth: CGFloat = 250
        let alertHeight: CGFloat = 150
        let buttonWidth: CGFloat = 40
        let alertViewFrame = CGRect(x: 0, y: 0, width: alertWidth, height: alertHeight)
        alertView = UIView(frame: alertViewFrame)
        alertView.backgroundColor = UIColor.black
        alertView.alpha = 0
        
        //Chinh giao dien alertView
        alertView.layer.cornerRadius = 10
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOffset = CGSize(width: 0, height: 5)
        alertView.layer.shadowOpacity = 0.3
        alertView.layer.shadowRadius = 10.0
        
        //Tao nut dau X
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Dismiss.png"), for: .normal)
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: alertWidth/2 - buttonWidth/2, y: -buttonWidth/2, width: buttonWidth, height: buttonWidth)
        button.addTarget(self, action: #selector(dismisAlert), for: .touchUpInside)
        
        let buttonOK = UIButton(type: .custom)
        buttonOK.setImage(UIImage(named: "OKPhoto.jpg"), for: .normal)
        buttonOK.backgroundColor = UIColor.clear
        buttonOK.layer.cornerRadius = 20
        buttonOK.clipsToBounds = true
        buttonOK.frame = CGRect(x: alertWidth/4 - buttonWidth/2, y: alertHeight-buttonWidth/2, width: buttonWidth, height: buttonWidth)
        buttonOK.addTarget(self, action: #selector(OK), for: .touchUpInside)
        
        let buttonCancel = UIButton(type: .custom)
        buttonCancel.setImage(UIImage(named: "button_clear"), for: .normal)
        buttonCancel.backgroundColor = UIColor.clear
        buttonCancel.frame = CGRect(x: 3 * alertWidth/4 - buttonWidth/2, y: alertHeight-buttonWidth/2, width: buttonWidth, height: buttonWidth)
        buttonCancel.addTarget(self, action: #selector(dismisAlert), for: .touchUpInside)
        
        let rectLabel = CGRect(x: 0, y: button.frame.origin.y + button.frame.height, width: alertWidth, height: alertHeight - buttonWidth/2)
        let label = UILabel(frame: rectLabel)
        label.numberOfLines = 0 //Tu dong xuong dong
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Ahihi..."
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        alertView.addSubview(label)
        alertView.addSubview(button)
        alertView.addSubview(buttonOK)
        alertView.addSubview(buttonCancel)
        view.addSubview(alertView)
        
    }
    func OK(){
        print ("OK")
    }
    
    
    func dismisAlert(){
        animator.removeAllBehaviors()
        UIView.animate(withDuration: 0.5, animations: {
                self.alertView.alpha = 0.0
            }, completion: {    (value: Bool) in
                            self.alertView.removeFromSuperview()
                            self.alertView = nil
                            })
    }
    
    @IBAction func showAlertView(sender: UIButton) {
        showAlert()
    }
    
    func showAlert() {
        if (alertView == nil) {
            createAlert()
        }
        
        //Tao du kien pan
        createGestureRecognizer()
        
        alertView.alpha = 1.0
        let snapBehavior = UISnapBehavior(item: alertView, snapTo: view.center)
        snapBehavior.damping = 10
        animator.addBehavior(snapBehavior)
    }
    
    func createGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    func handlePan(_ sender: UIPanGestureRecognizer){
        if (alertView != nil) {
            let panLocationInView = sender.location(in: self.view)
            let panLocationInAlertView = sender.location(in: self.alertView)
            
            if sender.state == UIGestureRecognizerState.began {
                animator.removeAllBehaviors()
                
                let offset = UIOffsetMake(panLocationInAlertView.x - alertView.bounds.midX, panLocationInAlertView.y - alertView.bounds.midY);
                attachmentBehavior = UIAttachmentBehavior(item: alertView, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
                
                animator.addBehavior(attachmentBehavior)
            }
            else if sender.state == UIGestureRecognizerState.changed {
                attachmentBehavior.anchorPoint = panLocationInView
            }
            else if sender.state == UIGestureRecognizerState.ended {
                animator.removeAllBehaviors()
                snapBehavior = UISnapBehavior(item: alertView, snapTo: view.center)
                animator.addBehavior(snapBehavior)
                
                if sender.translation(in: view).y > 100 {
                    dismisAlert()
                }
            }

        }
    }
}
