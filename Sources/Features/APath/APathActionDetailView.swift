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
                    VStack(alignment: .leading, spacing: FINDRSpacing.large) {
                        actionHeader
                        impactCard
                        preparationGuide
                        if actionID == .portfolio {
                            portfolioUpload
                        }
                    }
                    .padding(.horizontal, FINDRSpacing.screen)
                    .padding(.top, FINDRSpacing.medium)
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

    private var actionHeader: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.medium) {
            FINDRIcon(name: actionID.iconName, size: 28, tint: FINDRColor.brand)
                .frame(width: 56, height: 56)
                .background(FINDRColor.brandSubtle, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

            VStack(alignment: .leading, spacing: FINDRSpacing.small) {
                Text(actionID.title)
                    .font(FINDRFont.bold(22))
                    .kerning(-0.44)
                    .foregroundStyle(FINDRColor.primaryText)

                Text(actionDescription)
                    .font(FINDRFont.regular(13))
                    .kerning(-0.26)
                    .foregroundStyle(FINDRColor.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var impactCard: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.medium) {
            HStack(spacing: FINDRSpacing.xSmall) {
                Text("완료하면")
                    .font(FINDRFont.regular(12))
                    .foregroundStyle(FINDRColor.secondaryText)
                Text("+\(actionID.opportunityCount)개 기회")
                    .font(FINDRFont.bold(16))
                    .foregroundStyle(FINDRColor.brand)
            }

            HStack(spacing: FINDRSpacing.small) {
                ForEach(actionID.breakdown) { item in
                    HStack(spacing: 4) {
                        Text(item.category)
                            .foregroundStyle(FINDRColor.secondaryText)
                        Text("+\(item.count)")
                            .font(FINDRFont.bold(11))
                            .foregroundStyle(FINDRColor.brand)
                    }
                    .font(FINDRFont.regular(11))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 7, style: .continuous))
                }
            }
        }
        .padding(FINDRSpacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(FINDRColor.brandSubtle, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var preparationGuide: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.medium) {
            Text("이렇게 준비해요")
                .font(FINDRFont.bold(16))
                .kerning(-0.32)
                .foregroundStyle(FINDRColor.primaryText)

            VStack(alignment: .leading, spacing: FINDRSpacing.small) {
                ForEach(actionID.preparationSteps.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: FINDRSpacing.small) {
                        Text("\(index + 1)")
                            .font(FINDRFont.bold(11))
                            .foregroundStyle(FINDRColor.secondaryText)
                            .frame(width: 22, height: 22)
                            .background(FINDRColor.subtle, in: Circle())

                        Text(actionID.preparationSteps[index])
                            .font(FINDRFont.regular(13))
                            .kerning(-0.26)
                            .foregroundStyle(FINDRColor.primaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }

    private var portfolioUpload: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.small) {
            Text("포트폴리오 올리기")
                .font(FINDRFont.bold(16))
                .kerning(-0.32)
                .foregroundStyle(FINDRColor.primaryText)

            Button {
                isImportingFile = true
            } label: {
                HStack(spacing: FINDRSpacing.medium) {
                    FINDRIcon(name: FINDRAssetName.aPathUpload, size: 24, tint: FINDRColor.brand)
                        .frame(width: 40, height: 40)
                        .background(FINDRColor.brandSubtle, in: Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text(selectedFileName ?? "파일을 선택해 업로드하세요")
                            .font(FINDRFont.bold(13))
                            .foregroundStyle(FINDRColor.primaryText)
                            .lineLimit(1)
                        Text("PDF · PPT · 이미지, 최대 20MB")
                            .font(FINDRFont.regular(11))
                            .foregroundStyle(FINDRColor.tertiaryText)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, FINDRSpacing.medium)
                .frame(maxWidth: .infinity, minHeight: 74)
                .background(FINDRColor.subtle, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(FINDRColor.borderStrong, style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(selectedFileName.map { "선택한 파일 \($0)" } ?? "포트폴리오 파일 선택")

            HStack(spacing: FINDRSpacing.small) {
                FINDRIcon(name: FINDRAssetName.aPathLink, size: 20, tint: FINDRColor.secondaryText)
                TextField("또는 노션·깃허브 링크 붙여넣기", text: $portfolioLink)
                    .font(FINDRFont.regular(13))
                    .kerning(-0.26)
                    .foregroundStyle(FINDRColor.primaryText)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityLabel("노션 또는 깃허브 포트폴리오 링크")
            }
            .padding(.horizontal, FINDRSpacing.medium)
            .frame(height: 50)
            .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(FINDRColor.border, lineWidth: 1)
            }
        }
    }

    private var bottomCTA: some View {
        HStack(spacing: FINDRSpacing.small) {
            FINDRButton(title: "가이드 보기", kind: .outline) {
                showGuide = true
            }
            .frame(width: 116)

            FINDRButton(title: isCompleted ? "완료됐어요" : "완료했어요", action: {
                showCompletionConfirmation = true
            })
            .disabled(isCompleted)
            .opacity(isCompleted ? 0.65 : 1)
        }
        .padding(.horizontal, FINDRSpacing.screen)
        .padding(.top, FINDRSpacing.medium)
        .padding(.bottom, FINDRSpacing.small)
        .background {
            FINDRColor.surface
                .overlay(alignment: .top) { FINDRColor.divider.frame(height: 1) }
                .ignoresSafeArea(edges: .bottom)
        }
    }

    private var completionConfirmation: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { showCompletionConfirmation = false }

            VStack(spacing: FINDRSpacing.medium) {
                FINDRIcon(name: FINDRAssetName.aPathCheck, size: 24, tint: FINDRColor.brand)
                    .frame(width: 48, height: 48)
                    .background(FINDRColor.brandSubtle, in: Circle())

                VStack(spacing: FINDRSpacing.xSmall) {
                    Text(actionID.completionConfirmationTitle)
                        .font(FINDRFont.bold(16))
                        .kerning(-0.32)
                        .foregroundStyle(FINDRColor.primaryText)
                        .multilineTextAlignment(.center)

                    Text("보유 조건에 추가되고, 새로 열리는 기회를 바로 보여드려요.")
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
            .padding(FINDRSpacing.large)
            .frame(maxWidth: 320)
            .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.12), radius: 24, x: 0, y: 12)
            .padding(.horizontal, 36)
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("apath-completion-confirmation")
        }
        .zIndex(2)
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
