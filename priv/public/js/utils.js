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

export default { fetchStream };
