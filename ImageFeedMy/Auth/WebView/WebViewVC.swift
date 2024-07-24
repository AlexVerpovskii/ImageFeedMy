//
//  WebViewViewController.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 16.06.2024.
//

import UIKit
import WebKit

protocol WebViewViewControllerProtocol: AnyObject {
    var webViewPresenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewVC: UIViewController, WebViewViewControllerProtocol {
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    
    private lazy var webView: WKWebView = {
        var webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.accessibilityIdentifier = "UnsplashWebView"
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        var progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = .ypBlack
        progressView.setProgress(0.1, animated: true)
        return progressView
    }()
    
    final var webViewPresenter: WebViewPresenterProtocol?
    final var webViewVCDelegate: WebViewVCDelegate?
    private final var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(progressView)
        view.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance.backgroundColor = .white
//        webViewPresenter?.view = self
        setupConstraint()
//        guard let request = webViewPresenter?.loadAuth() else { return }
//        webView.load(request)
        webViewPresenter?.viewDidLoad()
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 print(webView.estimatedProgress)
                 webViewPresenter?.didUpdateProgressValue(webView.estimatedProgress)
             })
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            webViewPresenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
//    private func updateProgress() {
//        progressView.progress = Float(webView.estimatedProgress)
//        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
//    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
}

extension WebViewVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return }
        if let code = webViewPresenter?.code(from: url.absoluteString) {
            webViewVCDelegate?.webViewVC(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
