import Vue from "vue";
import VueRouter from "vue-router";
import HomeView from "../views/HomeView.vue";
import Success from "../views/Success.vue";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "home",
    component: HomeView,
    meta: { title: 'Feedback Form Pop Up' }
  },
  {
    path: '/success',
    name: 'Success',
    component: Success,
    meta: { title: 'Feedback Submitted Successfully' }
  }
];

const router = new VueRouter({
  mode: "history",
  routes,
});

export default router;
