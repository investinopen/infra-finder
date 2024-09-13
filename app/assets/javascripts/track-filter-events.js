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
  if (!(event?.target instanceof HTMLFormElement) || typeof _paq !== "object" || typeof _paq?.push !== "function") return;

  const events = [];

  const formData = new FormData(event.target);

  const searchQuery = formData.get("q[name_or_provider_name_cont]");

  if (searchQuery) {
    events.push([
      "trackEvent",
      "Search/Filter Applied",
      "Search Query",
      searchQuery,
    ]);
  }

  const locationSelection = formData.get("q[country_code_eq]");

  if (locationSelection) {
    events.push([
      "trackEvent",
      "Search/Filter Applied",
      "Location",
      locationSelection,
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

      events.push(["trackEvent", "Search/Filter Applied", eventName, eventValue]);
    }
  }

  // push events all at once to _paq
  if (events.length > 0) {
    _paq.push(...events);
  }
}
