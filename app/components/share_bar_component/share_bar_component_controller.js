import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["wrapper", "share", "copy"];
  static values = {
    /**
     * This can be a value like comparison, solution_list, solution_detail, or none
     */
    shareMode: { type: String, default: "none" },
    /**
     * This will be empty if not sharable / shareMode === "none"
     */
    shareUrl: String,
    /**
     * This is an optional URL that should be called with PUT
     * when the `shareUrl` is shared or copied.
     */
    sharedUrl: String,
  };

  get enabled() {
    return this.shareModeValue !== "none" && Boolean(this.shareUrlValue);
  }

  get disabled() {
    return !this.enabled;
  }

  get shareData() {
    const metaDescription = document.querySelector('meta[name="description"]');

    const title = document.title;
    const text = metaDescription?.content ?? undefined;

    return {
      title,
      text,
      url: this.shareUrlValue,
    };
  }

  get canShare() {
    if (this.disabled) {
      return false;
    }

    return (
      typeof navigator.canShare === "function" &&
      navigator.canShare(this.shareData)
    );
  }

  get canCopy() {
    if (this.disabled) {
      return false;
    }

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

      await this.shared("URL Shared");
    } catch (err) {
      console.error(err);
    }
  }

  async copy() {
    try {
      await navigator.clipboard.writeText(this.shareUrlValue);

      this.state.copied = true;

      await this.shared("URL Copied");
    } catch (err) {
      console.error(err);
    } finally {
      setTimeout(() => {
        this.state.copied = false;
      }, 1500);
    }
  }

  async shared(eventName) {
    if (window._paq && Array.isArray(window._paq)) {
      window._paq.push(["trackEvent", "Share", eventName, this.shareUrlValue]);
    }
    
    if (!this.sharedUrlValue) {
      return;
    }

    await fetch(this.sharedUrlValue, {
      credentials: "include",
      method: "PUT",
    });
  }

  processCopyStateChange() {
    this.copyTextEl?.classList.toggle("a-hidden", this.state.copied);
    this.copiedTextEl?.classList.toggle("a-hidden", !this.state.copied);
  }
}
