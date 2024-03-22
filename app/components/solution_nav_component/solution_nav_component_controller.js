import { Controller } from "@hotwired/stimulus";
import Headroom from "headroom.js";

export default class extends Controller {
  static targets = ["nav"];

  initialize() {
    const el = this.navTarget;

    if (!el) return;

    const boundary = el.getBoundingClientRect();

    const options = {
      offset: Math.ceil(boundary.top) ?? 560,
      classes: {
        // when below offset
        notTop: "solution-nav--not-top",
      },
    };

    // construct an instance of Headroom, passing the element
    var headroom = new Headroom(el, options);
    // initialise
    headroom.init();
  }
}
