import SwiftUI
import UniformTypeIdentifiers

struct APathActionDetailView: View {
    let actionID: APathActionID
    let isCompleted: Bool
    let onComplete: () -> Void

    @State private var isImportingFile = false
    @State private var selectedFileName: String?
    @State private var portfolioLink = ""
    @State private var showCompletionConfirmation = false
    @State private var showGuide = false
    @State private var fileErrorMessage = ""
    @State private var showFileError = false

    private var actionDescription: String {
        if actionID == .portfolio {
            return "프로젝트 2~3개를 정리하면 IT·개발 분야의 인턴, 공모전, 교육 기회가 열려요."
        }
        return actionID.subtitle
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                APathSubpageHeader(title: "", onBack: { dismiss() })

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        actionIconBadge
                            .padding(.bottom, FINDRSpacing.large - 3)

                        Text(actionID.title)
                            .font(FINDRFont.bold(26))
                            .kerning(-0.52)
                            .foregroundStyle(FINDRColor.heading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, FINDRSpacing.large - 2)

                        Text(actionDescription)
                            .font(FINDRFont.regular(14))
                            .kerning(-0.28)
                            .foregroundStyle(FINDRColor.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, FINDRSpacing.large)

                        impactCard
                            .padding(.bottom, FINDRSpacing.large - 3)

                        Text("이렇게 준비해요")
                            .font(FINDRFont.bold(17))
                            .kerning(-0.34)
                            .foregroundStyle(FINDRColor.primaryText)
                            .padding(.bottom, FINDRSpacing.large)

                        ForEach(actionID.preparationSteps.indices, id: \.self) { index in
                            preparationStepRow(index: index)
                                .padding(.bottom, index == actionID.preparationSteps.indices.last ? FINDRSpacing.large - 2 : FINDRSpacing.large)
                        }

                        if actionID == .portfolio {
                            portfolioUpload
                        }
                    }
                    .padding(.horizontal, FINDRSpacing.screen)
                    .padding(.top, FINDRSpacing.small - 1)
                    .padding(.bottom, FINDRSpacing.large)
                }

                bottomCTA
            }
            .background(FINDRColor.surface)

            if showCompletionConfirmation {
                completionConfirmation
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(FINDRColor.surface)
        .toolbar(.hidden, for: .navigationBar)
        .fileImporter(
            isPresented: $isImportingFile,
            allowedContentTypes: [.pdf, .presentation, .image],
            allowsMultipleSelection: false,
            onCompletion: handleImportedFile
        )
        .sheet(isPresented: $showGuide) {
            APathPreparationGuideSheet(actionID: actionID)
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(28)
        }
        .alert("파일을 추가할 수 없어요", isPresented: $showFileError) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(fileErrorMessage)
        }
        .animation(.easeInOut(duration: 0.2), value: showCompletionConfirmation)
    }

    @Environment(\.dismiss) private var dismiss

    private var actionIconBadge: some View {
        let iconName = actionID == .portfolio ? FINDRAssetName.aPathFileBadge : actionID.iconName

        return FINDRIcon(name: iconName, size: 28, tint: FINDRColor.brand)
            .frame(width: 56, height: 56)
            .background(FINDRColor.brandSubtle, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var impactCard: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.small) {
            HStack(spacing: FINDRSpacing.xSmall) {
                Text("완료하면")
                    .font(FINDRFont.medium(13))
                    .kerning(-0.26)
                    .foregroundStyle(FINDRColor.secondaryText)
                Text("+\(actionID.opportunityCount)개 기회")
                    .font(FINDRFont.bold(17))
                    .kerning(-0.34)
                    .foregroundStyle(FINDRColor.brand)
            }

            HStack(spacing: FINDRSpacing.xSmall) {
                ForEach(actionID.breakdown) { item in
                    Text("\(item.category) +\(item.count)")
                        .font(FINDRFont.regular(12))
                        .kerning(-0.24)
                        .foregroundStyle(FINDRColor.brand)
                        .padding(.horizontal, FINDRSpacing.small)
                        .padding(.vertical, FINDRSpacing.xSmall)
                        .background(FINDRColor.brandSubtle, in: RoundedRectangle(cornerRadius: FINDRRadius.small, style: .continuous))
                }
            }
        }
        .padding(FINDRSpacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(FINDRColor.brandTint, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func preparationStepRow(index: Int) -> some View {
        HStack(alignment: .top, spacing: FINDRSpacing.small) {
            Text("\(index + 1)")
                .font(FINDRFont.bold(12))
                .foregroundStyle(FINDRColor.secondaryText)
                .frame(width: 22, height: 22)
                .background(FINDRColor.subtle, in: Circle())

            Text(actionID.preparationSteps[index])
                .font(FINDRFont.regular(14))
                .kerning(-0.28)
                .foregroundStyle(FINDRColor.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var portfolioUpload: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.medium) {
            Text("포트폴리오 올리기")
                .font(FINDRFont.bold(17))
                .kerning(-0.34)
                .foregroundStyle(FINDRColor.primaryText)

            Button {
                isImportingFile = true
            } label: {
                HStack(spacing: FINDRSpacing.medium) {
                    FINDRIcon(name: FINDRAssetName.aPathUpload, size: 22, tint: FINDRColor.primaryText)
                        .frame(width: 40, height: 40)
                        .background(FINDRColor.brandSubtle, in: Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text(selectedFileName ?? "파일을 선택해 업로드하세요")
                            .font(FINDRFont.bold(14))
                            .foregroundStyle(FINDRColor.primaryText)
                            .lineLimit(1)
                        Text("PDF · PPT · 이미지, 최대 20MB")
                            .font(FINDRFont.regular(12))
                            .foregroundStyle(FINDRColor.tertiaryText)
                    }
                    Spacer(minLength: 0)
                }
                .padding(FINDRSpacing.large)
                .frame(maxWidth: .infinity, minHeight: 75)
                .background(FINDRColor.subtle, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(FINDRColor.borderStrong, style: StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(selectedFileName.map { "선택한 파일 \($0)" } ?? "포트폴리오 파일 선택")

            HStack(spacing: FINDRSpacing.small) {
                FINDRIcon(name: FINDRAssetName.aPathLink, size: 20, tint: FINDRColor.primaryText)
                TextField(
                    "또는 노션·깃허브 링크 붙여넣기",
                    text: $portfolioLink,
                    prompt: Text("또는 노션·깃허브 링크 붙여넣기").foregroundColor(FINDRColor.tertiaryText)
                )
                    .font(FINDRFont.regular(14))
                    .kerning(-0.28)
                    .foregroundStyle(FINDRColor.primaryText)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityLabel("노션 또는 깃허브 포트폴리오 링크")
            }
            .padding(.horizontal, FINDRSpacing.large)
            .frame(height: 50)
            .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(FINDRColor.border, lineWidth: 1)
            }
        }
    }

    private var bottomCTA: some View {
        VStack(spacing: FINDRSpacing.large) {
            HStack(spacing: FINDRSpacing.small) {
                FINDRButton(title: "가이드 보기", kind: .outline, height: 53) {
                    showGuide = true
                }
                .frame(width: 116)

                FINDRButton(title: isCompleted ? "완료됐어요" : "완료했어요", height: 53, action: {
                    showCompletionConfirmation = true
                })
                .disabled(isCompleted)
                .opacity(isCompleted ? 0.65 : 1)
            }

            Capsule()
                .fill(FINDRColor.primaryText)
                .frame(width: 134, height: 5)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.top, FINDRSpacing.medium + 2)
        .padding(.bottom, FINDRSpacing.small)
        .frame(maxWidth: .infinity)
        .background {
            FINDRColor.surface
                .overlay(alignment: .top) { FINDRColor.divider.frame(height: 1) }
                .ignoresSafeArea(edges: .bottom)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private var completionConfirmation: some View {
        ZStack {
            FINDRColor.scrim
                .opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { showCompletionConfirmation = false }

            VStack(spacing: FINDRSpacing.medium) {
                FINDRIcon(name: FINDRAssetName.aPathCheck, size: 24, tint: FINDRColor.brand)
                    .frame(width: 48, height: 48)
                    .background(FINDRColor.brandSubtle, in: Circle())

                VStack(spacing: FINDRSpacing.xSmall) {
                    Text(actionID.completionConfirmationTitle)
                        .font(FINDRFont.bold(17))
                        .kerning(-0.34)
                        .foregroundStyle(FINDRColor.primaryText)
                        .multilineTextAlignment(.center)

                    Text("보유 조건에 추가되고, 새로 열리는 기회를 바로 보여\n드려요.")
                        .font(FINDRFont.regular(13))
                        .kerning(-0.26)
                        .foregroundStyle(FINDRColor.secondaryText)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack(spacing: FINDRSpacing.small) {
                    FINDRButton(title: "취소", kind: .outline) {
                        showCompletionConfirmation = false
                    }
                    FINDRButton(title: "완료로 표시") {
                        showCompletionConfirmation = false
                        onComplete()
                    }
                }
            }
            .padding(24)
            .frame(width: 320, height: 247)
            .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color(hex: 0x0F1733).opacity(0.1), radius: 40, x: 0, y: 16)
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("apath-completion-confirmation")
        }
        .zIndex(2)
        .ignoresSafeArea()
    }

    private func handleImportedFile(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            let didStartAccessing = url.startAccessingSecurityScopedResource()
            defer {
                if didStartAccessing {
                    url.stopAccessingSecurityScopedResource()
                }
            }

            do {
                let fileValues = try url.resourceValues(forKeys: [.fileSizeKey])
                guard let fileSize = fileValues.fileSize else {
                    fileErrorMessage = "선택한 파일의 크기를 확인할 수 없어요."
                    showFileError = true
                    return
                }
                guard fileSize <= 20 * 1_024 * 1_024 else {
                    fileErrorMessage = "20MB 이하 파일을 선택해 주세요."
                    showFileError = true
                    return
                }
                selectedFileName = url.lastPathComponent
            } catch {
                fileErrorMessage = "선택한 파일의 정보를 읽을 수 없어요."
                showFileError = true
            }
        case .failure(let error):
            if (error as? CocoaError)?.code == .userCancelled {
                return
            }
            fileErrorMessage = "파일을 선택하거나 읽지 못했어요. 다시 선택해 주세요."
            showFileError = true
        }
    }
}

private struct APathPreparationGuideSheet: View {
    let actionID: APathActionID
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.large) {
            HStack {
                Text("\(actionID.title) 준비 가이드")
                    .font(FINDRFont.titleSmall)
                    .foregroundStyle(FINDRColor.primaryText)
                Spacer()
                Button("닫기") { dismiss() }
                    .font(FINDRFont.medium(13))
                    .foregroundStyle(FINDRColor.brand)
            }

            ForEach(actionID.preparationSteps.indices, id: \.self) { index in
                HStack(alignment: .top, spacing: FINDRSpacing.small) {
                    Text("\(index + 1)")
                        .font(FINDRFont.bold(12))
                        .foregroundStyle(FINDRColor.brand)
                    Text(actionID.preparationSteps[index])
                        .font(FINDRFont.regular(14))
                        .foregroundStyle(FINDRColor.primaryText)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(FINDRSpacing.screen)
        .padding(.top, FINDRSpacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(FINDRColor.surface.ignoresSafeArea())
    }
}
