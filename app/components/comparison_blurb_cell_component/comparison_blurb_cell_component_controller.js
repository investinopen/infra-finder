import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["body", "readMore"];

  get moreText() {
    return this.readMoreTarget?.querySelector("[data-more-text]");
  }

  get lessText() {
    return this.readMoreTarget?.querySelector("[data-less-text]");
  }

  bodyTargetConnected(target) {
    const link = this.readMoreTarget;

    const isClamped = target.scrollHeight > target.clientHeight;

    if (!isClamped || !link) return;

    // Set the initial pressed state
    this.updateTogglePressedState(link);
    link.classList.remove("hidden");
  }

  readMore() {
    const body = this.bodyTarget;
    const link = this.readMoreTarget;

    if (!body || !link) return;

    const state = link.getAttribute("aria-pressed") === "true" ? false : true;

    // Toggle the pressed state and line clamp
    this.updateTogglePressedState(link, state);
    body.classList.toggle("line-clamp-6");

    // Scroll to the top of the cell on close
    if (state === false) {
      const top = body.offsetTop - document.body.scrollTop;

      window.scrollTo({
        top,
      });
    }
  }

  updateTogglePressedState(toggle, state = false) {
    toggle.setAttribute("aria-pressed", state);
    this.moreText?.classList.toggle("a-hidden", state);
    this.lessText?.classList.toggle("a-hidden", !state);
  }
}
