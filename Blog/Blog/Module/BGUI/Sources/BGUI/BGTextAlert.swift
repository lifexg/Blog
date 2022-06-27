//
//  BGTextAlert.swift
//  Blog
//
//  Created by fexg on 2022/6/27.
//

import Foundation
import UIKit
import SwiftUI
import Combine

public struct BGTextAlert {
  public init(title: String = "", message: String = "", textfields:[BGAlertTextField], accept: String = "OK", cancel: String? = "Cancel", secondaryActionTitle: String? = nil, action: @escaping ([String?]) -> Void, secondaryAction: (() -> Void)? = nil) {
    self.title = title
    self.message = message
    self.accept = accept
    self.cancel = cancel
    self.secondaryActionTitle = secondaryActionTitle
    self.action = action
    self.secondaryAction = secondaryAction
    self.textfields = textfields
  }
  
  public var title: String // Title of the dialog
  public var message: String // Dialog message
  public var textfields:[BGAlertTextField]
  public var accept: String = "OK" // The left-most button label
  public var cancel: String? = "Cancel" // The optional cancel (right-most) button label
  public var secondaryActionTitle: String? = nil // The optional center button label
  public var action: ([String?]) -> Void // Triggers when either of the two buttons closes the dialog
  public var secondaryAction: (() -> Void)? = nil // Triggers when the optional center button is tapped
}

public struct BGAlertTextField {
  public init(placeholder: String = "", keyboardType: UIKeyboardType = .default) {
    self.placeholder = placeholder
    self.keyboardType = keyboardType
  }
  
  public var placeholder: String = "" // Placeholder text for the TextField
  public var keyboardType: UIKeyboardType = .default // Keyboard tzpe of the TextField
  
}

extension UIAlertController {
  convenience init(alert: BGTextAlert) {
    self.init(title: alert.title, message: alert.message, preferredStyle: .alert)
    alert.textfields.forEach { textfield in
      addTextField {
        $0.placeholder = textfield.placeholder
        $0.keyboardType = textfield.keyboardType
      }
    }
    if let cancel = alert.cancel {
      addAction(UIAlertAction(title: cancel, style: .cancel) { _ in
//        alert.action([])
      })
    }
    if let secondaryActionTitle = alert.secondaryActionTitle {
      addAction(UIAlertAction(title: secondaryActionTitle, style: .default, handler: { _ in
        alert.secondaryAction?()
      }))
    }
    addAction(UIAlertAction(title: alert.accept, style: .default) { _ in
      let textField = self.textFields
      var texts:[String?] = []
      textField?.forEach({ textfield in
        texts.append(textfield.text)
      })
      alert.action(texts)
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
    var body: some View {
      ZStack {
        AlertWrapper(isPresented: isPresented, alert: alert, content: self)
        self
      }
    }
    return body
  }
}


public class TextFieldAlertViewController: UIViewController {

  /// Presents a UIAlertController (alert style) with a UITextField and a `Done` button
  /// - Parameters:
  ///   - title: to be used as title of the UIAlertController
  ///   - message: to be used as optional message of the UIAlertController
  ///   - text: binding for the text typed into the UITextField
  ///   - isPresented: binding to be set to false when the alert is dismissed (`Done` button tapped)
  init(title: String, message: String?, text: Binding<String?>, isPresented: Binding<Bool>?) {
    self.alertTitle = title
    self.message = message
    self._text = text
    self.isPresented = isPresented
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Dependencies
  private let alertTitle: String
  private let message: String?
  @Binding private var text: String?
  private var isPresented: Binding<Bool>?

  // MARK: - Private Properties
  private var subscription: AnyCancellable?

  // MARK: - Lifecycle
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    presentAlertController()
  }

  private func presentAlertController() {
    guard subscription == nil else { return } // present only once

    let vc = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)

    // add a textField and create a subscription to update the `text` binding
    vc.addTextField { [weak self] textField in
      guard let self = self else { return }
      self.subscription = NotificationCenter.default
        .publisher(for: UITextField.textDidChangeNotification, object: textField)
        .map { ($0.object as? UITextField)?.text }
        .assign(to: \.text, on: self)
    }

    let action = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
      self?.isPresented?.wrappedValue = false
    }
    vc.addAction(action)
    present(vc, animated: true, completion: nil)
  }
}

public struct TextFieldAlert {
  public init(title: String, message: String?,text: Binding<String?>, isPresented: Binding<Bool>? = nil) {
    self.title = title
    self.message = message
    self.isPresented = isPresented
    self._text = text
  }
  
  
  // MARK: Properties
  let title: String
  let message: String?
  @Binding var text: String?
  var isPresented: Binding<Bool>? = nil

  // MARK: Modifiers
  func dismissable(_ isPresented: Binding<Bool>) -> TextFieldAlert {
    TextFieldAlert(title: title, message: message, text: $text, isPresented: isPresented)
  }
}

extension TextFieldAlert: UIViewControllerRepresentable {

  public typealias UIViewControllerType = TextFieldAlertViewController

  public func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlert>) -> UIViewControllerType {
    TextFieldAlertViewController(title: title, message: message, text: $text, isPresented: isPresented)
  }

  public func updateUIViewController(_ uiViewController: UIViewControllerType,
                              context: UIViewControllerRepresentableContext<TextFieldAlert>) {
    // no update needed
  }
}
struct TextFieldWrapper<PresentingView: View>: View {

  @Binding var isPresented: Bool
  let presentingView: PresentingView
  let content: () -> TextFieldAlert

  var body: some View {
    ZStack {
      if (isPresented) { content().dismissable($isPresented) }
      presentingView
    }
  }
}

extension View {
 public func textFieldAlert(isPresented: Binding<Bool>,
                      content: @escaping () -> TextFieldAlert) -> some View {
    TextFieldWrapper(isPresented: isPresented,
                     presentingView: self,
                     content: content)
  }
}
