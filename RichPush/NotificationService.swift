//
//  NotificationService.swift
//  RichPush
//
//  Created by Mayank Sanganeria on 6/16/20.
//  Copyright © 2021 Leanplum. All rights reserved.
//

import UserNotifications
import CTNotificationService

class NotificationService: CTNotificationServiceExtension {
    
    struct Constants {
        static let ImageKey = "LP_URL"
        static let LP_KEY_PUSH_MESSAGE_ID = "_lpm"
        static let LP_KEY_PUSH_MUTE_IN_APP = "_lpu"
        static let LP_KEY_PUSH_NO_ACTION = "_lpn"
        static let LP_KEY_PUSH_NO_ACTION_MUTE = "_lpv"
    }

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        // MARK: - Leanplum Rich Push
        if let bestAttemptContent = bestAttemptContent {
            let userInfo = request.content.userInfo;
            
            guard (userInfo[Constants.LP_KEY_PUSH_MESSAGE_ID] ??
                   userInfo[Constants.LP_KEY_PUSH_MUTE_IN_APP] ??
                   userInfo[Constants.LP_KEY_PUSH_NO_ACTION] ??
                   userInfo[Constants.LP_KEY_PUSH_NO_ACTION_MUTE]) != nil else {
                // Not a Leanplum notification, try CleverTap
                super.didReceive(request, withContentHandler: contentHandler)
                return
            }

            // LP_URL is the key that is used from Leanplum to
            // send the image URL in the payload.
            //
            // If there is no LP_URL in the payload than
            // the code will still show the push notification.
            if userInfo[Constants.ImageKey] == nil {
                contentHandler(bestAttemptContent);
                return;
            }

            // If there is an image in the payload,
            // download and display the image.
            if let attachmentMedia = userInfo[Constants.ImageKey] as? String {
                let mediaUrl = URL(string: attachmentMedia)
                let LPSession = URLSession(configuration: .default)
                LPSession.downloadTask(with: mediaUrl!, completionHandler: { temporaryLocation, response, error in
                    if let err = error {
                        Log.print("Error with downloading rich push: \(String(describing: err.localizedDescription))")
                        contentHandler(bestAttemptContent);
                        return;
                    }

                    let fileType = self.determineType(fileType: (response?.mimeType)!)
                    let fileName = temporaryLocation?.lastPathComponent.appending(fileType)

                    let temporaryDirectory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName!)

                    do {
                        try FileManager.default.moveItem(at: temporaryLocation!, to: temporaryDirectory)
                        let attachment = try UNNotificationAttachment(identifier: "", url: temporaryDirectory, options: nil)

                        bestAttemptContent.attachments = [attachment];
                        contentHandler(bestAttemptContent);
                        // The file should be removed automatically from temp
                        // Delete it manually if it is not
                        if FileManager.default.fileExists(atPath: temporaryDirectory.path) {
                            try FileManager.default.removeItem(at: temporaryDirectory)
                        }
                    } catch {
                        Log.print("Error with the rich push attachment: \(error)")
                        contentHandler(bestAttemptContent);
                        return;
                    }
                }).resume()

            }
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

    // MARK: - Leanplum Rich Push
    func determineType(fileType: String) -> String {
        // Determines the file type of the attachment to append to URL.
        if fileType == "image/jpeg" {
            return ".jpg";
        }
        if fileType == "image/gif" {
            return ".gif";
        }
        if fileType == "image/png" {
            return ".png";
        } else {
            return ".tmp";
        }
    }
}
