<template>
  <div class="min-h-screen bg-gradient-to-br from-primary-900 via-primary-800 to-primary-900">
    <Navigation />

    <!-- Hero Section -->
    <div class="relative overflow-hidden">
      <!-- Cercles décoratifs -->
      <div class="absolute inset-0">
        <div class="absolute -top-40 -right-40 w-80 h-80 bg-primary-500/20 rounded-full filter blur-3xl"></div>
        <div class="absolute -bottom-40 -left-40 w-80 h-80 bg-primary-700/20 rounded-full filter blur-3xl"></div>
      </div>

      <div class="relative pt-10 pb-20 sm:pt-16 sm:pb-32">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="lg:grid lg:grid-cols-12 lg:gap-8">
            <div class="sm:text-center md:max-w-2xl md:mx-auto lg:col-span-6 lg:text-left">
              <h1>
                <span class="block text-sm font-semibold text-primary-300 sm:text-base lg:text-sm xl:text-base">
                  Nouveau sur LocaMat
                </span>
                <span class="mt-1 block text-4xl tracking-tight font-extrabold sm:text-5xl xl:text-6xl">
                  <span class="block text-white">Gérez votre matériel</span>
                  <span class="block text-primary-300">en toute simplicité</span>
                </span>
              </h1>
              <p class="mt-3 text-base text-primary-100 sm:mt-5 sm:text-xl lg:text-lg xl:text-xl">
                LocaMat est votre solution complète pour la gestion de matériel informatique. Réservez, suivez et gérez votre équipement en quelques clics.
              </p>
              <div class="mt-8 sm:max-w-lg sm:mx-auto sm:text-center lg:text-left">
                <router-link
                  to="/register"
                  class="inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-lg shadow-sm text-white bg-primary-500 hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-all duration-200"
                >
                  Commencer maintenant
                  <ArrowRight class="ml-2 h-5 w-5" />
                </router-link>
              </div>
            </div>
            <div class="mt-12 relative sm:max-w-lg sm:mx-auto lg:mt-0 lg:max-w-none lg:mx-0 lg:col-span-6 lg:flex lg:items-center">
              <div class="relative mx-auto w-full rounded-lg shadow-lg lg:max-w-md">
                <div class="relative block w-full bg-white rounded-lg overflow-hidden">
                  <img
                    src="https://images.unsplash.com/photo-1498050108023-c5249f4df085?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2072&q=80"
                    alt="Interface LocaMat"
                    class="w-full"
                  />
                  <div class="absolute inset-0 bg-primary-900/10"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ArrowRight } from 'lucide-vue-next'
import Navigation from '../components/Navigation.vue'
</script>