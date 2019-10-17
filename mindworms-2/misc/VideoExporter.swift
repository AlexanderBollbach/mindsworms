
import Foundation
import CoreGraphics
import CoreMedia
import QuartzCore
import AVFoundation
//import PromiseKit
//
//func createVideoInDefaultDir(from project: Project, progress: @escaping (String) -> Void = { _ in }) -> Promise<String> {
//    return Promise { r in
//        export(project: project, progress: { p in
//            progress("exporting \(p)")
//        }, finished: { s in
//            r.fulfill(s)
//        })
//    }
//}
//
//private func export(project: Project,
//            progress: @escaping (Int) -> Void,
//            finished: @escaping (String) -> Void) {
//
//    let vidURL = NSURL.fileURL(withPath: "\(project.exportSettings.destinationPath)/\(project.name).mp4")
//
//    try? FileManager.default.removeItem(at: vidURL)
//
//    let settings: [String: Any] = [AVVideoCodecKey: AVVideoCodecType.h264,
//                                   AVVideoWidthKey: project.exportSettings.videoWidth,
//                                   AVVideoHeightKey: project.exportSettings.videoHeight]
//
//    let assetWriter = try! AVAssetWriter(url: vidURL, fileType: .m4v)
//    let writerInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: settings)
//    let inputAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput, sourcePixelBufferAttributes: nil)
//    assetWriter.add(writerInput)
//
//    let queue = DispatchQueue.global(qos: .background)
//
//    writerInput.expectsMediaDataInRealTime = false
//    assetWriter.startWriting()
//    assetWriter.startSession(atSourceTime: kCMTimeZero)
//
//    writerInput.requestMediaDataWhenReady(on: queue) {
//
//        let frameCount = project.exportSettings.numFrames
//
//        var i = 0
//
//        var tick = 0
//
//        while i < frameCount {
//
//            if writerInput.isReadyForMoreMediaData {
//
//                tick = tick < 100 ? tick + 1 : 0
//
//                let image = render(project: project, tick: tick)!
//
//                guard let buffer = newPixelBufferFrom(cgImage: image,
//                                                      width: project.exportSettings.videoWidth,
//                                                      height: project.exportSettings.videoHeight) else { fatalError() }
//
//                if i == 0 {
//                    inputAdaptor.append(buffer, withPresentationTime: kCMTimeZero)
//                } else {
//                    let time = CMTimeMake(Int64(i), Int32(project.exportSettings.framerateOutput))
//                    inputAdaptor.append(buffer, withPresentationTime: time)
//                }
//
//                i += 1
//
//                if i % (frameCount / 10) == 0 {
//                    progress(Int(Double(i) / Double(frameCount) * 100))
//                }
//            }
//        }
//
//        writerInput.markAsFinished()
//
//        assetWriter.finishWriting {
//            finished(vidURL.absoluteString)
//        }
//    }
//}
//
//
//
//private func newPixelBufferFrom(cgImage: CGImage,
//                                width: Int,
//                                height: Int) -> CVPixelBuffer? {
//
//    let options:[String: Any] = [
//        kCVPixelBufferCGImageCompatibilityKey as String: true,
//        kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
//    ]
//
//    var pxbuffer: CVPixelBuffer?
//    let status = CVPixelBufferCreate(kCFAllocatorDefault,
//                                     width,
//                                     height,
//                                     kCVPixelFormatType_32ARGB,
//                                     options as CFDictionary?,
//                                     &pxbuffer)
//
//    assert(status == kCVReturnSuccess && pxbuffer != nil, "newPixelBuffer failed")
//
//    CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
//
//    let pxdata = CVPixelBufferGetBaseAddress(pxbuffer!)
//
//    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
//
//    guard let context = CGContext(data: pxdata,
//                                  width: width,
//                                  height: height,
//                                  bitsPerComponent: 8,
//                                  bytesPerRow: 4 * width,
//                                  space: rgbColorSpace,
//                                  bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else { fatalError() }
//
//    context.concatenate(CGAffineTransform.identity)
//    let rect = CGRect(x: 0, y: 0, width: width, height: height)
//    context.clear(rect)
//    context.draw(cgImage, in: rect)
//    CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
//    return pxbuffer
//}
//
//
