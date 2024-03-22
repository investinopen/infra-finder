import { Controller } from "@hotwired/stimulus";
import Headroom from "headroom.js";

export default class extends Controller {
  static targets = ["sidebar"];

  initialize() {
    const el = this.sidebarTarget;

    if (!el) return;

    const boundary = el.getBoundingClientRect();

    const options = {
      offset: Math.ceil(boundary.top) ?? 202,
      classes: {
        // when element is initialised
        initial: "solution-filters--headroom",
        // when scrolling up
        pinned: "solution-filters--pinned",
        // when scrolling down
        unpinned: "solution-filters--unpinned",
        // when above offset
        top: "solution-filters--top",
        // when below offset
        notTop: "solution-filters--not-top",
        // when at bottom of scroll area
        bottom: "solution-filters--bottom",
        // when not at bottom of scroll area
        notBottom: "solution-filters--not-bottom",
        // when frozen method has been called
        frozen: "solution-filters--frozen",
      },
    };

    // construct an instance of Headroom, passing the element
    var headroom = new Headroom(el, options);
    // initialise
    headroom.init();
  }
}
