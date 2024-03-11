const path = require("path");
const { screens } = require("./tailwind-helper");
const { fluidScaleRemBase } = require("@castiron/style-mixins");

module.exports = {
  plugins: {
    "postcss-mixins": {
      mixinsDir: path.join(__dirname, "./app/assets/stylesheets/mixins"),
      mixins: {
        fluidScaleRem: function (
          mixin,
          property,
          max,
          min,
          maxBreak = screens.xl,
          minBreak = screens.xs
        ) {
          const scale = fluidScaleRemBase(max, min, maxBreak, minBreak);
          return { [property]: scale };
        },
      },
    },
    "postcss-import": require("postcss-import"),
    "tailwindcss/nesting": require("postcss-nested")({ bubble: ["container"] }),
    autoprefixer: require("autoprefixer"),
    tailwindcss: require("tailwindcss"),
  },
};
