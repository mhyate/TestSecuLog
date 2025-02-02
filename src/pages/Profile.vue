<template>
  <div class="space-y-8">
    <div class="bg-white/70 backdrop-blur-lg rounded-2xl p-8 shadow-lg border border-gray-200">
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-3xl font-bold text-gray-900">Mon profil</h1>
          <p class="mt-2 text-lg text-gray-600">
            Gérez vos informations personnelles
          </p>
        </div>
        <button
          @click="startEditing"
          v-if="!isEditing"
          class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg text-white bg-primary-500 hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-all duration-200"
        >
          <Pencil class="w-4 h-4 mr-2" />
          Modifier
        </button>
      </div>

      <form @submit.prevent="saveProfile" class="mt-8 space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <!-- Informations non modifiables -->
          <div>
            <label class="block text-sm font-medium text-gray-700">Email</label>
            <p class="mt-1 text-lg text-gray-900">{{ authStore.profile?.email }}</p>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700">Matricule</label>
            <p class="mt-1 text-lg text-gray-900">{{ authStore.profile?.id_number }}</p>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700">Rôle</label>
            <p class="mt-1">
              <span
                class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                :class="authStore.profile?.role === 'admin' ? 'bg-purple-100 text-purple-800' : 'bg-green-100 text-green-800'"
              >
                {{ authStore.profile?.role === 'admin' ? 'Administrateur' : 'Utilisateur' }}
              </span>
            </p>
          </div>

          <!-- Champs modifiables -->
          <div>
            <label class="block text-sm font-medium text-gray-700">Prénom</label>
            <div v-if="isEditing">
              <input
                v-model="form.first_name"
                type="text"
                class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
              />
              <p v-if="errors.first_name" class="mt-1 text-sm text-red-600">{{ errors.first_name }}</p>
            </div>
            <p v-else class="mt-1 text-lg text-gray-900">{{ authStore.profile?.first_name }}</p>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700">Nom</label>
            <div v-if="isEditing">
              <input
                v-model="form.last_name"
                type="text"
                class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
              />
              <p v-if="errors.last_name" class="mt-1 text-sm text-red-600">{{ errors.last_name }}</p>
            </div>
            <p v-else class="mt-1 text-lg text-gray-900">{{ authStore.profile?.last_name }}</p>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700">Téléphone</label>
            <div v-if="isEditing">
              <input
                v-model="form.phone"
                type="tel"
                class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                placeholder="0612345678"
              />
              <p v-if="errors.phone" class="mt-1 text-sm text-red-600">{{ errors.phone }}</p>
            </div>
            <p v-else class="mt-1 text-lg text-gray-900">{{ authStore.profile?.phone || '-' }}</p>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700">Adresse</label>
            <div v-if="isEditing">
              <input
                v-model="form.address"
                type="text"
                class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
              />
              <p v-if="errors.address" class="mt-1 text-sm text-red-600">{{ errors.address }}</p>
            </div>
            <p v-else class="mt-1 text-lg text-gray-900">{{ authStore.profile?.address || '-' }}</p>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700">Code postal</label>
            <div v-if="isEditing">
              <input
                v-model="form.postal_code"
                type="text"
                class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                placeholder="75000"
              />
              <p v-if="errors.postal_code" class="mt-1 text-sm text-red-600">{{ errors.postal_code }}</p>
            </div>
            <p v-else class="mt-1 text-lg text-gray-900">{{ authStore.profile?.postal_code || '-' }}</p>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700">Ville</label>
            <div v-if="isEditing">
              <input
                v-model="form.city"
                type="text"
                class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
              />
              <p v-if="errors.city" class="mt-1 text-sm text-red-600">{{ errors.city }}</p>
            </div>
            <p v-else class="mt-1 text-lg text-gray-900">{{ authStore.profile?.city || '-' }}</p>
          </div>
        </div>

        <!-- Boutons de modification -->
        <div v-if="isEditing" class="flex justify-end space-x-4">
          <button
            type="button"
            @click="cancelEditing"
            class="px-4 py-2 border border-gray-300 text-sm font-medium rounded-lg text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
          >
            Annuler
          </button>
          <button
            type="submit"
            :disabled="isSubmitting"
            class="px-4 py-2 border border-transparent text-sm font-medium rounded-lg text-white bg-primary-500 hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 disabled:opacity-50"
          >
            {{ isSubmitting ? 'Enregistrement...' : 'Enregistrer' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { Pencil } from 'lucide-vue-next'
import { useAuthStore } from '../stores/auth'
import { useToast } from 'vue-toastification'
import { z } from 'zod'

const authStore = useAuthStore()
const toast = useToast()

const isEditing = ref(false)
const isSubmitting = ref(false)
const errors = ref<Record<string, string>>({})

const form = ref({
  first_name: '',
  last_name: '',
  phone: '',
  address: '',
  postal_code: '',
  city: ''
})

const profileSchema = z.object({
  first_name: z.string().min(1, 'Le prénom est requis').max(30),
  last_name: z.string().min(1, 'Le nom est requis').max(30),
  phone: z.string().regex(/^0[1-9][0-9]{8}$/, 'Numéro de téléphone invalide'),
  address: z.string().min(1, 'L\'adresse est requise'),
  postal_code: z.string().regex(/^[0-9]{5}$/, 'Code postal invalide'),
  city: z.string().min(1, 'La ville est requise')
})

const startEditing = () => {
  form.value = {
    first_name: authStore.profile?.first_name || '',
    last_name: authStore.profile?.last_name || '',
    phone: authStore.profile?.phone || '',
    address: authStore.profile?.address || '',
    postal_code: authStore.profile?.postal_code || '',
    city: authStore.profile?.city || ''
  }
  isEditing.value = true
}

const cancelEditing = () => {
  isEditing.value = false
  errors.value = {}
}

const saveProfile = async () => {
  errors.value = {}
  isSubmitting.value = true

  try {
    const result = profileSchema.safeParse(form.value)
    if (!result.success) {
      errors.value = result.error.formErrors.fieldErrors
      return
    }

    await authStore.updateProfile(form.value)
    toast.success('Profil mis à jour avec succès')
    isEditing.value = false
  } catch (error) {
    console.error('Erreur lors de la mise à jour du profil:', error)
    toast.error('Une erreur est survenue lors de la mise à jour du profil')
  } finally {
    isSubmitting.value = false
  }
}
</script>