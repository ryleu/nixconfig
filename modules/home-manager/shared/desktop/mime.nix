{ ... }:
let
  browser = "zen-twilight.desktop";
  videoPlayer = "mpv.desktop";
  audioPlayer = "mpv.desktop";
  imageViewer = "imv.desktop";
  textEditor = "nvim.desktop";
  fileManager = "yazi.desktop";

  pdfViewer = "org.pwmt.zathura-pdf-mupdf.desktop";
  psViewer = "org.pwmt.zathura-ps.desktop";
  djvuViewer = "org.pwmt.zathura-djvu.desktop";
  cbViewer = "org.pwmt.zathura-cb.desktop";

  writer = "writer.desktop";
  calc = "calc.desktop";
  impress = "impress.desktop";

  forAll = mime: app: builtins.listToAttrs (map (m: { name = m; value = app; }) mime);
in
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      # browser / web protocols
      forAll [
        "text/html"
        "application/xhtml+xml"
        "application/xml"
        "text/xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
        "x-scheme-handler/ftp"
        "x-scheme-handler/chrome"
        "application/x-extension-htm"
        "application/x-extension-html"
        "application/x-extension-shtml"
        "application/x-extension-xhtml"
        "application/x-extension-xht"
      ] browser
      # video
      // forAll [
        "video/mp4"
        "video/x-matroska"
        "video/webm"
        "video/quicktime"
        "video/x-msvideo"
        "video/mpeg"
        "video/x-flv"
        "video/ogg"
        "video/3gpp"
        "video/3gpp2"
        "video/x-ms-wmv"
        "video/x-m4v"
        "application/x-matroska"
      ] videoPlayer
      # audio
      // forAll [
        "audio/mpeg"
        "audio/mp3"
        "audio/mp4"
        "audio/flac"
        "audio/ogg"
        "audio/x-vorbis+ogg"
        "audio/wav"
        "audio/x-wav"
        "audio/aac"
        "audio/x-m4a"
        "audio/opus"
        "audio/webm"
        "application/ogg"
        "audio/x-mpegurl"
        "application/x-cue"
      ] audioPlayer
      # images
      // forAll [
        "image/png"
        "image/jpeg"
        "image/gif"
        "image/webp"
        "image/bmp"
        "image/tiff"
        "image/x-tga"
        "image/x-portable-pixmap"
        "image/x-portable-bitmap"
        "image/x-portable-graymap"
        "image/heif"
        "image/heic"
        "image/avif"
        "image/jxl"
        "image/svg+xml"
      ] imageViewer
      # text / code
      // forAll [
        "text/plain"
        "text/markdown"
        "text/x-markdown"
        "text/x-shellscript"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
        "text/x-csrc"
        "text/x-chdr"
        "text/x-c++src"
        "text/x-c++hdr"
        "text/x-python"
        "text/x-script.python"
        "application/x-python-code"
        "text/x-java"
        "text/javascript"
        "application/javascript"
        "application/json"
        "application/toml"
        "application/x-yaml"
        "text/x-yaml"
        "text/x-rust"
        "text/x-go"
        "text/x-lua"
        "text/x-nix"
        "text/css"
        "text/x-makefile"
        "text/x-cmake"
        "text/x-dockerfile"
      ] textEditor
      # PDF / ebook
      // forAll [
        "application/pdf"
        "application/x-pdf"
      ] pdfViewer
      // forAll [
        "application/postscript"
        "application/eps"
        "image/eps"
        "image/x-eps"
      ] psViewer
      // forAll [
        "image/vnd.djvu"
        "image/vnd.djvu+multipage"
        "image/x-djvu"
      ] djvuViewer
      // forAll [
        "application/x-cbz"
        "application/x-cbr"
        "application/x-cb7"
        "application/x-cbt"
      ] cbViewer
      # office documents
      // forAll [
        "application/msword"
        "application/rtf"
        "application/vnd.oasis.opendocument.text"
        "application/vnd.oasis.opendocument.text-template"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
      ] writer
      // forAll [
        "application/vnd.ms-excel"
        "application/vnd.oasis.opendocument.spreadsheet"
        "application/vnd.oasis.opendocument.spreadsheet-template"
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
        "text/csv"
        "text/tab-separated-values"
      ] calc
      // forAll [
        "application/vnd.ms-powerpoint"
        "application/vnd.oasis.opendocument.presentation"
        "application/vnd.oasis.opendocument.presentation-template"
        "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        "application/vnd.openxmlformats-officedocument.presentationml.template"
        "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
      ] impress
      # file manager
      // forAll [
        "inode/directory"
      ] fileManager;
  };
}
