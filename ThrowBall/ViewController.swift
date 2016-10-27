//
//  ViewController.swift
//  ThrowBall
//
//  Created by iOS Student on 10/26/16.
//  Copyright © 2016 Duong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    var ball = UIImageView()
    var animator = UIDynamicAnimator()
    var attachmentBehavior: UIAttachmentBehavior!
    var pushBehavior: UIPushBehavior!
    
    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var View2: UIView!
    @IBOutlet weak var View3: UIView!
    @IBOutlet weak var View4: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ball = UIImageView(frame: CGRect(x: 150, y: 330, width: 40, height: 40))
        
        self.ball.image = UIImage(named: "ball.png")
        self.view.addSubview(ball)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animator = UIDynamicAnimator(referenceView: self.view)
        
        let gravityBehavior = UIGravityBehavior(items: [self.ball])     //Mang doi tuong chiu anh huong cua gravity
        animator.addBehavior(gravityBehavior)
//Gravity: Thuoc tinh
        //  gravityBehavior.angle = 2       //Goc bay
        //  gravityBehavior.magnitude = 1   //toc do bay
        //  gravityBehavior.gravityDirection = CGVector(dx: -0.5, dy: 1)

        
//Va cham Collision
        let collisionBehavior = UICollisionBehavior(items: [self.ball, self.View1, self.View2, self.View3, self.View4])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true  //Set va cham voi man hinh hoac doi tuong khac
        animator.addBehavior(collisionBehavior)
        collisionBehavior.collisionDelegate = self
        
//Attachment: Gắn doi tuong voi 1 doi tuong khac (ở đây là con trỏ)
        attachmentBehavior = UIAttachmentBehavior(item: self.ball, attachedToAnchor: self.ball.center)
        //  attachmentBehavior.length = 50  //Khoang cach tam bong toi con tro
        //  attachmentBehavior.frequency = 10  //Quay nhanh hon
        //  attachmentBehavior.damping = 10     //Co the gian khi quay
        //  animator.addBehavior(attachmentBehavior)
        
//PUSH:
        pushBehavior = UIPushBehavior(items: [self.ball], mode: .continuous)
        animator.addBehavior(pushBehavior)
        
//UIdynamicItemBehavior: Chinh sua tong quat cac hanh vi cua doi tuong
        let ballProperty = UIDynamicItemBehavior(items: [self.ball])
        //     ballProperty.elasticity = 1 //Do nay cua bong
        //     ballProperty.allowsRotation = false //default = true cho phep bong xoay
        //     ballProperty.resistance = 100 // Luc chong lai khi quay
        //     ballProperty.friction = 0   // Luc ma sat voi doi tuong khac
        self.animator.addBehavior(ballProperty)
        
//Gesture Pan
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        self.view.addGestureRecognizer(panGesture)
        
// Tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePush(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }

//    //Bat dau cham thi goi ham nay
//    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
//        print(identifier)
//        print(p)
//    }
    
//    //bat dau bong nay len
//    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
//        print("ended: \(identifier)")
//    }
    
    func handlePan(gesture: UIPanGestureRecognizer) {
        attachmentBehavior.anchorPoint = gesture.location(in: self.view)
    }
    
    func handlePush(gesture: UITapGestureRecognizer){
        let p = gesture.location(in: self.view)
        let o = self.ball.center
        let distance = sqrtf(powf(Float(p.x) - Float(o.x), 2.0) + powf(Float(p.y) - Float(o.y), 2.0))
        let angle = atan2(p.y - o.y, p.x - o.x)
        pushBehavior.magnitude = CGFloat(distance/100.0)
        pushBehavior.angle = angle
    }
}

