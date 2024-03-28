import { Controller } from "@hotwired/stimulus";
import Headroom from "headroom.js";

export default class extends Controller {
  static targets = ["wrapper"];

  initialize() {
    const el = this.wrapperTarget;
    const parent = document.getElementById("comparison_component_wrapper");

    if (!el && !parent) return;

    const bodyBoundary = document.body.getBoundingClientRect();

    const elBoundary = el.getBoundingClientRect();

    const offset = Math.ceil(
      elBoundary.top - elBoundary.height * 1.5 - bodyBoundary.top
    );

    const bodyWidth = bodyBoundary.width;

    const className = "comparison-sticky-header";

    const options = {
      offset,
      // If the width is smaller than 2100,
      // use the comparison wrapper as the scroll target
      ...(bodyWidth <= 2100 ? { scroller: parent } : {}),
      classes: {
        initial: `${className}--is-initial`,
        pinned: `${className}--is-pinned`,
        unpinned: `${className}--is-unpinned`,
        top: `${className}--is-top`,
        notTop: `${className}--not-top`,
        bottom: `${className}--is-bottom`,
        notBottom: `${className}--is-not-bottom`,
        frozen: `${className}--is-frozen`,
      },
    };

    // construct an instance of Headroom, passing the element
    var headroom = new Headroom(el, options);
    // initialise
    headroom.init();
  }
}
