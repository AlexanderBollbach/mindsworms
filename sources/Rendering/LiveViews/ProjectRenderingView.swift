
import UIKit
import SwiftUI

struct ProjectRenderingView: UIViewRepresentable {
    typealias UIViewType = ProjectRenderingUIView

    let project: Project
    let framerate: Int

    func makeUIView(context: UIViewRepresentableContext<ProjectRenderingView>) -> ProjectRenderingView.UIViewType { ProjectRenderingUIView(framerate: framerate) }

    func updateUIView(_ uiView: ProjectRenderingView.UIViewType, context: UIViewRepresentableContext<ProjectRenderingView>) {
        uiView.updateProject(project)
        uiView.framerate = framerate
    }
}

class ProjectRenderingUIView: AnimatingFramedView {
    
    private let renderer = Renderer()
    var framerate: Int { didSet { set(framerate: framerate) } }
    
    func updateProject(_ project: Project) {
//        renderingProject = R_Project(project: project)
        renderingProject.transform = project.transform
        renderingProject.layers.update(with: project.layers)
        renderingProject.settings = project.settings
    }
    
    private var renderingProject = R_Project()
    
    init(framerate: Int) {
        self.framerate = framerate
        super.init(defaultFrameRate: framerate)
        isUserInteractionEnabled = false
    }
    
    
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func frameProvider() -> UIImage? {
        guard let im = self.renderer.render(project: renderingProject) else { return nil }
        return UIImage(cgImage: im)
    }
}
