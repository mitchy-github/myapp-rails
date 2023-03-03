// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import jquery from "jquery"
window.$ = jquery


$(function(){
  alert("jQuery 動いた！")
})

console.log('hoge')
