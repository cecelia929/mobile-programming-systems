//
//  UserFeedViewController.swift
//  Instagram
//
//  Created by Zhou Ti on 11/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import MultipeerConnectivity


@available(iOS 10.0, *)
class UserFeedViewController: UIViewController, UIPopoverPresentationControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {

    @IBOutlet weak var hostIcon: UIBarButtonItem!
    @IBOutlet weak var collect: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noFeedLabel: UILabel!

    var sort: String = "time"

    var userFeed: [[String: Any]] = []
    var hosted: Bool = false

    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var filled: Bool = false
    let refreshControl = UIRefreshControl()
    var presenter: UserFeedPresenter!

    var pushed: Bool = false
    var id: Int = -1

    override func viewWillAppear(_ animated: Bool) {
        if pushed {
            self.navigationItem.title = "Photo"
        } else {
            self.navigationItem.title = "Instagram"
        }
        if !filled {
            self.loadingIndicator.startAnimating()
        }
        refillSelector()
    }

    func setFilled(filled: Bool) {
        self.filled = filled
    }

    override func viewDidLoad() {
        print("userfeedview did load: ", self)

        super.viewDidLoad()
        self.navigationItem.leftItemsSupplementBackButton = true
        setup()
        setupConnectivity()
        collect.keyboardDismissMode = .onDrag
        collect.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refillSelector), for: .valueChanged)
        registerNotification()

        if self.pushed {
            resetBackBarItem()
        }

        presenter.fill(id: self.id, hosted: self.hosted, sort: self.sort)
        loadList()
    }

    func stopLoadingIndicator() {
        self.loadingIndicator.stopAnimating()
    }

    func updateFeedData(userfeed: [[String: Any]]) {
        //reload data here
        self.userFeed = userfeed
    }

    @objc func refillSelector() {
        hideNoFeedLabel()
        presenter.fill(id: self.id, hosted: self.hosted, sort: self.sort)
    }

    func endRefreshing() {
        self.refreshControl.endRefreshing()
    }

    func loadList() {
        DispatchQueue.main.async {
            self.collect.reloadData()
        }
    }

    func dismissPopOver() {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func togglePopover(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "sortPopOverController") as! SortPopOverViewController
        vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width / 2, height: 100)
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        vc.vc = self
        let popOver = vc.popoverPresentationController
        popOver?.delegate = self
        popOver?.barButtonItem = sender
        self.present(vc, animated: true, completion: nil)
        Util.hapticEngine()
    }

    func setup() {
        presenter = UserFeedPresenter(vc: self)
        collect.dataSource = presenter.datasource
        collect.delegate = presenter
    }

    func setupConnectivity() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func sendFeedToPeer(dict: NSDictionary) {
        if mcSession.connectedPeers.count > 0 {
            do {
                let data = NSKeyedArchiver.archivedData(withRootObject: dict)
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch {
                fatalError("Could not send URL")
            }
        } else {
            print("You are not connected to other devices")
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                if let tabbarController = self.tabBarController {
                    let tabbarHeight = Float(tabbarController.tabBar.frame.height)
                    self.view.frame.origin.y -= CGFloat(Float(keyboardSize.height) - tabbarHeight)
                } else {
                    self.view.frame.origin.y -= CGFloat(keyboardSize.height)
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @IBAction func connect(_ sender: UIBarButtonItem) {
        Util.hapticEngine()
        let mcBrowser = MCBrowserViewController(serviceType: "ins", session: self.mcSession)
        mcBrowser.delegate = self
        self.present(mcBrowser, animated: true, completion: nil)
    }

    @IBAction func host(_ sender: UIBarButtonItem) {
        self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ins", discoveryInfo: nil, session: self.mcSession)
        if self.hosted {
            self.hostIcon.tintColor = UIColor.black
            self.hosted = false
            Util.hapticEngine()
            self.mcAdvertiserAssistant.stop()

            self.presenter.triggerShareButton()
            self.collect.reloadData()
        } else {
            self.hostIcon.tintColor = UIColor.init(red: 52 / CGFloat(255), green: 132 / CGFloat(255), blue: 250 / CGFloat(255), alpha: 1)
            self.hosted = true
            Util.hapticEngine()
            self.mcAdvertiserAssistant.start()

            self.presenter.triggerShareButton()
            self.collect.reloadData()
        }


    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = (sender as! UIButton).superview?.superview as? UICollectionViewCell {
            if let indexPath = collect.indexPath(for: cell) {
                let vc = segue.destination as! CommentsViewController
                let username = (self.userFeed[indexPath.row]["username"] as! String)
                vc.text = NSMutableAttributedString().bold(username).normal(" \((self.userFeed[indexPath.row]["text"] as! String))")
                vc.time = self.userFeed[indexPath.row]["time"] as! String
                if let avatarURL = self.userFeed[indexPath.row]["avatar"] as? String{
                    vc.avatar = avatarURL
                }else{
                    vc.avatar = UserDefaults.standard.string(forKey: "avatar") ?? ""
                }
                vc.username = username
                vc.id = self.userFeed[indexPath.row]["id"] as! Int
            }
        }
    }

    func performUserDetailSegue(username: String) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pushprofile") as! ProfileViewController
        vc.username = username
        vc.pushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func performLikeSegue(photo_id: Int) {
        let storyboard = UIStoryboard(name: "UserFeed", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "like") as! LikeViewController
        vc.id = photo_id
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - MC Delegate Functions

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {

    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as! NSDictionary
        Util.triggerNotification(name: "inrangeAppend", withData: ["dict": dict])

    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "feedinrange") as! FeedInRangeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }

    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func resetBackBarItem() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.view.tintColor = UIColor.black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = nil;
    }

    func showNoFeedLabel() {
        self.noFeedLabel.layer.zPosition = 1
    }

    func hideNoFeedLabel() {
        self.noFeedLabel.layer.zPosition = -1
    }
}
