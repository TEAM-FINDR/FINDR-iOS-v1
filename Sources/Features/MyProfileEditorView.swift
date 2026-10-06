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
    @State private var isSaveConfirmationVisible = false

    init(profile: Binding<FINDROnboardingProfile>, onSave: @escaping () -> Void) {
        _profile = profile
        _draft = State(initialValue: profile.wrappedValue)
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 0) {
            FINDRBackNavigationHeader(title: "프로필 수정", onBack: { dismiss() })

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: FINDRSpacing.large) {
                    photoPicker
                    personalInformation
                    Text("현재 상태")
                        .font(FINDRFont.medium(12))
                        .foregroundStyle(FINDRColor.secondaryText)
                        .frame(height: 17, alignment: .leading)
                    statusOptions
                    if !draft.isValidForSaving {
                        Text(validationMessage)
                            .font(FINDRFont.regular(12))
                            .foregroundStyle(FINDRColor.danger)
                            .accessibilityLabel(validationMessage)
                    }
                }
                .padding(.horizontal, FINDRSpacing.screen)
                .padding(.top, FINDRSpacing.small)
                .padding(.bottom, FINDRSpacing.large)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(FINDRColor.surface.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            FINDRBottomCTA(
                title: "저장하기",
                isEnabled: draft.isValidForSaving && !isLoadingPhoto,
                action: save
            )
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
        .overlay {
            if isSaveConfirmationVisible {
                MyProfileSaveConfirmationView {
                    isSaveConfirmationVisible = false
                    dismiss()
                }
                    .transition(.opacity)
                    .zIndex(2)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isSaveConfirmationVisible)
    }

    private var photoPicker: some View {
        VStack(spacing: FINDRSpacing.small) {
            FINDRProfileAvatar(
                photoPath: draft.profilePhotoPath,
                overridePhoto: pendingPhotoData.flatMap(UIImage.init(data:)),
                size: 72
            )
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Text(isLoadingPhoto ? "사진 불러오는 중" : "사진 변경")
                    .font(FINDRFont.bold(12))
                    .foregroundStyle(FINDRColor.brand)
                    .frame(height: 17)
            }
            .disabled(isLoadingPhoto)
        }
        .frame(maxWidth: .infinity)
    }

    private var personalInformation: some View {
        VStack(alignment: .leading, spacing: FINDRSpacing.large) {
            FINDRProfileSetupInputFieldView(
                title: "이름",
                text: $draft.name
            )
            FINDRProfileSetupInputFieldView(
                title: "출생연도",
                text: $draft.birthYear,
                keyboard: .numberPad
            )
            FINDRProfileSetupInputFieldView(
                title: "거주 지역",
                text: $draft.region
            )
        }
    }

    private var statusOptions: some View {
        FINDRProfileChipFlowLayout(horizontalSpacing: FINDRSpacing.small, verticalSpacing: FINDRSpacing.small) {
            ForEach(FINDROnboardingProfileOptions.myProfileStatuses, id: \.self) { status in
                FINDRPill(title: status, isSelected: draft.status == status) {
                    draft.status = status
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
        isSaveConfirmationVisible = true
    }

    private enum PhotoError: Error {
        case invalidImage
    }
}

struct FINDRProfileAvatar: View {
    let photoPath: String?
    var overridePhoto: UIImage? = nil
    var size: CGFloat = 60
    var gradientStart = Color(hex: 0xA8C2FF)
    var gradientEnd = Color(hex: 0x2B61E8)

    var body: some View {
        Circle()
            .fill(LinearGradient(stops: [
                .init(color: gradientStart, location: 0),
                .init(color: gradientEnd, location: 0.71429)
            ], startPoint: .topLeading, endPoint: .bottomTrailing))
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
