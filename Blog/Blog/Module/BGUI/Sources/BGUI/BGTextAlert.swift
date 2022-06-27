//
//  BGTextAlert.swift
//  Blog
//
//  Created by fexg on 2022/6/27.
//

import Foundation
import UIKit
import SwiftUI

public struct BGTextAlert {
  public init(title: String, message: String, placeholder: String = "", accept: String = "OK", cancel: String? = "Cancel", secondaryActionTitle: String? = nil, keyboardType: UIKeyboardType = .default, action: @escaping (String?) -> Void, secondaryAction: (() -> Void)? = nil) {
    self.title = title
    self.message = message
    self.placeholder = placeholder
    self.accept = accept
    self.cancel = cancel
    self.secondaryActionTitle = secondaryActionTitle
    self.keyboardType = keyboardType
    self.action = action
    self.secondaryAction = secondaryAction
  }
  
  public var title: String // Title of the dialog
  public var message: String // Dialog message
  public var placeholder: String = "" // Placeholder text for the TextField
  public var accept: String = "OK" // The left-most button label
  public var cancel: String? = "Cancel" // The optional cancel (right-most) button label
  public var secondaryActionTitle: String? = nil // The optional center button label
  public var keyboardType: UIKeyboardType = .default // Keyboard tzpe of the TextField
  public var action: (String?) -> Void // Triggers when either of the two buttons closes the dialog
  public var secondaryAction: (() -> Void)? = nil // Triggers when the optional center button is tapped
}

extension UIAlertController {
  convenience init(alert: BGTextAlert) {
    self.init(title: alert.title, message: alert.message, preferredStyle: .alert)
    addTextField {
      $0.placeholder = alert.placeholder
      $0.keyboardType = alert.keyboardType
    }
    if let cancel = alert.cancel {
      addAction(UIAlertAction(title: cancel, style: .cancel) { _ in
        alert.action(nil)
      })
    }
    if let secondaryActionTitle = alert.secondaryActionTitle {
      addAction(UIAlertAction(title: secondaryActionTitle, style: .default, handler: { _ in
        alert.secondaryAction?()
      }))
    }
    let textField = self.textFields?.first
    addAction(UIAlertAction(title: alert.accept, style: .default) { _ in
      alert.action(textField?.text)
    })
  }
}

struct AlertWrapper<Content: View>: UIViewControllerRepresentable {
  @Binding var isPresented: Bool
  let alert: BGTextAlert
  let content: Content
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<AlertWrapper>) -> UIHostingController<Content> {
    UIHostingController(rootView: content)
  }
  
  final class Coordinator {
    var alertController: UIAlertController?
    init(_ controller: UIAlertController? = nil) {
      self.alertController = controller
    }
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator()
  }
  
  func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: UIViewControllerRepresentableContext<AlertWrapper>) {
    uiViewController.rootView = content
    if isPresented && uiViewController.presentedViewController == nil {
      var alert = self.alert
      alert.action = {
        self.isPresented = false
        self.alert.action($0)
      }
      context.coordinator.alertController = UIAlertController(alert: alert)
      uiViewController.present(context.coordinator.alertController!, animated: true)
    }
    if !isPresented && uiViewController.presentedViewController == context.coordinator.alertController {
      uiViewController.dismiss(animated: true)
    }
  }
}

extension View {
  public func alert(isPresented: Binding<Bool>, _ alert: BGTextAlert) -> some View {
    AlertWrapper(isPresented: isPresented, alert: alert, content: self)
  }
}
