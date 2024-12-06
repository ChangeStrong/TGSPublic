//
//  TGSheetView.swift
//  Yeast
//
//  Created by luo luo on 2024/3/20.
//

import UIKit

public class TGSheetItem{
    public  var name:String = ""
    public var iconImg:UIImage?
    public var isSelected:Bool = false
    public var extra:Any?
    
    public init(_ name: String, _ iconImg: UIImage? = nil) {
        self.name = name
        self.iconImg = iconImg
    }
}

public class TGSheetView: UIView,UITableViewDelegate,UITableViewDataSource {
    public var itemNameColor:UIColor = UIColor.black
    public var bottomViewMagin:UIEdgeInsets = UIEdgeInsets.init(top: 0, left: TGX(15), bottom: TGX(5), right: TGX(15))
    public var tableViewMagin:UIEdgeInsets = UIEdgeInsets.init(top: TGX(10), left: TGX(0), bottom: TGX(10), right: TGX(0))
    public var cellPadding:UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    public var itemHeight:CGFloat = TGX(50)
    public var cellIconHeight:CGFloat = TGX(30)
    
    public static let share:TGSheetView = TGSheetView();
    public var fartherWindow:UIWindow?
    public  var datas:[TGSheetItem] = []
    public typealias ClickBlock = (_ row: Int) -> Void
    public var clickBlock:ClickBlock?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        //        setupUI()
    }
    var isFistLoad = true;
    public  override func layoutSubviews() {
        super.layoutSubviews()
        if self.superview != nil && isFistLoad == true {
            isFistLoad = false;
            //初始化UI
            self.setupUI()
        }else{
            if self.superview != nil {
                //更新UI
            }
        }
    }
    // MARK: UI
    
    func setupUI() -> Void {
        self.bgBlackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
//       let _ = self.bgBlackView.addBlurView(style: .dark)
        
        var height = itemHeight * CGFloat(self.datas.count)
        if height < itemHeight {
            height = itemHeight
        }
        height += tableViewMagin.top + tableViewMagin.bottom
        let maxHeight = TGScreenHeight*2.0/3.0
        if height > maxHeight{
            //最高也只能屏幕的2/3
            height = maxHeight
        }
        
        var maxWidth:CGFloat = TGX(120)
        for item in self.datas {
            let font = TGFont(14)
            let width = item.name.widthForLabel(height: font.lineHeight, font: font) + TGX(30)
            if width > maxWidth {
                maxWidth = width;
            }
        }
        //计算cell需要的leftpadding 以最长的cell为计算
        let cellLeftPadding:CGFloat =  (TGWidth(self) - bottomViewMagin.left - bottomViewMagin.right - tableViewMagin.left - tableViewMagin.right - maxWidth)/2.0
        self.cellPadding.left = cellLeftPadding;
        
        self.bottomBgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-bottomViewMagin.bottom)
            make.left.equalTo(self).offset(bottomViewMagin.left)
            make.right.equalTo(self).offset(-bottomViewMagin.right)
            make.height.equalTo(height)
        }
        
//        self.bottomBgWhiteView.snp.makeConstraints { (make) in
//            make.edges.equalTo(self.bottomBgView)
//        }
//        self.bottomBgView.sendSubviewToBack(self.bottomBgWhiteView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.bottomBgView).offset(tableViewMagin.top)
            make.left.equalTo(self.bottomBgView).offset(tableViewMagin.left)
            make.right.equalTo(self.bottomBgView).offset(-tableViewMagin.right)
            make.bottom.equalTo(self.bottomBgView).offset(-tableViewMagin.bottom)
        }
        
        self.sendSubviewToBack(self.bgBlackView)
    }
    
   public func updateUI() -> Void {
       
       if self.isFistLoad == true {
           //还未初始化--无需更新ui
           return
       }
       
      var height = itemHeight * CGFloat(self.datas.count)
       if height < itemHeight {
           height = itemHeight
       }
       height += tableViewMagin.top + tableViewMagin.bottom
       let maxHeight = TGScreenHeight*2.0/3.0
       if height > maxHeight{
           //最高也只能屏幕的2/3
           height = maxHeight
       }
       
       var maxWidth:CGFloat = TGX(120)
       for item in self.datas {
           let font = TGFont(14)
           let width = item.name.widthForLabel(height: font.lineHeight, font: font) + TGX(30)
           if width > maxWidth {
               maxWidth = width;
           }
       }
       //计算cell需要的leftpadding 以最长的cell为计算
       let cellLeftPadding:CGFloat =  (TGWidth(self) - bottomViewMagin.left - bottomViewMagin.right - tableViewMagin.left - tableViewMagin.right - maxWidth)/2.0
       self.cellPadding.left = cellLeftPadding;
       
        self.bottomBgView.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-bottomViewMagin.bottom)
            make.left.equalTo(self).offset(bottomViewMagin.left)
            make.right.equalTo(self).offset(-bottomViewMagin.right)
            make.height.equalTo(height)
        }
       

       self.tableView.snp.remakeConstraints { (make) in
           make.top.equalTo(self.bottomBgView).offset(tableViewMagin.top)
           make.left.equalTo(self.bottomBgView).offset(tableViewMagin.left)
           make.right.equalTo(self.bottomBgView).offset(-tableViewMagin.right)
           make.bottom.equalTo(self.bottomBgView).offset(-tableViewMagin.bottom)
       }
       
       
       self.tableView.reloadData()
       self.layoutIfNeeded()
    }
    required init?(coder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    // MARK: 操作
    public var isShowing:Bool = false
    public class func show(_ datas:[TGSheetItem],_ block:@escaping ClickBlock){
        self.share.fartherWindow = TGGlobal.getScenesDelegate()?.window ?? UIWindow()
        if self.share.fartherWindow == nil {
            LLog(TAG: TAG(self), "father window is nil.!");
            return
        }
        self.share.datas = datas
        self.share.clickBlock = block
        self.share.isShowing = true;
        self.share.fartherWindow?.addSubview(self.share)
        self.share.fartherWindow?.bringSubviewToFront(self.share)
        self.share.frame = CGRect.init(x: 0, y: 0, width: self.share.fartherWindow!.width, height: self.share.fartherWindow!.height)
        self.share.updateUI()
    }
    
    public class func remove() {
        self.share.datas.removeAll()
        self.share.tableView.reloadData()
        if self.share.superview != nil {
            self.share.removeFromSuperview()
        }
        self.share.isShowing = false;
    }
    // MARK: 事件
    @objc func clickBgAction(){
        TGSheetView.remove()
    }
    
    // MARK: 懒加载
    public  lazy var bgBlackView: UIControl = {
        let view = UIControl()
        view.backgroundColor = UIColor.black
        view.alpha = 0.1
        view.addTarget(self, action: #selector(clickBgAction), for: UIControl.Event.touchUpInside)
        self.addSubview(view)
        return view
    }()
    public lazy var bottomBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = TGX(10)
        view.clipsToBounds = true
        self.addSubview(view)
        let view2 = view.addBlurView(style: .extraLight)
//        view2.alpha = 1.0
        return view
    }()
    
    /*
    lazy var bottomBgWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hexStr: "ececee")
        view.alpha = 0.3
        self.bottomBgView.addSubview(view)
        return view
    }()
    */
    public  lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.frame = CGRect.init(x: 0, y: 0, width: TGWidth(self.bottomBgView), height: TGHeight(self.bottomBgView))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear;
        tableView.backgroundColor = UIColor.clear
        tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.rowHeight = itemHeight
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.register(TGSheetCell.self, forCellReuseIdentifier: "TGSheetCell")
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: TGScreenWidth, height: TGBottomSafeHeight()))
        self.bottomBgView.addSubview(tableView)
        return tableView
    }()
    
    // MARK:UITableViewDelegate,UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TGSheetCell = tableView.dequeueReusableCell(withIdentifier: "TGSheetCell") as! TGSheetCell
        cell.nameLabel.textColor = self.itemNameColor
        let model = self.datas[indexPath.row]
        cell.cellPadding = self.cellPadding
        cell.cellIconHeight = self.cellIconHeight
        if indexPath.row == self.datas.count - 1 {
            cell.isLastCell = true
        }else{
            cell.isLastCell = false
        }
        cell.model = model
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TGSheetView.remove()
        self.clickBlock?(indexPath.row)
    }
    
    


}

public class TGSheetCell: UITableViewCell {
    var isLastCell:Bool = false
    var cellPadding:UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    var cellIconHeight:CGFloat = TGX(30)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = UIColor.clear
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model:TGSheetItem?{
        didSet{
            if model == nil {
                return
            }
            self.nameLabel.text = model?.name
            self.iconImgView.image = model?.iconImg
            self.updateUI()
        }
    }
    
    // MARK: UI
    func configUI() {
        self.iconImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(cellPadding.left)
            make.size.equalTo(CGSize.init(width: cellIconHeight, height: cellIconHeight))
        }
        
        self.nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.iconImgView)
            make.left.equalTo(self.iconImgView.snp.right).offset(TGX(15))
            make.right.lessThanOrEqualTo(self.contentView)
        }
        
       
        self.lineView.isHidden = isLastCell ? true : false
    }
    
    func updateUI() -> Void {
        if self.model?.isSelected == true {
            self.nameLabel.textColor = UIColor.blue
        }else{
            self.nameLabel.textColor = UIColor.black
        }
        if self.model!.iconImg == nil {
            //没有icon的情况
            self.iconImgView.snp.remakeConstraints { (make) in
                make.centerY.equalTo(self.contentView)
                make.left.equalTo(self.contentView).offset(cellPadding.left)
                make.size.equalTo(CGSize.init(width: 0, height: cellIconHeight))
            }
            self.nameLabel.snp.remakeConstraints { (make) in
//                make.center.equalTo(self.contentView)
                make.centerY.equalTo(self.contentView)
                make.left.equalTo(self.contentView).offset(TGX(15))
                make.right.equalTo(self.contentView).offset(TGX(-15))
            }
            
           
            
        }else{
            //有iocn
            self.iconImgView.snp.remakeConstraints { (make) in
                make.centerY.equalTo(self.contentView)
                make.left.equalTo(self.contentView).offset(cellPadding.left)
                make.size.equalTo(CGSize.init(width: cellIconHeight, height: cellIconHeight))
            }
            
            self.nameLabel.snp.remakeConstraints { (make) in
                make.centerY.equalTo(self.iconImgView)
                make.left.equalTo(self.iconImgView.snp.right).offset(TGX(10))
                make.right.lessThanOrEqualTo(self.contentView)
            }
          
        }
        self.lineView.isHidden = isLastCell ? true : false
    }
    
    
    // MARK: 懒加载
//    lazy var centerBgView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.clear
//        self.contentView.addSubview(view)
//        return view
//    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.black;
        view.font = TGFont(16)
        view.textAlignment = .center;
        view.text = "".localized
        view.numberOfLines = 0;
        self.contentView.addSubview(view)
        return view
    }()
    lazy var iconImgView: UIImageView = {
        let view = UIImageView()
        view.image = TGDefaultNoNetImg
        view.contentMode = .scaleAspectFill
        self.contentView.addSubview(view)
        view.clipsToBounds = true;
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = TGColorLineGraySystem
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.contentView).offset(0)
            make.left.equalTo(self.contentView).offset(15)
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(1);
        }
        return view
    }()
    
    // MARK: 事件
}
