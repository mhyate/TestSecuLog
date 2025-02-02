<template>
  <nav class="bg-white/5 backdrop-blur-lg border-b border-white/10">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between h-20">
        <div class="flex items-center">
          <router-link to="/" class="text-2xl font-bold text-white hover:text-primary-300 transition-colors">
            LocaMat
          </router-link>
          <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
            <router-link
              v-for="link in navigationLinks"
              :key="link.to"
              :to="link.to"
              class="text-primary-100 hover:text-white px-3 py-2 rounded-lg text-sm font-medium transition-all duration-200"
              :class="{ 'bg-primary-600/20': $route.path === link.to }"
            >
              {{ link.text }}
            </router-link>
          </div>
        </div>
        <div class="flex items-center space-x-4">
          <template v-if="authStore.user">
            <router-link
              to="/app"
              class="text-primary-100 hover:text-white px-3 py-2 rounded-lg text-sm font-medium transition-all duration-200"
            >
              Ma session
            </router-link>
          </template>
          <template v-else>
            <router-link
              to="/login"
              class="text-primary-100 hover:text-white px-3 py-2 rounded-lg text-sm font-medium transition-all duration-200"
            >
              Connexion
            </router-link>
            <router-link
              to="/register"
              class="bg-white text-primary-600 hover:text-primary-700 px-4 py-2 rounded-lg text-sm font-medium transition-all duration-200"
            >
              Inscription
            </router-link>
          </template>
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { useAuthStore } from '../stores/auth'

const authStore = useAuthStore()

const navigationLinks = [
  { to: '/', text: 'Accueil' },
  { to: '/about', text: 'À propos' },
  { to: '/contact', text: 'Contact' }
]
</script>