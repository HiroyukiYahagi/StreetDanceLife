//
//  WebViewController.swift
//  StreetDanceLife
//
//  Created by Hiroyuki Yahagi on 2016/10/02.
//  Copyright © 2016年 Hiroyuki Yahagi. All rights reserved.
//

import UIKit
import Social
import WebKit
import LINEActivity
import TUSafariActivity

class WebViewController: UIViewController, WKNavigationDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var titleLabel: UILabel!
    var webView: WKWebView! = WKWebView()
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var entry:Entry? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toolBar.clipsToBounds = true
        
        self.titleLabel.text = self.entry?.title;
        
        self.setupWebView()
        
        let url: URL = URL(string:entry!.url!)!
        let request: URLRequest = URLRequest(url: url)
        webView.load(request)

    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        //読み込み状態が変更されたことを取得
        self.webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        //プログレスが変更されたことを取得
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        //遷移前に消さないと、アプリが落ちる
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.removeObserver(self, forKeyPath: "loading")
    }

    override func viewDidDisappear(_ animated: Bool) {
        EntityManager.save()
        super.viewDidDisappear(animated)
    }
    
    private func setupWebView(){
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.webView)
        self.view.addConstraints([
            NSLayoutConstraint(
                item: self.webView,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 64
            ),
            NSLayoutConstraint(
                item: self.webView,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: self.webView,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: self.webView,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1.0,
                constant: 0
            )
            ])
        //self.webView.allowsBackForwardNavigationGestures = true
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favariteButtonPressed(_ sender: AnyObject) {
        var title:String? = nil
        var message:String? = nil
        if(entry?.favorite)!{
            title = "Deleted Favorite"
            message = "This article was deleted from your favorite list"
            entry?.favorite = false
        }else{
            title = "Added Favorite"
            message = "This article was added to your favorite list"
            entry?.favorite = true
        }
        
        let avc = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        avc.addAction(defaultAction)
        self.present(avc, animated: true, completion: nil)
        
        //EntityManager.save()
    }
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        let shareText:String? = self.entry?.title
        let shareWebsite:URL? = URL(string: self.entry!.url!)
        let shareImage:UIImage? = self.entry?.getImageData({ (data) in })
        let shareItems = [shareText!, shareWebsite!, shareImage!] as [Any]
        
        let activeties = [LINEActivity(), TUSafariActivity()]
        let avc = UIActivityViewController(activityItems: shareItems, applicationActivities: activeties)
        
        // 使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.saveToCameraRoll,
            UIActivityType.print,
            UIActivityType.airDrop,
            UIActivityType.assignToContact,
            UIActivityType.addToReadingList,
            UIActivityType.mail,
            UIActivityType.message
        ]
        avc.excludedActivityTypes = excludedActivityTypes
        
        present(avc, animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            //estimatedProgressが変更されたときに、setProgressを使ってプログレスバーの値を変更する。
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
        }else if keyPath == "loading"{
            //インジゲーターの表示、非表示をきりかえる。
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.webView.isLoading
            if self.webView.isLoading{
                self.progressView.isHidden = false
                self.progressView.setProgress(0.1, animated: true)
            }else{
                self.progressView.isHidden = true
                self.progressView.setProgress(0.0, animated: false)
            }
        }
    }
}
