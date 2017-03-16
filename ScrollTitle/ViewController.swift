//
//  ViewController.swift
//  ScrollTitle
//
//  Created by Vasiliy Kozlov on 13/03/2017.
//  Copyright © 2017 Vasiliy Kozlov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fakeNavBar: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var tableHeader: HeaderView?
    
    var offsetLabelHeader: CGFloat
    var distanceLabelHeader: CGFloat

    
    required init?(coder aDecoder: NSCoder) {

        self.distanceLabelHeader = 0
        self.offsetLabelHeader = 0
        
        super.init(coder: aDecoder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = "It's a title"
        let desc = "A long, long time ago in a galaxy far away Naboo was under an attack and I thought me and Qui-Gon Jinn could talk the federation into maybe cutting them a little slack . . ."
        self.headerTitleLabel.text = title
        
        self.tableHeader = HeaderView()
        self.tableHeader?.setTitle(title: title, desc: desc)
        self.tableView.tableHeaderView = self.tableHeader
        
        self.tableView.delegate = nil
        self.tableView.contentInset = UIEdgeInsetsMake(self.headerImageView.frame.size.height, 0, 0, 0)
        self.tableView.delegate = self
        
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sizeHeaderToFit(tableView: self.tableView)
        
        self.distanceLabelHeader = self.fakeNavBar.frame.size.height - self.headerTitleLabel.frame.size.height + 6.0
        
        self.offsetLabelHeader = self.headerImageView.frame.size.height - self.fakeNavBar.frame.size.height
    }

    func sizeHeaderToFit(tableView: UITableView) {
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            tableView.tableHeaderView = headerView
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + self.headerImageView.bounds.size.height
        
        var headerTransform = CATransform3DIdentity
        
        if (Int(offset) < 0) {
            let height = self.headerImageView.bounds.size.height
            let headerScaleFactor = -offset / height
            let headerSizeVariation = ((height * (1.0 + headerScaleFactor)) - height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizeVariation, 0);
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
            
            self.headerImageView.layer.transform = headerTransform
        }
        else {
            let labelTransform = CATransform3DMakeTranslation(0, fmax(-self.distanceLabelHeader, self.offsetLabelHeader - offset), 0)
            self.headerTitleLabel.layer.transform = labelTransform
            
            let fullyVisibleoffset = self.headerImageView.bounds.size.height - self.fakeNavBar.frame.size.height + (self.tableHeader?.titleLabel.frame.origin.y)!
            let fullyTransparentOffset = self.headerImageView.bounds.size.height - self.fakeNavBar.frame.size.height
            let alpha = fmin(1.0, (offset/fullyVisibleoffset - fullyTransparentOffset/fullyVisibleoffset) * 10.0)
            self.fakeNavBar.backgroundColor = UIColor.init(red: 0.008, green: 0.118, blue: 0.282, alpha: alpha)
        }
        
        self.headerImageView.layer.transform = headerTransform
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        
        cell.textLabel?.text = "Row \(indexPath.row)"
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.stoppedScrolling(scrollView: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate) {
            self.stoppedScrolling(scrollView: scrollView)
        }
    }
    
    func stoppedScrolling(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + self.headerImageView.bounds.size.height
        let point = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        let distance = self.headerImageView.frame.size.height
    
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
            if (point.y > 0 && offset < distance) {
                scrollView.contentOffset  = CGPoint.init(x: 0, y: -scrollView.contentInset.top)
            }
            else if (point.y < 0 && offset < distance) {
                let y = -(self.tableHeader?.titleLabel.frame.origin.y)!
                scrollView.contentOffset = CGPoint.init(x:0, y:y)
            }

        }, completion: nil)
    }
}



