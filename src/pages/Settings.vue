<template>
  <div class="space-y-8">
    <div class="bg-white/70 backdrop-blur-lg rounded-2xl p-8 shadow-lg border border-gray-200">
      <h1 class="text-3xl font-bold text-gray-900">Paramètres</h1>
      <p class="mt-2 text-lg text-gray-600">
        Gérez vos paramètres de sécurité
      </p>

      <!-- Modification du mot de passe -->
      <div class="mt-8 max-w-md">
        <h2 class="text-xl font-semibold text-gray-900">Modifier le mot de passe</h2>
        <form @submit.prevent="updatePassword" class="mt-6 space-y-6">
          <div>
            <label class="block text-sm font-medium text-gray-700">Ancien mot de passe</label>
            <input
              v-model="passwordForm.current"
              type="password"
              class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
            />
            <p v-if="errors.current" class="mt-1 text-sm text-red-600">{{ errors.current }}</p>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700">Nouveau mot de passe</label>
            <input
              v-model="passwordForm.new"
              type="password"
              class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
            />
            <p v-if="errors.new" class="mt-1 text-sm text-red-600">{{ errors.new }}</p>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700">Confirmer le nouveau mot de passe</label>
            <input
              v-model="passwordForm.confirm"
              type="password"
              class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
            />
            <p v-if="errors.confirm" class="mt-1 text-sm text-red-600">{{ errors.confirm }}</p>
          </div>

          <div>
            <button
              type="submit"
              :disabled="isSubmitting"
              class="w-full px-4 py-2 border border-transparent text-sm font-medium rounded-lg text-white bg-primary-500 hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 disabled:opacity-50"
            >
              {{ isSubmitting ? 'Modification...' : 'Modifier le mot de passe' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useToast } from 'vue-toastification'
import { supabase } from '../lib/supabase'
import { z } from 'zod'

const toast = useToast()
const isSubmitting = ref(false)
const errors = ref<Record<string, string>>({})

const passwordForm = ref({
  current: '',
  new: '',
  confirm: ''
})

const passwordSchema = z.object({
  current: z.string().min(1, 'Le mot de passe actuel est requis'),
  new: z.string().min(6, 'Le nouveau mot de passe doit contenir au moins 6 caractères'),
  confirm: z.string().min(1, 'La confirmation du mot de passe est requise')
}).refine((data) => data.new === data.confirm, {
  message: "Les mots de passe ne correspondent pas",
  path: ["confirm"]
})

const updatePassword = async () => {
  errors.value = {}
  isSubmitting.value = true

  try {
    const result = passwordSchema.safeParse(passwordForm.value)
    if (!result.success) {
      errors.value = result.error.formErrors.fieldErrors
      return
    }

    const { error } = await supabase.auth.updateUser({
      password: passwordForm.value.new
    })

    if (error) throw error

    toast.success('Mot de passe modifié avec succès')
    passwordForm.value = {
      current: '',
      new: '',
      confirm: ''
    }
  } catch (error) {
    console.error('Erreur lors de la modification du mot de passe:', error)
    toast.error('Une erreur est survenue lors de la modification du mot de passe')
  } finally {
    isSubmitting.value = false
  }
}
</script>