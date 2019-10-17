
import UIKit
import SwiftUI

struct ProjectRenderingView: UIViewRepresentable {
    typealias UIViewType = ProjectRenderingUIView

    let project: Project
    let framerate: Int

    func makeUIView(context: UIViewRepresentableContext<ProjectRenderingView>) -> ProjectRenderingView.UIViewType { ProjectRenderingUIView(framerate: framerate) }

    func updateUIView(_ uiView: ProjectRenderingView.UIViewType, context: UIViewRepresentableContext<ProjectRenderingView>) {
        uiView.project = self.project
        uiView.framerate = self.framerate
    }
}

class ProjectRenderingUIView: AnimatingFramedView {
    
    var framerate: Int {
        didSet {
            set(framerate: framerate)
        }
    }
    
    var project: Project? {
        didSet {
            if let project = self.project {
//                self.renderer.env = getRE(from: project)
            }
        }
    }
    
    init(framerate: Int) {
        self.framerate = framerate
        super.init(defaultFrameRate: framerate)
        isUserInteractionEnabled = false
    }
    
    let renderer = Renderer()
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func frameProvider() -> UIImage? {
//        guard
//            let project = self.project,
//            let im = self.renderer.render(project: project) else { return nil }
//
//        return UIImage(cgImage: im)
        
        return nil
    }
}


private func getRE(from project: Project) -> RenderingEnvironment {
    let exportSettings = project.settings
    
    let context = CGContext(data: nil,
                            width: exportSettings.canvasWidth,
                            height: exportSettings.canvasHeight,
                            bitsPerComponent: 8,
                            bytesPerRow: 4 * exportSettings.canvasWidth,
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    let rect = CGRect(
        x: 0,
        y: 0,
        width: project.settings.canvasWidth,
        height: project.settings.canvasHeight
    )
    let re = RenderingEnvironment(
        context: context,
        transform: project.transform,
        rect: rect
    )
    
    return re
}
