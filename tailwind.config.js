const defaultTheme = require("tailwindcss/defaultTheme");
const { screens: baseScreens, fluidScaleRem } = require("./tailwind/helper");
const { pxToRem } = require("@castiron/style-mixins/dist/base");

const maxWidth = {
  base: "84.5rem",
  narrow: "74rem",
  text: "52.1875rem",
};

const colors = {
  brand: {
    mint: "hsla(162, 78%, 73%, 1)",
    "mint-dark": "hsla(162, 78%, 60%, 1)",
    "mint-tint": "hsla(155, 92%, 85%, 1)",
    blue: "hsla(208, 100%, 84%, 1)",
    "blue-tint": "hsla(208, 100%, 84%, .7)",
    yellow: "hsla(51, 100%, 55%, 1)",
    "yellow-tint": "hsla(45, 94%, 80%, 1)",
    orange: "hsla(19, 100%, 82%, 1)",
    "orange-tint": "hsla(36, 100%, 82%, 1)",
  },
  neutral: {
    70: "hsla(0, 0%, 38%, 1)",
    60: "hsla(0, 0%, 41%, 1)",
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
  h1: [fluidScaleRem("46px", "32px"), headerProps],
  h2: [fluidScaleRem("36px", "32px"), headerProps],
  h3: [fluidScaleRem("26px", "24px"), headerProps],
  h4: [fluidScaleRem("24px", "20px"), headerProps],
  h5: [fluidScaleRem("20px", "17px"), headerProps],
  h6: [
    fluidScaleRem("18px", "16px"),
    { ...headerProps, letterSpacing: "-0.0187rem" },
  ],
  staff: [pxToRem("52px"), { fontWeight: 500, lineHeight: pxToRem("56px") }],
  xl: [pxToRem("22px"), bodyProps],
  lg: [pxToRem("20px"), bodyProps],
  base: [
    fluidScaleRem("17px", "16px"),
    { ...bodyProps, letterSpacing: "-0.0156rem", lineHeight: pxToRem("26px") },
  ],
  sm: [fluidScaleRem("16px", "15px"), bodyProps],
  xs: [fluidScaleRem("15px", "14px"), bodyProps],
  xxs: [fluidScaleRem("14px", "13px"), bodyProps],
  terms: [pxToRem("13px"), bodyProps], // 13px
  label: [
    pxToRem("16px"),
    {
      lineHeight: pxToRem("19px"),
      letterSpacing: "0rem",
      fontWeight: headerProps.fontWeight,
    },
  ],
};

const fontFamily = {
  body: ["Inter", ...defaultTheme.fontFamily.sans],
  header: ["BW Gradual", ...defaultTheme.fontFamily.sans],
};

const borderRadius = {
  xs: "0.375rem",
  sm: "0.75rem",
  md: "1rem",
  lg: "1.25rem",
  xl: "1.5rem",
  xxl: "12.5rem",
  full: "25rem",
};

const gridTemplateColumns = {
  "solutions-page": "21.4375rem 1fr",
  "solutions-list": "repeat(auto-fit, minmax(20.375rem, 1fr))",
  "comparison-page": "21.4375rem 1fr",
  "comparison-list": "repeat(auto-fit, minmax(20.375rem, 1fr))",
};

const minHeight = {
  resultsBar: fluidScaleRem("60px", "52px"),
};

const width = {
  "comparison-item": fluidScaleRem("320px", "165px"),
  "comparison-row-header": fluidScaleRem("320px", "100px"),
};

const screens = {
  ...baseScreens,
  mobile: {
    raw: `screen and (min-width: ${baseScreens.lg}) and (min-height: ${baseScreens.md})`,
  },
};

const zIndex = {
  backToTop: 50,
  skipLink: 50,
  stickyHeader: 51,
  messages: 60,
};

const transitionProperty = {
  underline: "text-decoration-color",
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
    borderRadius,
    extend: {
      colors,
      fontSize,
      fontFamily,
      gridTemplateColumns,
      maxWidth,
      minHeight,
      screens,
      width,
      zIndex,
      transitionProperty,
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
    require("./tailwind/fluid-scale-plugin"),
  ],
};
