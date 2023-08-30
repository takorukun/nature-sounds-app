module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/assets/stylesheets/**/*.scss',
    './app/javascript/**/*.js'
  ],
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('daisyui')
  ],
  theme: {
    extend: {
      transitionDuration: {
        '5000': '5000ms',
      }
    }
  },
  daisyui: {
    themes: [
    ],
  },
}
