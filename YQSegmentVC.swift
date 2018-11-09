//
//  YQSegmentVC.swift
//
//
//  Created by 杨清 on 2018/11/8.
//  Copyright © 2018 soargift.com. All rights reserved.
//

import UIKit

class YQSegmentVC: YQBaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    var segmentView: YQSegmentView!
    var itemArr: Array<String> = ["未使用(---)","已过期(---)"]
    var scrollView: UIScrollView!
    var tableViewArr: Array<UITableView> = []
    var dataSrcArr: Array<Array<Any>> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let navigationBarHeight: CGFloat = self.navigationController==nil ? 0.0 : UIApplication.shared.statusBarFrame.size.height+self.navigationController!.navigationBar.frame.size.height;
        self.view.backgroundColor = RGB(239, 240, 241)
        let segmentView = YQSegmentView.segment(withFrame: CGRectMake(0, 0, kScreenWidth, 50), titles: itemArr, leftSpace: 50, middleSpace: 90, rightSpace: 50) { (idx: Int, item: UIButton?) in
            YQLog("!!!")
            self.scrollView?.contentOffset = CGPoint(x: CGFloat(idx)*kScreenWidth, y: 0)
        }!
        self.view.addSubview(segmentView)
        self.segmentView = segmentView
        let line = UIView(frame: CGRectMake(0, segmentView.frame.maxY, kScreenWidth, 0.5))
        line.backgroundColor = RGB(210, 210, 210)
        self.view.addSubview(line)
        
        let scrollView = UIScrollView(frame: CGRectMake(0, line.frame.maxY, kScreenWidth, kScreenHeight-navigationBarHeight-line.frame.maxY))
        scrollView.contentSize = CGSize(width: 2*kScreenWidth, height: 0)
        scrollView.isPagingEnabled = true
        //scrollView.isScrollEnabled = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        self.scrollView = scrollView
        
        for i in 0..<self.itemArr.count {
            let tb = UITableView(frame: CGRectMake(CGFloat(i)*kScreenWidth, 0, kScreenWidth, scrollView.frame.height))
            tb.tag = i
            tb.dataSource = self
            tb.delegate = self
            tb.rowHeight = 110
            tb.separatorStyle = .none;
            scrollView.addSubview(tb)
            tb.mj_header = MJRefreshNormalHeader(refreshingBlock: {
                YQLog("tableView num \(i) header refreshing")
                // TODO: for test {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                    tb.mj_header.endRefreshing()
                })
                // }
            })
            tb.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                // TODO: for test {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                    tb.mj_footer.endRefreshing()
                })
                // }
            })
            // TODO: for test {
            self.dataSrcArr.append(["\(i) --- 0","1","2"])
            // }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        //MARK: 设置navigationBar
        if self.navigationController != nil {
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationItem.title = "我的停车券"
            self.setTitleColor(RGB(30, 30, 30), font: UIFont.systemFont(ofSize: 18))
            self.navBgColor = UIColor.white
            self.navShadowColor = UIColor.clear
            self.navLeftImage = "common_back_icon"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let idx = Int(scrollView.contentOffset.x/scrollView.frame.width)
            self.segmentView.selectIndexUnCallBack(idx)
        }
    }
    
    // MARK: -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSrcArr[tableView.tag].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "PWParkCouponVC_cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellId)
        }
        let tag = tableView.tag
        cell?.textLabel?.text = self.dataSrcArr[tag][indexPath.row] as? String

        return cell!
    }
    
}
