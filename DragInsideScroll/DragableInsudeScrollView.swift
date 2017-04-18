//
// Created by Kirill Pyulzyu on 19.04.17.
// Copyright (c) 2017 kirill. All rights reserved.
//

import UIKit

class DragableInsideScrollView:UIView, UIGestureRecognizerDelegate{
    var originalPosition:CGPoint?
    var newPosition:CGPoint?
    var isDragHandledByScrollView:Bool?

    override init(frame:CGRect){
        super.init(frame:frame)
        self.addGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func addGestureRecognizer(){
        let gestureRecognizer = UIPanGestureRecognizer.init(target: self,
                action: #selector(onHandleGestureRecognizer(_:)))
        gestureRecognizer.minimumNumberOfTouches = 1;
        gestureRecognizer.delegate = self as UIGestureRecognizerDelegate;

        self.addGestureRecognizer(gestureRecognizer)
    }

    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool{
        if self.superview is UIScrollView{
            return true
        }
        else{
            return false
        }
        
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
        if self.superview is UIScrollView{
            self.originalPosition = self.center
            self.isDragHandledByScrollView = false
        }

    }


    func dragChanges(panGestureRecognizer:UIPanGestureRecognizer){
        let scrollView = self.superview as! UIScrollView
        let transition = panGestureRecognizer.translation(in: self.superview)
        if self.originalPosition != nil{
            self.newPosition = CGPoint(x: self.originalPosition!.x+transition.x, y: self.originalPosition!.y+transition.y)

            let velocity = panGestureRecognizer.velocity(in: self.superview)
            if abs(velocity.y/velocity.x)>1.0 && self.isDragHandledByScrollView == false{
                scrollView.isScrollEnabled = false
            }
            else
            {
                self.isDragHandledByScrollView = true
            }


            if (scrollView.isScrollEnabled == false){
                self.center = self.newPosition!
            }
        }
    }

    func dragEnd(panGestureRecognizer:UIPanGestureRecognizer){
        let scrollView = self.superview as! UIScrollView
        self.originalPosition = nil
        self.newPosition = nil
        scrollView.isScrollEnabled = true
    }

}
