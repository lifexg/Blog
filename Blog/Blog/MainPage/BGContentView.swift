//
//  BGContentView.swift
//  Blog
//
//  Created by fexg on 2022/6/17.
//

import SwiftUI
import WebKit

struct BGContentView: View {
  //  @Binding var link: String
  @ObservedObject var webViewModel:WebViewModel
  
  var body: some View {
    ZStack {
      WebViewContainer(webViewModel: webViewModel)
      if webViewModel.isLoading {
        ProgressView()
          .frame(height: 30)
      }
    }
    .navigationBarTitle(Text(webViewModel.title), displayMode: .inline)
    .navigationBarItems(leading: Button(action: {
      webViewModel.shouldGoBack.toggle()
    }, label: {
      if webViewModel.canGoBack {
        Image(systemName: "arrow.left")
          .frame(width: 44, height: 44, alignment: .center)
      } else {
        EmptyView()
          .frame(width: 0, height: 0, alignment: .center)
      }
    })
    )
  }
}

struct BGContentView_Previews: PreviewProvider {
  static var previews: some View {
    BGContentView(webViewModel: WebViewModel(url: "https://www.baidu.com"))
  }
}

class WebViewModel: ObservableObject {
  @Published var isLoading: Bool = false
  @Published var canGoBack: Bool = false
  @Published var shouldGoBack: Bool = false
  @Published var title: String = ""
  
  var url: String
  
  init(url: String) {
    self.url = url
  }
}


struct WebViewContainer: UIViewRepresentable {
  @ObservedObject var webViewModel: WebViewModel
  
  func makeCoordinator() -> WebViewContainer.Coordinator {
    Coordinator(self, webViewModel)
  }
  
  func makeUIView(context: Context) -> WKWebView {
    guard let url = URL(string: self.webViewModel.url) else {
      return WKWebView()
    }
    
    let request = URLRequest(url: url)
    let webView = WKWebView()
    webView.navigationDelegate = context.coordinator
    webView.load(request)
    
    return webView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    if webViewModel.shouldGoBack {
      uiView.goBack()
      webViewModel.shouldGoBack = false
    }
  }
}

extension WebViewContainer {
  class Coordinator: NSObject, WKNavigationDelegate {
    @ObservedObject private var webViewModel: WebViewModel
    private let parent: WebViewContainer
    
    init(_ parent: WebViewContainer, _ webViewModel: WebViewModel) {
      self.parent = parent
      self.webViewModel = webViewModel
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
      webViewModel.isLoading = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      webViewModel.isLoading = false
      webViewModel.title = webView.title ?? ""
      webViewModel.canGoBack = webView.canGoBack
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      webViewModel.isLoading = false
    }
  }
}
