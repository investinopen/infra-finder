import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

export default class extends Controller {
  static values = {
    maxItems: Number,
    placeholder: String,
    maxItemsPlaceholder: String,
    description: String,
    required: Boolean,
  };

  connect() {
    this.select = new TomSelect(this.element, {
      plugins: { remove_button: { tabindex: 0 } },
      maxItems:
        this.hasMaxItemsValue && this.maxItemsValue > 0
          ? this.maxItemsValue
          : null,
      placeholder: this.hasPlaceholderValue ? this.placeholderValue : undefined,
      maxOptions: null,
      hideSelected: true,
      closeAfterSelect: true,
      hidePlaceholder: false,
    });

    // Skip default TomSelect active item behavior and replace with remove click
    this.select.setActiveItem = () => {};
    this.select.control.addEventListener("keydown", this.onRemoveKeydown);

    if (this.hasDescriptionValue) {
      this.select.control.dataset.description = this.descriptionValue;
    }

    // TomSelect carries `aria-labelledby` over only from a `label[for]`, which these
    // fields don't use, and never carries `aria-describedby`.
    for (const attribute of ["aria-labelledby", "aria-describedby"]) {
      const value = this.element.getAttribute(attribute);
      if (value) this.select.focus_node.setAttribute(attribute, value);
    }

    if (this.hasMaxItemsPlaceholderValue && this.maxItemsValue > 0) {
      this.select.on("item_add", this.refreshPlaceholder);
      this.select.on("item_remove", this.refreshPlaceholder);
      this.refreshPlaceholder();
    }

    if (this.requiredValue) {
      this.select.on("item_add", this.refreshValidity);
      this.select.on("item_remove", this.refreshValidity);
      this.refreshValidity();
    }
  }

  disconnect() {
    this.select?.control?.removeEventListener("keydown", this.onRemoveKeydown);
    this.select?.destroy();
  }

  refreshPlaceholder = () => {
    const full = this.select.items.length >= this.maxItemsValue;
    const placeholder = full ? this.maxItemsPlaceholderValue : this.placeholderValue;
    this.select.settings.placeholder = placeholder;
    this.select.control_input.setAttribute("placeholder", placeholder);
  };

  // The select TomSelect replaces is hidden, so `required` on it would block submission
  // with no focusable control to report against. The visible combobox carries it instead.
  refreshValidity = () => {
    this.select.focus_node.setCustomValidity(
      this.select.items.length ? "" : "Please select at least one option.",
    );
  };

  onRemoveKeydown = (event) => {
    if (event.key !== "Enter" && event.key !== " ") return;
    const remove = event.target.closest(".remove");
    if (!remove) return;
    event.preventDefault();
    remove.click();
  };
}
