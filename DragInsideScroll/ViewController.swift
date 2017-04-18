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

    lazy var dragableView: DragableInsideScrollView = self.lazyInitDragableView()
    lazy var scrollView:CustomScrollView = self.lazyScrollView()

    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initUI()
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
    
    
    func lazyInitDragableView()-> DragableInsideScrollView {
        let v = DragableInsideScrollView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        v.backgroundColor = UIColor.red
        return v;
    }
    
    func lazyScrollView()->CustomScrollView{
        let scrollView = CustomScrollView(frame: self.view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentSize = CGSize(width: 1000, height: scrollView.frame.size.height)
        return scrollView
    }
    
    

    
    
    
}

