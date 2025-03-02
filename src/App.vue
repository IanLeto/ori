<script setup>
import HelloWorld from './components/HelloWorld.vue';
</script>

<template>
  <div>
    <header>
      <img alt="Vue logo" class="logo" src="./assets/logo.svg" width="125" height="125" />
      <div class="wrapper">
        <nav>
          <router-link to="/">表单</router-link> |
          <router-link to="/list">列表</router-link>
        </nav>
        <router-view></router-view>
      </div>
    </header>
  </div>
</template>

<style scoped>
header {
  line-height: 1.5;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
  }

  .logo {
    margin: 0 2rem 0 0;
  }
}
</style>
