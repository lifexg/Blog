//
//  BGContentView.swift
//  Blog
//
//  Created by fexg on 2022/6/17.
//

import SwiftUI
import WebKit
import WidgetKit

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
    ).onAppear(perform: recentlyRead)
  }
  
  func recentlyRead() {
    let name = webViewModel.name
    let url = webViewModel.url
  
//    bookMarksPageStore.dispatch(BGBookMarksPageReadDetailAction(name: name, link: url))
    readDetail(name: name, link: url)
    
  }
  
  func readDetail(name: String, link: String) {
    let key = "iCloudRecentlyReadKey"
    if var arr = NSUbiquitousKeyValueStore.default.array(forKey: key) {
      arr.insert(["name":name, "link": link], at: 0)
      
      if arr.count > 30 {
        arr.removeLast(30)
      }
      NSUbiquitousKeyValueStore.default.set(arr, forKey: key)
    } else {
      NSUbiquitousKeyValueStore.default.set([["name":name, "link": link]], forKey: key)
    }
    NSUbiquitousKeyValueStore.default.synchronize()
    WidgetCenter.shared.reloadTimelines(ofKind: "NowWidget2")
  }


}

struct BGContentView_Previews: PreviewProvider {
  static var previews: some View {
    BGContentView(webViewModel: WebViewModel(url: "https://www.baidu.com", name: "百度"))
  }
}

class WebViewModel: ObservableObject {
  @Published var isLoading: Bool = false
  @Published var canGoBack: Bool = false
  @Published var shouldGoBack: Bool = false
  @Published var title: String = ""
  
  var url: String
  var name: String
  
  init(url: String, name: String) {
    self.url = url
    self.name = name
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
//      bookMarksPageStore.dispatch(BGBookMarksPageReadDetailAction(name: webViewModel.name, link: webViewModel.url))
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      webViewModel.isLoading = false
    }
  }
}
