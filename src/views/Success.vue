<template>
  <div class="success-page">
    <h1>Feedback Submitted Successfully!</h1>
    <button class="btn btn-primary" @click="goBack">Back to Homepage</button>
  </div>
</template>

<script>
export default {
  name: 'Success',
  methods: {
    goBack() {
      this.$router.push('/');
    }
  }
}
</script>

<style scoped>
.success-page {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
}
</style>
