import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["selectAllToggle"];

  selectAllToggleTargetConnected(target) {
    this.updateTogglePressedState(target);
    this.bindCheckboxesClick(target);
  }

  selectAllToggleTargetDisconnected(target) {
    this.unbindCheckboxesClick(target);
  }

  selectAll(event) {
    const button = event.target;
    const checkboxes = this.getCheckboxesForToggle(button);

    if (!checkboxes?.length) return;

    const allSelected = checkboxes.every((member) => member.checked);

    // check all checkboxes in group (unless all are already checked, then uncheck all)
    for (const checkbox of checkboxes) {
      checkbox.checked = !allSelected;
    }

    this.updateTogglePressedState(button, !allSelected);
  }

  updateTogglePressedState(toggle, state) {
    // if passing `state`, set immediately and return
    if (state) {
      toggle.setAttribute("aria-pressed", state);
      return;
    }

    // otherwise set state based on state of checkboxes
    const checkboxes = this.getCheckboxesForToggle(toggle);

    let pressedState = "false";

    if (checkboxes?.length) {
      pressedState = this.getPressedStateFromGroup(checkboxes);
    }

    toggle.setAttribute("aria-pressed", pressedState);
  }

  bindCheckboxesClick(toggle) {
    const closestAccordion = toggle.closest("details");

    if (!closestAccordion) return null;

    const group = closestAccordion.querySelector(
      ".solution-filters__checkboxes"
    );

    if (!group?.childElementCount) return;

    // add listener to group rather than single inputs since
    // we only need to know whether one or more input is checked at any time
    group.addEventListener("click", (event) =>
      this.handleCheckboxGroupClick(event, toggle)
    );
  }

  unbindCheckboxesClick(toggle) {
    const closestAccordion = toggle.closest("details");

    if (!closestAccordion) return null;

    const group = closestAccordion.querySelector(
      ".solution-filters__checkboxes"
    );

    if (!group?.childElementCount) return;

    group.removeEventListener("click", (event) =>
      this.handleCheckboxGroupClick(event, toggle)
    );
  }

  // update toggle pressed state whenever a checkbox is clicked
  handleCheckboxGroupClick(event, toggle) {
    if (!(event.target instanceof HTMLInputElement)) return;
    this.updateTogglePressedState(toggle);
  }

  getCheckboxesForToggle(toggle) {
    const closestAccordion = toggle.closest("details");

    if (!closestAccordion) return null;

    return [...closestAccordion.querySelectorAll("input[type='checkbox']")];
  }

  getPressedStateFromGroup(group) {
    if (!group || !group.length) return "false";

    if (group.every((member) => member.checked)) return "true";
    if (group.some((member) => member.checked)) return "mixed";

    return "false";
  }
}
