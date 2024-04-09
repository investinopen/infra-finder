import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static targets = ["wrapper", "share", "copy"];

  get currentUrl() {
    return window.location.toString();
  }

  get shareData() {
    const metaDescription = document.querySelector('meta[name="description"]');

    const title = document.title;
    const text = metaDescription?.content ?? undefined;

    return {
      title,
      text,
      url: this.currentUrl,
    };
  }

  get canShare() {
    return (
      typeof navigator.canShare === "function" &&
      navigator.canShare(this.shareData)
    );
  }

  get canCopy() {
    return (
      navigator.clipboard && typeof navigator.clipboard.writeText === "function"
    );
  }

  get copyTextEl() {
    return this.copyTarget.querySelector("[data-copy-text]");
  }

  get copiedTextEl() {
    return this.copyTarget.querySelector("[data-copied-text]");
  }

  connect() {
    const self = this;
    this.state = new Proxy(
      { copied: false },
      {
        set(state, key, value) {
          const oldValue = state[key];

          state[key] = value;
          if (oldValue !== value) {
            switch (key) {
              case "copied":
                self.processCopyStateChange();
                break;
            }
          }
          return state;
        },
      }
    );
  }

  shareTargetConnected(element) {
    element.classList.toggle("a-hidden", !this.canShare);
  }

  copyTargetConnected(element) {
    element.classList.toggle("a-hidden", this.canShare || !this.canCopy);
  }

  async share() {
    try {
      await navigator.share(this.shareData);
    } catch (err) {
      console.error(err);
    }
  }

  async copy() {
    try {
      this.state.copied = true;

      navigator.clipboard.writeText(this.currentUrl).then(() => {
        setTimeout(() => {
          this.state.copied = false;
        }, 1500);
      });
    } catch (err) {
      console.error(err);
      this.state.copied = false;
    }
  }

  processCopyStateChange() {
    this.copyTextEl?.classList.toggle("a-hidden", this.state.copied);
    this.copiedTextEl?.classList.toggle("a-hidden", !this.state.copied);
  }
}
