import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["accordion"];

  accordionTargetConnected(element) {
    const checkboxes = [...element.querySelectorAll("input[type='checkbox']")];

    // set <details> to default open state if has any checked checkboxes
    if (checkboxes.some((member) => member.checked)) element.open = true;
  }
}
