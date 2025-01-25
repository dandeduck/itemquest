// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

module.exports = { 
    content: ["./src/**/*.{html,gleam}"],
    darkMode: 'selector',
    theme: {
        colors: {
            primary: "var(--primary)",
            "primary-sat": "var(--primary-sat)",
            "font-color": "var(--font-color)",
            "bg-color": "var(--bg-color)",
            success: "var(--success)",
            secondary: "var(--secondary)",
        },
        fontFamily: {
            sans: ["Bender"],
        },
    },
    plugins: [require("@tailwindcss/forms")],
};
