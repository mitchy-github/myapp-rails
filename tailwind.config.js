module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      spacing: {
      '128': '32rem',
      '72': '18rem',
      '84': '21rem',
      '96': '24rem',
      },
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
        heartbeat: {
          "0%": {
              transform: "scale(1)",
              "transform-origin": "center center",
              "animation-timing-function": "ease-out"
          },
          "10%": {
              transform: "scale(.91)",
              "animation-timing-function": "ease-in"
          },
          "17%": {
              transform: "scale(.98)",
              "animation-timing-function": "ease-out"
          },
          "33%": {
              transform: "scale(.87)",
              "animation-timing-function": "ease-in"
          },
          "45%": {
              transform: "scale(1)",
              "animation-timing-function": "ease-out"
          },
      },
        "slide-in-elliptic-top-fwd": {
          "0%": {
              transform: "translateY(-600px) rotateX(-30deg) scale(0)",
              "transform-origin": "50% 100%",
              opacity: "0"
          },
          to: {
              transform: "translateY(0) rotateX(0) scale(1)",
              "transform-origin": "50% 1400px",
              opacity: "1"
          },
        },
        "slide-out-elliptic-top-bck": {
          "0%": {
              transform: "translateY(0) rotateX(0) scale(1)",
              "transform-origin": "50% 1400px",
              opacity: "1"
          },
          to: {
              transform: "translateY(-600px) rotateX(-30deg) scale(0)",
              "transform-origin": "50% 100%",
              opacity: "1"
          },
        },
      },
      animation: {
        flash: "flashFade 2.5s forwards",
        "scale-in-ver-top": "scale-in-ver-top 0.5s cubic-bezier(0.250, 0.460, 0.450, 0.940)     both",
        heartbeat: "heartbeat 1.5s ease  infinite both",
        "slide-in-elliptic-top-fwd": "slide-in-elliptic-top-fwd 0.7s cubic-bezier(0.250, 0.460, 0.450, 0.940)   both",
        "slide-out-elliptic-top-bck": "slide-out-elliptic-top-bck 0.7s cubic-bezier(0.550, 0.085, 0.680, 0.530)   both",
      },
    },
  },
  plugins: [
    require('@tailwindcss/line-clamp'),
  ],
}
