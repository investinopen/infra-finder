import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["mode", "filePanel", "urlPanel", "fileInput", "urlInput", "filename"];

  connect() {
    this.update();
  }

  update() {
    const fileActive = this.selectedMode() === "file";

    this.filePanelTarget.hidden = !fileActive;
    this.urlPanelTarget.hidden = fileActive;

    // Only the active input submits, so logo / logo_remote_url never conflict.
    this.fileInputTarget.disabled = !fileActive;
    this.urlInputTarget.disabled = fileActive;
  }

  showFilename() {
    if (!this.hasFilenameTarget) return;

    const [file] = this.fileInputTarget.files;
    this.filenameTarget.textContent = file ? file.name : "";
  }

  selectedMode() {
    return this.modeTargets.find((radio) => radio.checked)?.value ?? "file";
  }
}
