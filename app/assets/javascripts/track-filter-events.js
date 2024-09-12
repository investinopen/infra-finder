/**
 * Collect search & filters applied to the solutions list
 * and push to Matomo as `trackEvent`s.
 *
 * This function can be used as a submit callback on the search/filter form.
 * It's abstracted here because desktop and mobile filters are in separate <form>'s.
 *
 * @param {SubmitEvent} event
 */
export default function trackFilterEvents(event) {
  if (!(event?.target instanceof HTMLFormElement) || !_paq?.push) return;

  const formData = new FormData(event.target);

  const searchQuery = formData.get("q[name_or_provider_name_cont]");

  if (searchQuery) {
    _paq.push([
      "trackEvent",
      "Search/Filter Applied",
      "Search Query",
      searchQuery,
    ]);
  }

  // FormData is pretty difficult to parse for the filters, so just look up checked checkboxes
  const checked = [
    ...event.target.querySelectorAll("input[type='checkbox']:checked"),
  ];

  if (checked.length > 0) {
    for (const el of checked) {
      const eventName = el.dataset.eventName;
      const eventValue = el.dataset.eventValue;

      _paq.push(["trackEvent", "Search/Filter Applied", eventName, eventValue]);
    }
  }
}
