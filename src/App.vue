<template>
  <div id="app">
    <RatingComponent />
  </div>
</template>

<script>
import RatingComponent from "./components/RatingComponent.vue";

export default {
  name: "App",
  components: {
    RatingComponent,
  },
  mounted() {
    document.title = "Feedback Form Pop Up";
  }
};
</script>

<style>
#app {
  font-family: Arial, sans-serif;
  text-align: center;
  margin-top: 60px;
}
</style>
