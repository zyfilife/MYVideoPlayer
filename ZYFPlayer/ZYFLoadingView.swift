//
//  ZYFLoadingView.swift
//  ZYFPlayerExample
//
//  Created by 朱益锋 on 2017/1/25.
//  Copyright © 2017年 朱益锋. All rights reserved.
//

import UIKit

class ZYFLoadingView: UIView {
    
    var lineWidth:CGFloat!
    
    var lineColor: UIColor!
    
    var radius: CGFloat!
    
    var isAnimating = false
    
    var anglePer:CGFloat = 0.0 {
        didSet {
            self.ringLayer.strokeEnd = self.anglePer
        }
    }
    
    var displayerLink: CADisplayLink? = nil {
        willSet {
            if self.displayerLink != nil {
                self.displayerLink?.invalidate()
                self.displayerLink = nil
            }
        }
    }
    
    lazy var ringLayer: CAShapeLayer = {
        let path = UIBezierPath(arcCenter: CGPoint(x: (self.radius+self.lineWidth), y: (self.radius+self.lineWidth)), radius: self.radius, startAngle: self.toAngle(angle: 120), endAngle: self.toAngle(angle: 120) + self.toAngle(angle: 300), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.contentsScale = UIScreen.main.scale
        shapeLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: (self.radius+self.lineWidth)*2, height: (self.radius+self.lineWidth)*2))
        shapeLayer.lineJoin = kCALineJoinBevel
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = self.lineWidth
        shapeLayer.strokeColor = self.lineColor.cgColor
        shapeLayer.lineCap = kCALineCapRound
        return shapeLayer
    }()
    
    lazy var backgroundLayer: CAShapeLayer = {
        let path = UIBezierPath(arcCenter: CGPoint(x: (self.radius+self.lineWidth), y: (self.radius+self.lineWidth)), radius: self.radius, startAngle: self.toAngle(angle: 0), endAngle: self.toAngle(angle: 360), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.contentsScale = UIScreen.main.scale
        shapeLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: (self.radius+self.lineWidth)*2, height: (self.radius+self.lineWidth)*2))
        shapeLayer.lineJoin = kCALineJoinBevel
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = self.lineWidth
        shapeLayer.strokeColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = 1
        return shapeLayer
    }()
    
    init(frame: CGRect = CGRect.zero, radius: CGFloat = 16, lineWidth: CGFloat=4, lineColor: UIColor=UIColor.white) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.radius = radius
        self.layer.addSublayer(self.backgroundLayer)
        self.layer.addSublayer(self.ringLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self.classForCoder)已销毁")
    }
    
    func startAnimating() {
        if self.isAnimating {
            self.stopAnimating()
            self.layer.removeAllAnimations()
        }
        
        self.isAnimating = true
        self.anglePer = 0.0
        self.alpha = 1.0
        self.displayerLink = CADisplayLink(target: self, selector: #selector(ZYFLoadingView.drawPathAnimation(_:)))
        self.displayerLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    @objc fileprivate func drawPathAnimation(_ sender: CADisplayLink) {
        self.anglePer += 0.03
        if self.anglePer >= 1 {
            self.anglePer = 1
            self.displayerLink = nil
            self.startAnimationWithRotation()
        }
    }
    
    fileprivate func startAnimationWithRotation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 0.23
        animation.toValue = M_PI/2
        animation.fillMode = kCAFillModeForwards
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        self.layer.add(animation, forKey: "keyFrameAnimation")
    }
    
    func stopAnimating() {
        self.isAnimating = false
        self.displayerLink = nil
        UIView.animate(withDuration: 0.3, animations: { 
            self.alpha = 0.0
        }) { (done) in
            self.anglePer = 0
            self.layer.removeAllAnimations()
        }
    }
    
    override func draw(_ rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext() else {
//            return
//        }
//        context.setLineWidth(self.lineWidth)
//        context.setStrokeColor(self.lineColor.cgColor)
//        context.setLineCap(CGLineCap.round)
//        context.setLineJoin(CGLineJoin.bevel)
//        context.addArc(center: CGPoint(x: (self.radius+self.lineWidth), y: (self.radius+self.lineWidth)), radius: self.radius, startAngle: self.toAngle(angle: 120), endAngle: self.toAngle(angle: 120)+self.toAngle(angle: 310*self.anglePer), clockwise: false)
//        context.strokePath()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: (self.radius+self.lineWidth)*2, height: (self.radius+self.lineWidth)*2)
    }
    
    fileprivate func toAngle(angle: CGFloat) -> CGFloat {
        return CGFloat(M_PI)*2/360*angle
    }

}
