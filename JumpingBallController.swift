import Foundation
import UIKit
import WebKit
import Network

class JumpingBallController: UIViewController, WKUIDelegate, WKNavigationDelegate {
 


 
    // MARK: - Lifecycle

    private func createOrientation() {
        AppDelegate.allOrientationStatus = .all
        view.backgroundColor = .black
        navigationItem.hidesBackButton = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createOrientation()
        addFrame()
        updateMonitorType()
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotate(from: fromInterfaceOrientation)
        addAllViews()
    }


   
    private var topConstraint: NSLayoutConstraint?

    private func createPreferences() -> WKWebViewConfiguration {
        let configurationStatus = WKWebViewConfiguration()
        configurationStatus.preferences = WKPreferences()
        configurationStatus.preferences.javaScriptEnabled = true
        configurationStatus.preferences.javaScriptCanOpenWindowsAutomatically = true
        configurationStatus.websiteDataStore = WKWebsiteDataStore.default()
        
        
        if #available(iOS 10.0, *) {
            configurationStatus.mediaTypesRequiringUserActionForPlayback = [.all]
        }
        
        if #available(iOS 14.0, *) {
            configurationStatus.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        
        return configurationStatus
    }

    private func dismissAlertWithAnimation() {
        basicContinueAlert.dismiss(animated: true, completion: nil)
    }
    private var ballView: WKWebView?
    // MARK: - Internet Connection Monitoring

    private func updateMonitorType() {
        let typeOfMonitor = NWPathMonitor()
        typeOfMonitor.pathUpdateHandler = { [weak self] pathUpdateHandler in
            DispatchQueue.main.async {
                if pathUpdateHandler.status == .satisfied {
                    self?.dismissAlertWithAnimation()
                } else {
                    self?.openAlertWithAnimation()
                }
            }
        }

        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        typeOfMonitor.start(queue: queue)
    }
    private func addAllViews() {
        guard let webView = ballView else { return }
        topConstraint?.isActive = false

        let isTypePortrait = preferredInterfaceOrientationForPresentation.isPortrait
        let lessThanViewFrame = (UIScreen.main.bounds.height / UIScreen.main.bounds.width) > 2
        let topConstant: CGFloat = lessThanViewFrame ? (isTypePortrait ? 70 : 0) : 0

        topConstraint = webView.topAnchor.constraint(equalTo: view.topAnchor, constant: topConstant)
        topConstraint?.isActive = true
        view.updateConstraintsIfNeeded()
    }
    private let basicContinueAlert = UIAlertController(
        title: "Network Error",
        message: "Please connect to the internet to continue.",
        preferredStyle: .alert
    )
   
    // MARK: - WKUIDelegate Methods

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let showingWebview = WKWebView(frame: webView.bounds, configuration: configuration)
        showingWebview.uiDelegate = self
        view.addSubview(showingWebview)
        return showingWebview
    }
    private func openAlertWithAnimation() {
        present(basicContinueAlert, animated: true, completion: nil)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    private func addFrame() {
        let mainStatusConfig = createPreferences()
        ballView = WKWebView(frame: view.bounds, configuration: mainStatusConfig)
        ballView?.uiDelegate = self
        ballView?.navigationDelegate = self
        ballView?.isOpaque = false
        ballView?.backgroundColor = .clear
        ballView?.scrollView.isScrollEnabled = true
        
        guard let foundedData = ballView else { return }

        foundedData.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(foundedData)

        NSLayoutConstraint.activate([
            foundedData.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            foundedData.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            foundedData.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        topConstraint = foundedData.topAnchor.constraint(equalTo: view.topAnchor)
        topConstraint?.isActive = true
        
        addAllViews()

        checkurlPosition()
    }
    private func checkurlPosition() {
        guard let urlString = UserDefaults.standard.string(forKey: "levelds"),
              let url = URL(string: urlString) else { return }

        let request = URLRequest(url: url)
        ballView?.load(request)
    }
    
    // MARK: - WKNavigationDelegate Methods
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Failed provisional navigation: \(error.localizedDescription)")
    }
    
   
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed navigation: \(error.localizedDescription)")
    }
}
