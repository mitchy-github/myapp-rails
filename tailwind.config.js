module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      keyframes: {
        flashFade: {
          "0%": { transform: "translateX(180px)", opacity: 0 },
          "20%": { transform: "translateX(0)", opacity: 1 },
          "80%": { transform: "translateX(0)", opacity: 1 },
          "100%": { transform: "translateX(180px)", opacity: 0 },
        },
        "scale-in-ver-top": {
          "0%": {
              transform: "scaleY(0)",
              "transform-origin": "100% 0%",
              opacity: "0"
          },
          to: {
              transform: "scaleY(1)",
              "transform-origin": "100% 0%",
              opacity: "1"
          },
        },
        "scale-out-ver-top": {
          "0%": {
              transform: "scaleY(1)",
              "transform-origin": "100% 0%",
              transition: "1"
          },
          to: {
              transform: "scaleY(0)",
              "transform-origin": "100% 0%",
              transition: "0"
          },
        },
        "rotate-in-center": {
          "0%": {
              transform: "rotate(-360deg)",
              opacity: "0"
          },
          to: {
              transform: "rotate(0)",
              opacity: "1"
          },
        },
      },
      animation: {
        flash: "flashFade 2.5s forwards",
        "scale-in-ver-top": "scale-in-ver-top 0.5s cubic-bezier(0.250, 0.460, 0.450, 0.940)     both",
        "scale-out-ver-top": "scale-out-ver-top 0.5s cubic-bezier(0.550, 0.085, 0.680, 0.530)     both",
        "rotate-in-center": "rotate-in-center 0.6s cubic-bezier(0.250, 0.460, 0.450, 0.940)   both",
      },
    },
  },
}
