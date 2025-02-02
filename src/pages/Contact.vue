<template>
  <div class="min-h-screen bg-gradient-to-br from-primary-900 via-primary-800 to-primary-900">
    <Navigation />
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <div class="bg-white/10 backdrop-blur-lg rounded-2xl p-8 shadow-2xl border border-white/20">
        <h1 class="text-4xl font-bold text-white mb-8">Contactez-nous</h1>
        
        <form class="space-y-6">
          <div>
            <label class="block text-sm font-medium text-primary-100">Nom</label>
            <input
              type="text"
              class="mt-1 block w-full rounded-xl border-0 bg-white/5 text-white shadow-sm ring-1 ring-inset ring-white/10 focus:ring-2 focus:ring-inset focus:ring-primary-500 sm:text-sm sm:leading-6"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-primary-100">Email</label>
            <input
              type="email"
              class="mt-1 block w-full rounded-xl border-0 bg-white/5 text-white shadow-sm ring-1 ring-inset ring-white/10 focus:ring-2 focus:ring-inset focus:ring-primary-500 sm:text-sm sm:leading-6"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-primary-100">Message</label>
            <textarea
              rows="4"
              class="mt-1 block w-full rounded-xl border-0 bg-white/5 text-white shadow-sm ring-1 ring-inset ring-white/10 focus:ring-2 focus:ring-inset focus:ring-primary-500 sm:text-sm sm:leading-6"
            ></textarea>
          </div>
          
          <button
            type="submit"
            class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-sm text-sm font-medium text-white bg-primary-500 hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
          >
            Envoyer
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import Navigation from '../components/Navigation.vue'
</script>