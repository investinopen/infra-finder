import { Controller } from "@hotwired/stimulus";

const WRAPPER_SELECTOR = ".form-field-wrapper, .conditional-field-wrapper";

export default class extends Controller {
  static targets = ["consent", "submit"];

  static values = {
    dirty: Boolean,
  };

  connect() {
    this.toggleSubmit();

    this.dirty = this.dirtyValue;
    this.saving = false;
    this.queued = false;
    this.draftMode = null;
    this.trackedWrapper = null;
    this.validatingOnBlur = false;

    this.element.addEventListener("invalid", this.onInvalid, true);
  }

  disconnect() {
    this.element.removeEventListener("invalid", this.onInvalid, true);
  }

  onInvalid = (event) => {
    if (this.validatingOnBlur) return;
    if (this.reporting) return;

    this.reporting = true;

    const first = event.target;

    setTimeout(() => {
      this.reporting = false;
      this.reveal(first);
    });
  };

  reveal(field) {
    if (field.closest("[hidden]")) return;

    field.scrollIntoView({ block: "center", behavior: "smooth" });
    field.focus({ preventScroll: true });
  }

  toggleSubmit() {
    if (!this.hasSubmitTarget || !this.hasConsentTarget) return;

    this.submitTarget.disabled = !this.consentTarget.checked;
  }

  markDirty() {
    this.dirty = true;
  }

  confirmExit(event) {
    if (!this.dirty) return;

    event.preventDefault();
    event.returnValue = "";
  }

  /**
   * A wrapper can own several controls — a checkbox group, the logo field's file/link
   * radios — so focus is tracked per wrapper rather than per control.
   */
  fieldFocus(event) {
    const wrapper = event.target.closest(WRAPPER_SELECTOR);

    if (!wrapper || wrapper === this.trackedWrapper) return;

    this.trackedWrapper = wrapper;
    this.trackedSnapshot = this.snapshot(wrapper);
  }

  fieldBlur(event) {
    const wrapper = this.trackedWrapper;

    if (!wrapper || event.target.closest(WRAPPER_SELECTOR) !== wrapper) return;
    if (wrapper.contains(event.relatedTarget)) return;

    this.trackedWrapper = null;

    if (event.relatedTarget?.type === "submit") return;
    if (wrapper.closest("[hidden]")) return;

    if (this.snapshot(wrapper) === this.trackedSnapshot) return;

    // Render html validation error for user to fix; don't save
    if (!this.validate(wrapper)) return;

    this.autosave();
  }

  controlsIn(wrapper) {
    return [...wrapper.querySelectorAll("input, select, textarea")].filter(
      (el) => el.closest(WRAPPER_SELECTOR) === wrapper,
    );
  }

  snapshot(wrapper) {
    return this.controlsIn(wrapper)
      .map((el) =>
        el.type === "checkbox" || el.type === "radio" ? `${el.checked}` : el.value,
      )
      .join("\u0000");
  }

  validate(wrapper) {
    this.validatingOnBlur = true;

    // Every control is checked rather than short-circuiting on the first failure, so a
    // group reports all of its messages the way a real submit does.
    const results = this.controlsIn(wrapper)
      .filter((el) => el.willValidate)
      .map((el) => el.checkValidity());

    this.validatingOnBlur = false;

    return results.every(Boolean);
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
    // A blur can land while the previous save is still in flight; queue it
    if (this.saving) {
      this.queued = true;

      return;
    }

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

    if (this.queued) {
      this.queued = false;

      this.autosave();
    }
  }
}
