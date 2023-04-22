// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import jquery from "jquery";
window.$ = jquery

console.log('hoge')
import "./controllers";
import "@hotwired/turbo-rails"
import Rails from '@rails/ujs';
Rails.start();
