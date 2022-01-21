//
//  CXManager.swift
//  TestWkWebView
//
//  Created by Phani Yarlagadda on 1/20/22.
//

import Foundation
import CallKit
import AVFoundation

final class VCSCXManager: NSObject, ObservableObject {

    var callController = CXCallController()
    var provider: CXProvider?

    override init() {
        provider = CXProvider(configuration: type(of: self).providerConfiguration)
    }
    // MARK: - Actions

    /// Starts a new call with the specified handle and indication if the call includes video.
    /// - Parameters:
    ///   - handle: The caller's phone number.
    ///   - video: Indicates if the call includes video.
    func startCall(handle: String = "5615611234") {
        provider?.setDelegate(self, queue: nil)

        let handle = CXHandle(type: .phoneNumber, value: handle)
        let startCallAction = CXStartCallAction(call: UUID(), handle: handle)

        startCallAction.isVideo = true

        let transaction = CXTransaction()
        transaction.addAction(startCallAction)

        requestTransaction(transaction)
    }

    /// Requests that the actions in the specified transaction be asynchronously performed by the telephony provider.
    /// - Parameter transaction: A transaction that contains actions to be performed.
    private func requestTransaction(_ transaction: CXTransaction) {
        callController.request(transaction) { error in
            if let error = error {
                print("Error requesting transaction:", error.localizedDescription)
            } else {
                print("Requested transaction successfully")
            }
        }
    }

    /// The app's provider configuration, representing its CallKit capabilities
    static var providerConfiguration: CXProviderConfiguration {

        let providerConfiguration = CXProviderConfiguration()

        providerConfiguration.supportsVideo = true
        providerConfiguration.maximumCallGroups = 2
        providerConfiguration.supportedHandleTypes = [.emailAddress, .generic, .phoneNumber]
        providerConfiguration.includesCallsInRecents = false

        return providerConfiguration
    }

}


extension VCSCXManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        print("ERROR - providerDidReset")
    }

    /// System indicates that outgoing call has started
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        let uuid = action.callUUID
        action.fulfill()
        print("CXStartCallAction - uuid \(uuid.description)")

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {

            print("Calling (Answering) reportOutgoingCall - uuid \(uuid.description)")

            //   A nil value for `dateConnected` results in the connected date being set to now.
            provider.reportOutgoingCall(with: uuid, connectedAt: nil)
        }
    }

    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("CXProvider - didActivate AVAudioSession")
    }

    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("CXProvider - didDeactivate AVAudioSession")
    }
}
