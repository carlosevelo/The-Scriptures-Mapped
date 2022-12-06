//
//  WebView.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 11/29/22.
//

import SwiftUI
import WebKit

enum WebViewLoadRequest {
    case htmlText(html: String)
    case urlRequest(request: URLRequest)
}

struct WebView: UIViewRepresentable {
    let request: WebViewLoadRequest
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        switch request {
            case .htmlText(let html):
                uiView.loadHTMLString(html, baseURL: nil)
            case .urlRequest(let request):
                uiView.load(request)
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        let request = URLRequest(url: URL(string: "https://hundredpushups.com")!)
        WebView(request: WebViewLoadRequest.urlRequest(request: request))
    }
}
