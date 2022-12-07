//
//  WebView.swift
//  Pushup Tracker
//
//  Created by Steve Liddle on 10/26/21.
//

import SwiftUI
import WebKit

enum WebViewLoadRequest {
    case htmlText(html: String)
    case urlRequest(request: URLRequest)
}

struct WebView: UIViewRepresentable {
    let request: WebViewLoadRequest

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()

        webView.navigationDelegate = context.coordinator

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        switch request {
            case .htmlText(let html):
                uiView.loadHTMLString(html, baseURL: nil)
            case .urlRequest(let request):
                uiView.load(request)
        }
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            if navigationAction.navigationType == .linkActivated  {
                if let url = navigationAction.request.url {

                    // NEEDSWORK: check for https://scriptures.byu.edu/mapscrip/<GeoPlaceID>
                    if UIApplication.shared.canOpenURL(url) {

                        // NEEDSWORK: override the click action here
                        print("User clicked on \(navigationAction.request.url?.absoluteString ?? "I don't know")")

                        decisionHandler(.cancel)
                    } else {
                        decisionHandler(.allow)
                    }
                }
            } else {
                decisionHandler(.allow)
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
//        let request = URLRequest(url: URL(string: "https://hundredpushups.com")!)
//
//        WebView(request: WebViewLoadRequest.urlRequest(request: request))
        WebView(request: WebViewLoadRequest.htmlText(html: ScriptureRenderer.shared.htmlForBookId(101, chapter: 2)))
    }
}
