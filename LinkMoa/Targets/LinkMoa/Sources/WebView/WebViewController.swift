//
//  WebViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/19.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    @IBOutlet private weak var backwardButton: UIButton!
    @IBOutlet private weak var forwardButton: UIButton!
    @IBOutlet private weak var refreshButton: UIButton!
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var urlTextField: UITextField!
    @IBOutlet private weak var closeButton: UIButton!
    
    private let url: URL
    
    init?(coder: NSCoder, url: URL) {
        self.url = url
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtonState()
        webView.navigationDelegate = self
        prepareWebView(url: url)
    }

    private func prepareWebView(url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
        urlTextField.text = url.absoluteString
    }
    
    @IBAction private func backwardButtonTapped(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction private func forwardButtonTapped(_ sender: UIButton) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @IBAction private func refreashButtonTapped(_ sender: UIButton) {
        webView.reload()
    }
    
    @IBAction private func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction private func shareButtonTapped(_ sender: UIButton) {
        if let url = webView.url?.absoluteURL {
            let customActivity = CustomActivity()
            customActivity.delegate = self
            
            let activityController = UIActivityViewController(
                activityItems: [url],
                applicationActivities: [customActivity]
            )
    
            present(activityController, animated: true)
        }
    }
    
    private func updateButtonState() {
        backwardButton.tintColor = webView.canGoBack ? .black : UIColor(rgb: 0xc1c1c1)
        forwardButton.tintColor = webView.canGoForward ? .black : UIColor(rgb: 0xc1c1c1)
    }
}

extension WebViewController: CustomActivityDelegate {
    func performActionCompletion(actvity: CustomActivity) {
        guard let url = webView.url?.absoluteURL, UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}

extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateButtonState()
        if let url = webView.url?.absoluteString {
            urlTextField.text = url
        }
    }
}
