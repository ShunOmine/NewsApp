//
//  FirstViewController.swift
//  SummerCampNewsApp
//
//  Created by 大嶺舜 on 2019/08/04.
//  Copyright © 2019 大嶺舜. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WebKit

class FirstViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate, XMLParserDelegate  {
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var backPage: UIBarButtonItem!
    @IBOutlet weak var nextPage: UIBarButtonItem!
    @IBOutlet weak var refreshPage: UIBarButtonItem!
    
    var tableView: UITableView = UITableView()
    var itemInfo: IndicatorInfo = "Yahoo国内"
    // articles 変数
    var articles = NSMutableSet()
    
    // XMLファイルに解析をかけた情報
    var elements = NSMutableDictionary()
    // XMLファイルのタグ情報
    var element = String()
    // XMLファイルのタイトル情報
    var titleString = NSMutableString()
    // XMLファイルのリンク情報
    var linkString = NSMutableString()
    
    var refreshControl: UIRefreshControl!
    
    var totalBox = [NSMutableDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toolBar.isHidden = false
        self.webView.isHidden = true
        
        webView.navigationDelegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 45, height: self.view.frame.height - 150)
        
        self.view.addSubview(tableView)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        parseURL()
    }

    // XMLParsernのインスタンスを作成
    var parser = XMLParser()
    func parseURL() {
        // XML を解析する
        // Yahoo 国内
        let url: String = "https://news.yahoo.co.jp/pickup/domestic/rss.xml"
        let urlToSend: URL = URL(string: url)!
        parser = XMLParser(contentsOf: urlToSend)!
        // articles を空にする
        articles = []
        parser.delegate = self
        // 解析開始
        parser.parse()
        // TableViewのリロード
        tableView.reloadData()
    }
    
    // タグを見つけた時
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        element = elementName
        
        // タグにitemがあるとき
        if element == "item" {
            
            // 初期化
            elements = [:]
            titleString = ""
            linkString = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element == "title" {
            // stringにタイトルが入っているのでappend
            titleString.append(string)
        } else if element == "link" {
            linkString.append(string)
        }
    }
    
    // 終了タグを見つけた時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // アイテムという要素の中にあるなら、
        if elementName == "item" {
            // titleString,linkStringの中身が空でないなら
            if titleString != "" {
                // elementsに"title"、"Link"というキー値を付与しながらtitleString,linkStringをセット
                elements.setObject(titleString, forKey: "title" as NSCopying)
            }
            if linkString != "" {
                elements.setObject(linkString, forKey: "link" as NSCopying)
            }
            
            // articlesの中にelementsを入れる
            articles.add(elements)
            totalBox.append(elements)
        }
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = #colorLiteral(red: 0.6200760007, green: 0.9531318545, blue: 1, alpha: 1)
        
        // 記事タイトルテキスト
        cell.textLabel?.text = (totalBox[indexPath.row] as AnyObject).value(forKey: "title") as? String
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.textLabel?.textColor = UIColor.black
        
        // 記事URL
        cell.detailTextLabel?.text = (totalBox[indexPath.row] as AnyObject).value(forKey: "link") as? String
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13.0)
        cell.detailTextLabel?.textColor = UIColor.gray
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // webviewを表示する
        let linkURL = ((totalBox[indexPath.row] as AnyObject).value(forKey: "link") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        let urlStr = (linkURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!
        guard let url = URL(string: urlStr) else {
            return
        }
        let urlRequest = NSURLRequest(url: url)
        self.tableView.isHidden = true
        self.webView.load(urlRequest as URLRequest)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.tableView.isHidden = true
        self.toolBar.isHidden = false
        self.webView.isHidden = false
    }
    
    // 次へ進む
    @IBAction func nextPage(_ sender: Any) {
        webView.goForward()
    }
    // 前に戻る
    @IBAction func backPage(_ sender: Any) {
        webView.goBack()
    }
    // 再読み込み
    @IBAction func refreshPage(_ sender: Any) {
        webView.reload()
    }
    // キャンセル
    @IBAction func cancel(_ sender: Any) {
        tableView.isHidden = false
        webView.isHidden = true
        toolBar.isHidden = true
    }
    
    @objc func refresh() {
        // ２秒後にdelayを呼ぶ
        perform(#selector(delay), with: nil, afterDelay: 2.0)
    }
    
    @objc func delay() {
        parseURL()
        // インジケータ終了
        refreshControl.endRefreshing()
    }

}

