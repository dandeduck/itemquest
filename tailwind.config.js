// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

module.exports = {
    content: ["./src/**/*.{html,gleam}"],
    theme: {
        extend: {
            colors: {
                red: "#F44545",
                gray: "#BEB2A9",
                white: "#E2DED0",
                black: "#1C343F",
            },
        },
    },
    plugins: [require("@tailwindcss/forms")],
};
