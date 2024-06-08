import Vue from "vue";
import App from "./App.vue";
import "./registerServiceWorker";
import router from "./router";
import "bootstrap/dist/css/bootstrap.min.css";
import "@fortawesome/fontawesome-free/css/all.min.css";
import BootstrapVue from "bootstrap-vue";
import "bootstrap-vue/dist/bootstrap-vue.css";
import "bootstrap/dist/js/bootstrap.bundle.min.js";

Vue.config.productionTip = false;

Vue.use(BootstrapVue);

new Vue({
  router,
  render: h => h(App),
}).$mount("#app");
