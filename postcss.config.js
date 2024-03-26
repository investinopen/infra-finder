const path = require("path");
const { fluidScaleRem } = require("./tailwind/helper");

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
          maxBreak,
          minBreak
        ) {
          const scale = fluidScaleRem(max, min, maxBreak, minBreak);
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
