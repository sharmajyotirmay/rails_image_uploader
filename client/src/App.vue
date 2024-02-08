<script setup>
  import Camera from './components/Camera.vue'
</script>

<template>
  <div class="_camera_cont">
    <Camera/>
  </div>
</template>

<style scoped>
  ._camera_cont {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 50vh;
    min-width: 50vw;
  }
</style>
