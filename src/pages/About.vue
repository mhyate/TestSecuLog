<template>
  <div class="min-h-screen bg-gradient-to-br from-primary-900 via-primary-800 to-primary-900">
    <Navigation />
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <div class="bg-white/10 backdrop-blur-lg rounded-2xl p-8 shadow-2xl border border-white/20">
        <h1 class="text-4xl font-bold text-white mb-8">À propos de LocaMat</h1>
        
        <div class="prose prose-lg prose-invert">
          <p class="text-primary-100">
            LocaMat est une solution innovante de gestion de matériel informatique, conçue pour simplifier 
            la vie des entreprises et des institutions éducatives.
          </p>
          
          <h2 class="text-2xl font-semibold text-white mt-8 mb-4">Notre Mission</h2>
          <p class="text-primary-100">
            Faciliter l'accès au matériel informatique tout en assurant une gestion efficace et transparente 
            des ressources.
          </p>
          
          <h2 class="text-2xl font-semibold text-white mt-8 mb-4">Notre Vision</h2>
          <p class="text-primary-100">
            Devenir la référence en matière de gestion de matériel informatique, en proposant une solution 
            moderne, intuitive et sécurisée.
          </p>

          <h2 class="text-2xl font-semibold text-white mt-12 mb-8 text-center">Notre Équipe</h2>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-8" v-motion-slide-visible-once>
            <!-- Direction -->
            <div 
              class="relative group"
              v-motion-slide-visible-once
              :delay="100"
            >
              <div class="absolute inset-0 bg-gradient-to-r from-rose-500/30 to-orange-500/30 rounded-2xl blur-xl transition-all duration-500 group-hover:scale-110"></div>
              <div class="relative bg-white/10 rounded-2xl p-6 backdrop-blur-sm border border-white/10 transition-transform duration-500 hover:scale-105">
                <div class="flex items-center space-x-4">
                  <div class="p-3 bg-gradient-to-br from-rose-500/20 to-orange-500/20 rounded-xl">
                    <UserCircle2 class="w-6 h-6 text-rose-300" />
                  </div>
                  <div>
                    <h3 class="text-xl font-semibold text-white">Direction du Projet</h3>
                    <p class="text-rose-200 mt-1">
                      Ayimane BARA
                      <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gradient-to-r from-rose-500/20 to-orange-500/20 text-rose-200 ml-2">
                        Vini Jr from wish
                      </span>
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Développement -->
            <div 
              class="relative group"
              v-motion-slide-visible-once
              :delay="200"
            >
              <div class="absolute inset-0 bg-gradient-to-r from-emerald-500/30 to-teal-500/30 rounded-2xl blur-xl transition-all duration-500 group-hover:scale-110"></div>
              <div class="relative bg-white/10 rounded-2xl p-6 backdrop-blur-sm border border-white/10 transition-transform duration-500 hover:scale-105">
                <div class="flex items-center space-x-4">
                  <div class="p-3 bg-gradient-to-br from-emerald-500/20 to-teal-500/20 rounded-xl">
                    <Code2 class="w-6 h-6 text-emerald-300" />
                  </div>
                  <div>
                    <h3 class="text-xl font-semibold text-white">Développement</h3>
                    <p class="text-emerald-200 mt-1">
                      Mhammed BAROUDI & Kenza AIT OUAZZOU
                      <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gradient-to-r from-emerald-500/20 to-teal-500/20 text-emerald-200 ml-2">
                        les DZ
                      </span>
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Qualité -->
            <div 
              class="relative group"
              v-motion-slide-visible-once
              :delay="300"
            >
              <div class="absolute inset-0 bg-gradient-to-r from-violet-500/30 to-purple-500/30 rounded-2xl blur-xl transition-all duration-500 group-hover:scale-110"></div>
              <div class="relative bg-white/10 rounded-2xl p-6 backdrop-blur-sm border border-white/10 transition-transform duration-500 hover:scale-105">
                <div class="flex items-center space-x-4">
                  <div class="p-3 bg-gradient-to-br from-violet-500/20 to-purple-500/20 rounded-xl">
                    <CheckCircle2 class="w-6 h-6 text-violet-300" />
                  </div>
                  <div>
                    <h3 class="text-xl font-semibold text-white">Tests & Validation</h3>
                    <p class="text-violet-200 mt-1">
                      Mouhamadou YATE
                      <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gradient-to-r from-violet-500/20 to-purple-500/20 text-violet-200 ml-2">
                        L'ancien
                      </span>
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Documentation -->
            <div 
              class="relative group"
              v-motion-slide-visible-once
              :delay="400"
            >
              <div class="absolute inset-0 bg-gradient-to-r from-amber-500/30 to-yellow-500/30 rounded-2xl blur-xl transition-all duration-500 group-hover:scale-110"></div>
              <div class="relative bg-white/10 rounded-2xl p-6 backdrop-blur-sm border border-white/10 transition-transform duration-500 hover:scale-105">
                <div class="flex items-center space-x-4">
                  <div class="p-3 bg-gradient-to-br from-amber-500/20 to-yellow-500/20 rounded-xl">
                    <FileText class="w-6 h-6 text-amber-300" />
                  </div>
                  <div>
                    <h3 class="text-xl font-semibold text-white">Documentation</h3>
                    <p class="text-amber-200 mt-1">
                      Enes YILDIZ
                      <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gradient-to-r from-amber-500/20 to-yellow-500/20 text-amber-200 ml-2">
                        Le BG
                        Le plus fort
                        
                      </span>
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Formation -->
            <div 
              class="relative group md:col-span-2"
              v-motion-slide-visible-once
              :delay="500"
            >
              <div class="absolute inset-0 bg-gradient-to-r from-cyan-500/30 to-blue-500/30 rounded-2xl blur-xl transition-all duration-500 group-hover:scale-110"></div>
              <div class="relative bg-white/10 rounded-2xl p-6 backdrop-blur-sm border border-white/10 transition-transform duration-500 hover:scale-105">
                <div class="flex items-center space-x-4">
                  <div class="p-3 bg-gradient-to-br from-cyan-500/20 to-blue-500/20 rounded-xl">
                    <GraduationCap class="w-6 h-6 text-cyan-300" />
                  </div>
                  <div>
                    <h3 class="text-xl font-semibold text-white">Formation</h3>
                    <p class="text-cyan-200 mt-1">
                      Polytech TOURS
                      <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gradient-to-r from-cyan-500/20 to-blue-500/20 text-cyan-200 ml-2">
                        5ème année ISIE
                      </span>
                    </p>
                  </div>
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
import Navigation from '../components/Navigation.vue'
import { UserCircle2, Code2, CheckCircle2, FileText, GraduationCap } from 'lucide-vue-next'
import { useMotion } from '@vueuse/motion'
</script>