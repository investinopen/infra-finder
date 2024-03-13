const defaultTheme = require("tailwindcss/defaultTheme");
const { screens } = require("./tailwind-helper");

const maxWidth = {
  base: "84.5rem",
  narrow: "74rem",
};

const colors = {
  brand: {
    mint: "hsla(162, 78%, 73%, 1)",
    blue: "hsla(208, 100%, 84%, 1)",
    yellow: "hsla(51, 100%, 55%, 1)",
  },
  neutral: {
    70: "hsla(0, 0%, 38%, 1)",
    40: "hsla(0, 0%, 75%, 1)",
    30: "hsla(0, 0%, 85%, 1)",
    20: "hsla(0, 0%, 92%, 1)",
    10: "hsla(0, 0%, 97%, 1)",
  },
  black: "hsla(0, 0%, 0%, 1)",
  white: "hsla(0, 0%, 100%, 1)",
  light: "var(--color-light)",
};

const headerProps = {
  lineHeight: "normal",
  letterSpacing: "-0.0313rem",
  fontWeight: 700,
};

const bodyProps = {
  lineHeight: "normal",
  letterSpacing: "0rem",
  fontWeight: 500,
};

/* In the interest of time & reduced complexity,
use tailwind's 'text-' classes instead of the 't-' pattern. */
const fontSize = {
  h1: ["2.875rem", headerProps],
  h2: ["2.25rem", headerProps],
  h3: ["1.625rem", headerProps],
  h4: ["1.5rem", headerProps],
  h5: ["1.25rem", headerProps],
  h6: ["1.125rem", headerProps],
  base: ["1.0625rem", { ...bodyProps, letterSpacing: "0.0156rem" }],
  sm: ["1rem", bodyProps],
  xs: ["0.9375rem", bodyProps],
  xxs: ["0.875rem", bodyProps],
  terms: ["0.8125rem", bodyProps],
  label: ["1rem", { headerProps, letterSpacing: "0rem" }],
};

fontFamily = {
  body: ["Inter", ...defaultTheme.fontFamily.sans],
  header: ["BW Gradual", ...defaultTheme.fontFamily.sans],
};

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/assets/stylesheets/**/*.css",
    "./app/components/**/*.{erb,rb,haml,html,slim}",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  theme: {
    extend: {
      colors,
      fontSize,
      fontFamily,
      maxWidth,
      screens,
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
