//
//  ViewController.swift
//  DragInsideScroll
//
//  Created by Kirill Pyulzyu on 17.04.17.
//  Copyright © 2017 kirill. All rights reserved.
//

import UIKit

class CustomScrollView:UIScrollView{

}

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    lazy var dragableView:UIView = self.lazyInitDragableView()
    lazy var scrollView:CustomScrollView = self.lazyScrollView()
    var originalPosition:CGPoint?
    var newPosition:CGPoint?
    var isDragHandledByScrollView:Bool?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initUI()
        addGestureRecognizer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initUI(){
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.dragableView)

        let v2 = UIView(frame: CGRect(x: 300, y: 400, width: 50, height: 50))
        v2.backgroundColor = UIColor.blue
        self.scrollView.addSubview(v2)
    }
    
    
    func lazyInitDragableView()->UIView{
        let v = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        v.backgroundColor = UIColor.red
        return v;
    }
    
    func lazyScrollView()->CustomScrollView{
        let scrollView = CustomScrollView(frame: self.view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentSize = CGSize(width: 1000, height: scrollView.frame.size.height)
        return scrollView
    }
    
    
    //MARK: drag
    
    
    func addGestureRecognizer(){
        let gestureRecognizer = UIPanGestureRecognizer.init(target: self,
                                                            action: #selector(onHandleGestureRecognizer(_:)))
        gestureRecognizer.minimumNumberOfTouches = 1;
        gestureRecognizer.delegate = self as UIGestureRecognizerDelegate;
        
        self.dragableView.addGestureRecognizer(gestureRecognizer)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
    
    func onHandleGestureRecognizer(_ sender:UIPanGestureRecognizer){
        switch sender.state{
        case .began:
            self.dragBegin(panGestureRecognizer: sender)
            
        case .changed:
            self.dragChanges(panGestureRecognizer: sender)
        
        case .ended:
            self.dragEnd(panGestureRecognizer: sender)
            
        default:
            self.dragEnd(panGestureRecognizer: sender)
        }
    }
    
    
    func dragBegin(panGestureRecognizer:UIPanGestureRecognizer){
        self.originalPosition = self.dragableView.center
        self.isDragHandledByScrollView = false;
    }
    
    
    func dragChanges(panGestureRecognizer:UIPanGestureRecognizer){
        let transition = panGestureRecognizer.translation(in: self.view)
        if self.originalPosition != nil{
            self.newPosition = CGPoint(x: self.originalPosition!.x+transition.x, y: self.originalPosition!.y+transition.y)
        
            let velocity = panGestureRecognizer.velocity(in: self.view)
            if abs(velocity.y/velocity.x)>1.0 && self.isDragHandledByScrollView == false{
                self.scrollView.isScrollEnabled = false
            }
            else
            {
                self.isDragHandledByScrollView = true
            }
            
            
            if (self.scrollView.isScrollEnabled == false){
                self.dragableView.center = self.newPosition!
            }
        }
    }
    
    func dragEnd(panGestureRecognizer:UIPanGestureRecognizer){
        self.originalPosition = nil
        self.newPosition = nil
        self.scrollView.isScrollEnabled = true
    }
    
    
    
}

