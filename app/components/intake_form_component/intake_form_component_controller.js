import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["consent", "submit"];

  static values = {
    autosaveInterval: { type: Number, default: 2 * 60 * 1000 },
  };

  connect() {
    this.toggleSubmit();

    this.dirty = false;
    this.saving = false;
    this.draftMode = null;
    this.autosaveTimer = setInterval(
      () => this.autosave(),
      this.autosaveIntervalValue,
    );
  }

  disconnect() {
    clearInterval(this.autosaveTimer);
  }

  toggleSubmit() {
    if (!this.hasSubmitTarget || !this.hasConsentTarget) return;

    this.submitTarget.disabled = !this.consentTarget.checked;
  }

  markDirty() {
    this.dirty = true;
  }

  autosave() {
    if (!this.dirty) return;

    this.submitDraft("auto");
  }

  /**
   * Entry point for the `intake:save` event from
   * IntakeSaveDraftButtonComponent.
   */
  save() {
    this.submitDraft("manual");
  }

  submitDraft(mode) {
    if (this.saving) return;

    this.draftMode = mode;

    const submitter = document.createElement("button");

    submitter.type = "submit";
    submitter.name = "skip_validations";
    submitter.value = "true";
    submitter.formNoValidate = true;
    submitter.hidden = true;

    this.element.appendChild(submitter);
    this.element.requestSubmit(submitter);
    submitter.remove();
  }

  saveStart() {
    this.saving = true;
    this.dirty = false;

    if (!this.draftMode) return;

    this.dispatch("saving", {
      prefix: "intake",
      target: window,
      detail: { auto: this.draftMode === "auto" },
    });
  }

  saveEnd({ detail: { success } }) {
    this.saving = false;

    if (!success) this.dirty = true;

    if (this.draftMode) {
      this.dispatch(success ? "saved" : "save-failed", {
        prefix: "intake",
        target: window,
      });
    }

    this.draftMode = null;
  }
}
