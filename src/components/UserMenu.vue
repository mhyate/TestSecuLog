<template>
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
</template>

<script setup lang="ts">
import { Menu, MenuButton, MenuItem, MenuItems } from '@headlessui/vue'
import { User, ChevronDown, Settings, LogOut } from 'lucide-vue-next'
import { useAuthStore } from '../stores/auth'
import { useRouter } from 'vue-router'
import { useToast } from 'vue-toastification'

const authStore = useAuthStore()
const router = useRouter()
const toast = useToast()

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