//
//  WebViewViewController.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 16.06.2024.
//

import UIKit
import WebKit

final class WebViewVC: UIViewController {
    
    private lazy var webView: WKWebView = {
        var webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        var progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = .ypBlack
        progressView.setProgress(0.1, animated: true)
        return progressView
    }()
    
    private final let webViewPresenter: WebViewProtocol = WebViewPresenter()
    private final var webViewVCDelegate: WebViewVCDelegate?
    private final var estimatedProgressObservation: NSKeyValueObservation?
    
    init(webViewVCDelegate: WebViewVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.webViewVCDelegate = webViewVCDelegate
    }
    
    required init?(coder: NSCoder) {
        //TODO: Избавиться от строки
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(progressView)
        view.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance.backgroundColor = .white
        setupConstraint()
        webView.load(webViewPresenter.loadAuth())
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 updateProgress()
             })
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
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
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

extension WebViewVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = webViewPresenter.code(from: navigationAction) {
            webViewVCDelegate?.webViewVC(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
