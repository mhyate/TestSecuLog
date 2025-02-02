<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-50 to-primary-50">
    <!-- Navigation -->
    <nav class="bg-white/70 backdrop-blur-lg border-b border-gray-200 sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex">
            <div class="flex-shrink-0 flex items-center">
              <h1 class="text-2xl font-bold text-primary-600">
                LocaMat
              </h1>
            </div>
            <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
              <router-link
                to="/"
                class="inline-flex items-center px-1 pt-1 text-sm font-medium transition-all duration-200"
                :class="[
                  $route.path === '/'
                    ? 'border-b-2 border-primary-500 text-gray-900'
                    : 'border-b-2 border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'
                ]"
              >
                <Home class="w-4 h-4 mr-2" />
                Accueil
              </router-link>
              <router-link
                v-for="(link, index) in filteredNavigationLinks"
                :key="index"
                :to="link.to"
                class="inline-flex items-center px-1 pt-1 text-sm font-medium transition-all duration-200"
                :class="[
                  $route.path === link.to
                    ? 'border-b-2 border-primary-500 text-gray-900'
                    : 'border-b-2 border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'
                ]"
              >
                <component :is="link.icon" class="w-4 h-4 mr-2" />
                {{ link.text }}
              </router-link>
            </div>
          </div>
          
          <!-- Menu utilisateur -->
          <div class="flex items-center">
            <div class="flex items-center space-x-4">
              <Menu as="div" class="relative ml-3">
                <div>
                  <MenuButton class="flex items-center p-2 rounded-lg hover:bg-gray-100 transition-colors">
                    <User class="h-6 w-6 text-gray-700" />
                    <ChevronDown class="ml-1 h-4 w-4 text-gray-700" />
                  </MenuButton>
                </div>
                <transition
                  enter-active-class="transition ease-out duration-100"
                  enter-from-class="transform opacity-0 scale-95"
                  enter-to-class="transform opacity-100 scale-100"
                  leave-active-class="transition ease-in duration-75"
                  leave-from-class="transform opacity-100 scale-100"
                  leave-to-class="transform opacity-0 scale-95"
                >
                  <MenuItems class="absolute right-0 mt-2 w-48 origin-top-right rounded-lg bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none">
                    <MenuItem v-slot="{ active }">
                      <router-link
                        to="/app/profile"
                        :class="[active ? 'bg-gray-100' : '', 'block px-4 py-2 text-sm text-gray-700']"
                      >
                        <User class="inline-block w-4 h-4 mr-2" />
                        Profil
                      </router-link>
                    </MenuItem>
                    <MenuItem v-slot="{ active }">
                      <router-link
                        to="/app/settings"
                        :class="[active ? 'bg-gray-100' : '', 'block px-4 py-2 text-sm text-gray-700']"
                      >
                        <Settings class="inline-block w-4 h-4 mr-2" />
                        Paramètres
                      </router-link>
                    </MenuItem>
                    <MenuItem v-slot="{ active }">
                      <button
                        @click="handleSignOut"
                        :class="[active ? 'bg-gray-100' : '', 'block w-full text-left px-4 py-2 text-sm text-gray-700']"
                      >
                        <LogOut class="inline-block w-4 h-4 mr-2" />
                        Déconnexion
                      </button>
                    </MenuItem>
                  </MenuItems>
                </transition>
              </Menu>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <!-- Contenu principal -->
    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
      <router-view v-slot="{ Component }">
        <transition
          enter-active-class="transition ease-out duration-200"
          enter-from-class="opacity-0 translate-y-4"
          enter-to-class="opacity-100 translate-y-0"
          leave-active-class="transition ease-in duration-150"
          leave-from-class="opacity-100 translate-y-0"
          leave-to-class="opacity-0 translate-y-4"
        >
          <component :is="Component" />
        </transition>
      </router-view>
    </main>
  </div>
</template>

<script setup lang="ts">
import { Monitor, Calendar, Home, Settings, LogOut, User, ChevronDown, ShieldCheck } from 'lucide-vue-next'
import { Menu, MenuButton, MenuItem, MenuItems } from '@headlessui/vue'
import { useAuthStore } from '../stores/auth'
import { useRouter } from 'vue-router'
import { useToast } from 'vue-toastification'
import { computed } from 'vue'

const authStore = useAuthStore()
const router = useRouter()
const toast = useToast()

const navigationLinks = [
  { to: '/app', text: 'Dashboard', icon: Monitor },
  { to: '/app/equipment', text: 'Équipements', icon: Monitor },
  { to: '/app/reservations', text: 'Réservations', icon: Calendar },
  { to: '/app/admin', text: 'Administration', icon: ShieldCheck, requiresAdmin: true }
]

const filteredNavigationLinks = computed(() => {
  return navigationLinks.filter(link => {
    if (link.requiresAdmin) {
      return authStore.profile?.role === 'admin'
    }
    return true
  })
})

const handleSignOut = async () => {
  try {
    await authStore.signOut()
    router.push('/login')
    toast.success('Déconnexion réussie')
  } catch (error) {
    toast.error('Erreur lors de la déconnexion')
  }
}
</script>