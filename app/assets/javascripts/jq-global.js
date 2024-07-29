import $ from "jquery";

import select2 from "select2";

export default $;

select2($);

window.jQuery = window.$ = $;

$(function() {
  const SELECT2_SELECTORS = [
    // Select2ize filters
    "body.active_admin .select_and_search select",
    // Select2ize selects in resource editing forms
    "body.active_admin form.formtastic .select.input select",
  ];

  for (const selector of SELECT2_SELECTORS) {
    $(selector).select2({
      placeholder: "n/a",
      //width: "100%",
    });
  }
});
