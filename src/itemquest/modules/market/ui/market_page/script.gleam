import lustre/attribute
import lustre/element/html
import lustre/element.{type Element}

// todo: move to a .js file or compile gleam in the future
pub fn html() -> Element(a) {
  html.script(
    [attribute.type_("module")],
    "
        const limit = 25
        let offset = 0
        let fetching = false

        window.addEventListener('scroll', () => {
            const entriesUrl = new URL(window.location.href)
            entriesUrl.pathname += '/entries'

            window.requestAnimationFrame(async () => {
                if (!fetching && window.scrollY + window.innerHeight >= document.body.offsetHeight - 500) {
                    fetching = true
                    offset += limit
                    entriesUrl.searchParams.set('offset', offset)

                    const success = await fetchStream(entriesUrl.toString())
                    if (success) {
                        fetching = false
                    }
                }
            }, 0)
        })

        let prevSearch = ''

        document.getElementById('search_input').addEventListener('keyup', event => {
            const value = event.target.value

            if (prevSearch === value) {
                return;
            }

            prevSearch = value
            const searchUrl = new URL(window.location.href)

            searchUrl.pathname += '/entries/search'
            searchUrl.search = ''
            searchUrl.searchParams.append('search', value)

            fetchStream(searchUrl.toString())
        })

        async function fetchStream(url) {
            const response = await fetch(url, {
                method: 'get', 
                headers: {
                    'Accept': 'text/vnd.turbo-stream.html',
                }
            })

            if (response.status !== 200) {
                return false
            }

            const html = await response.text();
            Turbo.renderStreamMessage(html)
            return true
        }
    ",
  )
}
