import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static targets = ["wrapper"];

  initialize() {
    // Hide the share bar if Browser share functionality is disabled
    if (!navigator.canShare) {
      this.wrapperTarget.classList.add("a-hidden");
    }
  }

  async share() {
    // Get share data from meta tags
    const metaDescription = document.querySelector('meta[name="description"]');

    const title = document.title;
    const text = metaDescription?.content ?? "";
    const url = window.location.href;

    try {
      await navigator.share({
        title,
        text,
        url,
      });
      console.info("Shared successfully");
    } catch (err) {
      console.error(`Share error: ${err}`);
    }
  }
}