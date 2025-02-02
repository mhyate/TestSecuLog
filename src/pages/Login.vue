<template>
  <div class="min-h-screen bg-gradient-to-br from-primary-900 via-primary-800 to-primary-900 animate-gradient">
    <Navigation />
    
    <div class="flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
      <!-- Cercles décoratifs -->
      <div class="absolute inset-0 overflow-hidden">
        <div class="absolute -top-40 -right-40 w-80 h-80 bg-primary-500/20 rounded-full filter blur-3xl"></div>
        <div class="absolute -bottom-40 -left-40 w-80 h-80 bg-primary-700/20 rounded-full filter blur-3xl"></div>
      </div>

      <div class="w-full max-w-md space-y-8 relative">
        <!-- Logo et titre -->
        <div class="text-center">
          <div class="mx-auto h-16 w-16 relative animate-float">
            <div class="absolute inset-0 bg-primary-500/20 rounded-full filter blur-lg"></div>
            <div class="relative flex items-center justify-center h-full">
              <Lock class="h-8 w-8 text-white" />
            </div>
          </div>
          <h2 class="mt-6 text-3xl font-bold tracking-tight text-white">
            Connexion à LocaMat
          </h2>
          <p class="mt-2 text-sm text-primary-200">
            Accédez à votre espace personnel
          </p>
        </div>

        <!-- Formulaire -->
        <div class="backdrop-blur-lg bg-white/10 rounded-2xl p-8 shadow-2xl border border-white/20">
          <form class="space-y-6" @submit.prevent="handleSubmit">
            <div>
              <label class="block text-sm font-medium text-primary-100">
                Email
              </label>
              <div class="mt-1">
                <input
                  v-model="email"
                  type="email"
                  required
                  class="block w-full rounded-xl border-0 bg-white/5 text-white shadow-sm ring-1 ring-inset ring-white/10 focus:ring-2 focus:ring-inset focus:ring-primary-500 sm:text-sm sm:leading-6 placeholder:text-gray-400"
                  placeholder="email@exemple.com"
                />
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-primary-100">
                Mot de passe
              </label>
              <div class="mt-1">
                <input
                  v-model="password"
                  type="password"
                  required
                  class="block w-full rounded-xl border-0 bg-white/5 text-white shadow-sm ring-1 ring-inset ring-white/10 focus:ring-2 focus:ring-inset focus:ring-primary-500 sm:text-sm sm:leading-6 placeholder:text-gray-400"
                  placeholder="••••••••"
                />
              </div>
            </div>

            <div>
              <button
                type="submit"
                :disabled="isSubmitting"
                class="group relative flex w-full justify-center rounded-xl bg-primary-500 px-3 py-3 text-sm font-semibold text-white shadow-sm hover:bg-primary-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 ease-out hover:shadow-lg"
              >
                <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                  <Lock class="h-5 w-5 text-primary-300 group-hover:text-primary-200" aria-hidden="true" />
                </span>
                {{ isSubmitting ? 'Connexion...' : 'Se connecter' }}
              </button>
            </div>

            <div class="text-center mt-4">
              <p class="text-sm text-primary-200">
                Pas encore de compte ?
                <router-link to="/register" class="font-medium text-primary-300 hover:text-primary-200">
                  Inscrivez-vous
                </router-link>
              </p>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { Lock } from 'lucide-vue-next'
import { useRouter, useRoute } from 'vue-router'
import { useToast } from 'vue-toastification'
import { useAuthStore } from '../stores/auth'
import Navigation from '../components/Navigation.vue'
import { supabase } from '../lib/supabase'

const router = useRouter()
const route = useRoute()
const toast = useToast()
const authStore = useAuthStore()

const email = ref('')
const password = ref('')
const isSubmitting = ref(false)

const handleSubmit = async () => {
  isSubmitting.value = true

  try {
    const { error } = await supabase.auth.signInWithPassword({
      email: email.value,
      password: password.value
    })

    if (error) throw error

    // Rediriger vers la page demandée ou le dashboard
    const redirectPath = route.query.redirect?.toString() || '/app'
    router.push(redirectPath)
    toast.success('Connexion réussie')
  } catch (error) {
    console.error('Erreur de connexion:', error)
    toast.error('Identifiants incorrects')
  } finally {
    isSubmitting.value = false
  }
}
</script>