const { fluidScaleRemBase } = require("@castiron/style-mixins");

const screens = {
  xs: "17.5rem", // 280px
  sm: "30rem", // 480px
  md: "48rem", // 768px
  lg: "64rem", // 1024px
  xl: "87.5rem", // 1400px
  xxl: "131.25rem", // 2100px
  nav: "72.8125rem", // 1165px
};

module.exports = {
  screens,
  fluidScaleRem: function (
    max,
    min,
    maxBreak = screens.xl,
    minBreak = screens.xs
  ) {
    return fluidScaleRemBase(max, min, maxBreak, minBreak);
  },
};
