/**
 * @param {string} url
 * @returns {Promise<boolean>} Wether or not a stream was returned
 */
async function fetchStream(url) {
    const response = await fetch(url, {
        method: "get",
        headers: {
            Accept: "text/vnd.turbo-stream.html",
        },
    });

    if (response.status !== 200) {
        return false;
    }

    const html = await response.text();
    Turbo.renderStreamMessage(html);
    return true;
}

/**
 * @param {string} elementId
 * @param {(value: string) => string} getSuggestionsUrl
 * @returns {Promise<boolean>}
 */
function addAutocompleteSuggestions(elementId, getSuggestionsUrl) {
    document.getElementById(elementId)?.addEventListener("keyup", (event) => {
        const value = event.target.value;
        const prevValue = event.target.getAttribute("data-prev-value");

        if (prevValue === value) {
            return;
        }

        event.target.setAttribute("data-prev-value", value);
        const url = getSuggestionsUrl(value);

        return fetchStream(url);
    });
}

export default { fetchStream, addAutocompleteSuggestions };
