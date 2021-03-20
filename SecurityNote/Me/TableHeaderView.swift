//
//  TableHeaderView.swift
//  iTalker
//
//  Created by HTC on 2019/4/24.
//  Copyright © 2019 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class TableHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        Bundle.main.loadNibNamed("TableHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    class func initView(title: String, subtitle: String, height: CGFloat) -> TableHeaderView {
        let hview = TableHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        hview.titleLbl.text = title
        hview.subtitleLbl.text = subtitle
        if UIDevice.current.userInterfaceIdiom == .pad {
            hview.titleLbl.font = UIFont.systemFont(ofSize: 17)
            hview.subtitleLbl.font = UIFont.systemFont(ofSize: 14)
        }
        return hview
    }

}

