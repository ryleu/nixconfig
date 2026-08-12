{ pkgs, inputs, ... }:
let
  master_pkgs = import inputs.master_pkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  home.packages = with pkgs; [
    # comms
    signal-desktop

    # games
    (master_pkgs.prismlauncher.override {
      additionalLibs = [ pkgs.sdl3 ]; # for 26.3
    })

    # 3D print slicers
    prusa-slicer
    orca-slicer

    # utilities
    qbittorrent
    hugin # panoramas for URC
    kicad # pcb viewing
    obsidian # for documentation and ideas

    # media
    picard # music metadata
    audacity # music editing
  ];

  programs = {
    vesktop = {
      enable = true;
      vencord.settings = {
        themeLinks = [
          # toki ilo pi sitelen pona
          "https://gist.githubusercontent.com/ryleu/c6428cf72d75fb82ebef7538808a123e/raw/a23ee0d1e80837ada1a6289f04ea99e6a42d856e/style.css"
          # block bullshit
          "https://raw.codeberg.page/AllPurposeMat/Disblock-Origin/DisblockOrigin.theme.css"
        ];
        plugins = {
          ChatInputButtonAPI.enabled = true;
          CommandsAPI.enabled = true;
          MessageAccessoriesAPI.enabled = true;
          MessageEventsAPI.enabled = true;
          MessageUpdaterAPI.enabled = true;
          UserSettingsAPI.enabled = true;
          BadgeAPI.enabled = true;
          BetterGifAltText.enabled = true;
          BetterGifPicker.enabled = true;
          BetterRoleContext.enabled = true;
          BetterSessions = {
            enabled = true;
            backgroundCheck = false;
          };
          BetterSettings = {
            enabled = true;
            disableFade = true;
            eagerLoad = true;
            organizeMenu = true;
          };
          CallTimer.enabled = true;
          CharacterCounter.enabled = true;
          ClearURLs.enabled = true;
          ConcatenatedComponentExtractor.enabled = true;
          CopyFileContents.enabled = true;
          CopyUserURLs.enabled = true;
          CrashHandler.enabled = true;
          DisableCallIdle.enabled = true;
          DisableDeepLinks.enabled = true;
          Experiments = {
            enabled = true;
            toolbarDevMenu = false;
          };
          ExpressionCloner.enabled = true;
          FakeNitro = {
            enabled = true;
            enableStickerBypass = true;
            enableStreamQualityBypass = true;
            enableEmojiBypass = true;
            transformEmojis = true;
            transformStickers = true;
            transformCompoundSentence = false;
          };
          FixImagesQuality = {
            enabled = true;
            originalImagesInChat = false;
          };
          FixSpotifyEmbeds.enabled = true;
          FixYoutubeEmbeds.enabled = true;
          ForceOwnerCrown.enabled = true;
          FullUserInChatbox.enabled = true;
          GifPaste.enabled = true;
          KeepCurrentChannel.enabled = true;
          MemberCount = {
            enabled = true;
            memberList = true;
            toolTip = true;
            voiceActivity = true;
          };
          MentionAvatars = {
            enabled = true;
            showAtSymbol = true;
          };
          MessageLatency = {
            enabled = true;
            latency = 2;
            detectDiscordKotlin = true;
            showMillis = false;
            ignoreSelf = false;
          };
          MessageLinkEmbeds.enabled = true;
          MessageLogger = {
            enabled = true;
            collapseDeleted = false;
            deleteStyle = "text";
            ignoreBots = false;
            ignoreSelf = false;
            ignoreUsers = "";
            ignoreChannels = "";
            ignoreGuilds = "";
            logEdits = true;
            logDeletes = true;
          };
          MusicRichPresence = {
            enabled = true;
            scrobblerBackend = "listenbrainz";
            shareUsername = true;
            clickableLinks = true;
            hideWithSpotify = false;
            hideWithActivity = false;
            statusName = "no album";
            statusDisplayType = "track";
            nameFormat = "album";
            useListeningStatus = true;
            missingArt = "logo";
            showLogo = true;
            showAlbumCover = true;
            username = "ryleu";
          };
          MutualGroupDMs.enabled = true;
          NoDevtoolsWarning.enabled = true;
          NoF1.enabled = true;
          NoMaskedUrlPaste.enabled = true;
          NoMiddleClickPaste.enabled = true;
          NoOnboardingDelay.enabled = true;
          NoProfileThemes.enabled = true;
          NoTrack = {
            enabled = true;
            disableAnalytics = true;
          };
          NoTypingAnimation.enabled = true;
          NoUnblockToJump.enabled = true;
          PermissionFreeWill = {
            enabled = true;
            lockout = false;
            onboarding = true;
          };
          PermissionsViewer.enabled = true;
          RevealAllSpoilers.enabled = true;
          Settings = {
            enabled = true;
            settingsLocation = "aboveNitro";
            includeVencordInfoWhenCopying = true;
          };
          ShowHiddenChannels = {
            enabled = true;
            showMode = 0;
            hideUnreads = true;
          };
          SilentTyping = {
            enabled = true;
            isEnabled = true;
            showIcon = false;
          };
          SupportHelper.enabled = true;
          UserMessagesPronouns = {
            enabled = true;
            showSelf = true;
            pronounsFormat = "LOWERCASE";
          };
          ValidReply.enabled = true;
          ValidUser.enabled = true;
          VolumeBooster.enabled = true;
          WebContextMenus.enabled = true;
          WebKeybinds.enabled = true;
          WebScreenShareFixes.enabled = true;
          WhoReacted.enabled = true;
          YoutubeAdblock.enabled = true;
        };
      };
    };
  };
}
