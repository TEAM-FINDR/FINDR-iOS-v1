import PhotosUI
import SwiftUI
import UIKit

struct MyProfileEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var profile: FINDROnboardingProfile
    let onSave: () -> Void

    @State private var draft: FINDROnboardingProfile
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var pendingPhotoData: Data?
    @State private var isLoadingPhoto = false
    @State private var showPhotoError = false
    @State private var photoErrorMessage = ""

    init(profile: Binding<FINDROnboardingProfile>, onSave: @escaping () -> Void) {
        _profile = profile
        _draft = State(initialValue: profile.wrappedValue)
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 0) {
            FINDRBackNavigationHeader(title: "프로필 수정", onBack: { dismiss() })

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: FINDRSpacing.section) {
                    photoPicker
                    FINDRProfileSetupTitleView(title: "기본 정보를\n수정해주세요", subtitle: "프로필 정보는 맞춤 기회를 찾는 데 사용돼요.")
                    personalInformation
                    statusSelection
                    if !draft.isValidForSaving {
                        Text(validationMessage)
                            .font(FINDRFont.regular(12))
                            .foregroundStyle(FINDRColor.danger)
                            .accessibilityLabel(validationMessage)
                    }
                }
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.top, FINDRSpacing.medium)
                .padding(.bottom, FINDRSpacing.large)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(FINDRColor.canvas.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            FINDRButton(title: "저장", action: save)
                .disabled(!draft.isValidForSaving || isLoadingPhoto)
                .opacity(draft.isValidForSaving && !isLoadingPhoto ? 1 : 0.45)
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.top, FINDRSpacing.small)
                .padding(.bottom, FINDRSpacing.small)
                .background(FINDRColor.canvas)
        }
        .onChange(of: selectedPhoto) { _, photo in
            guard let photo else { return }
            Task { await loadPhoto(photo) }
        }
        .alert("사진을 처리하지 못했어요", isPresented: $showPhotoError) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(photoErrorMessage)
        }
    }

    private var photoPicker: some View {
        VStack(spacing: FINDRSpacing.small) {
            FINDRProfileAvatar(
                photoPath: draft.profilePhotoPath,
                overridePhoto: pendingPhotoData.flatMap(UIImage.init(data:)),
                size: 84
            )
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                HStack(spacing: 5) {
                    FINDRIcon(name: FINDRAssetName.profile, size: 14, tint: FINDRColor.brand)
                    Text(isLoadingPhoto ? "사진 불러오는 중" : "사진 변경")
                        .font(FINDRFont.medium(12))
                        .foregroundStyle(FINDRColor.brand)
                }
            }
            .disabled(isLoadingPhoto)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, FINDRSpacing.small)
    }

    private var personalInformation: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.large) {
            Text("기본 정보")
                .font(FINDRFont.bold(16))
                .foregroundStyle(FINDRColor.primaryText)

            FINDRProfileSetupInputFieldView(
                title: "이름",
                helper: "기회 추천에 표시할 이름이에요",
                text: $draft.name
            )
            FINDRProfileSetupInputFieldView(
                title: "출생연도",
                helper: "만 나이 계산에만 사용돼요",
                text: $draft.birthYear,
                keyboard: .numberPad
            )
            FINDRProfileSetupInputFieldView(
                title: "거주 지역",
                helper: "지역 조건이 있는 기회에 사용돼요",
                text: $draft.region
            )
        }
        .padding(FINDRSpacing.large)
        .background(FINDRColor.surface, in: RoundedRectangle(cornerRadius: FINDRRadius.card, style: .continuous))
    }

    private var statusSelection: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.medium) {
            Text("현재 상태")
                .font(FINDRFont.bold(16))
                .foregroundStyle(FINDRColor.primaryText)
            FINDRProfileChipFlowLayout(horizontalSpacing: FINDRSpacing.small, verticalSpacing: FINDRSpacing.small) {
                ForEach(FINDROnboardingProfileOptions.statuses, id: \.self) { status in
                    FINDRPill(title: status, isSelected: draft.status == status) {
                        draft.status = status
                    }
                }
            }
        }
    }

    private var validationMessage: String {
        if draft.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "이름을 입력해주세요."
        }
        if !draft.canContinue(on: 1) {
            return "출생연도와 거주 지역을 확인해주세요."
        }
        if draft.interests.isEmpty || draft.interests.count > 5 || draft.opportunityTypes.isEmpty {
            return "관심 분야와 기회 종류를 확인해주세요."
        }
        return "현재 상태를 선택해주세요."
    }

    @MainActor
    private func loadPhoto(_ photo: PhotosPickerItem) async {
        isLoadingPhoto = true
        pendingPhotoData = nil
        defer { isLoadingPhoto = false }
        do {
            guard let data = try await photo.loadTransferable(type: Data.self), UIImage(data: data) != nil else {
                throw PhotoError.invalidImage
            }
            pendingPhotoData = data
        } catch {
            photoErrorMessage = "다른 사진을 선택한 뒤 다시 시도해주세요."
            showPhotoError = true
        }
    }

    private func save() {
        guard draft.isValidForSaving else { return }
        var updatedProfile = draft
        if let pendingPhotoData {
            guard let photoPath = FINDRProfileStore.saveProfilePhoto(pendingPhotoData) else {
                photoErrorMessage = "사진을 저장하지 못했어요. 다시 시도해주세요."
                showPhotoError = true
                return
            }
            updatedProfile.profilePhotoPath = photoPath
        }
        profile = updatedProfile
        FINDRProfileStore.save(updatedProfile)
        onSave()
        dismiss()
    }

    private enum PhotoError: Error {
        case invalidImage
    }
}

struct FINDRProfileAvatar: View {
    let photoPath: String?
    var overridePhoto: UIImage? = nil
    var size: CGFloat = 60

    var body: some View {
        Circle()
            .fill(LinearGradient(colors: [Color(hex: 0x7DA5FF), Color(hex: 0x2B62E9)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: size, height: size)
            .overlay {
                if let image = overridePhoto ?? savedPhoto {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                } else {
                    FINDRIcon(name: FINDRAssetName.profile, size: size * 0.5, tint: .white)
                }
            }
            .accessibilityLabel("프로필 사진")
    }

    private var savedPhoto: UIImage? {
        guard let url = FINDRProfileStore.profilePhotoURL(for: photoPath) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
}
