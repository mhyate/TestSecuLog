<template>
  <div class="min-h-screen bg-gradient-to-br from-primary-900 via-primary-800 to-primary-900 animate-gradient">
    <Navigation />
    
    <div class="flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
      <!-- Cercles décoratifs -->
      <div class="absolute inset-0 overflow-hidden">
        <div class="absolute -top-40 -right-40 w-80 h-80 bg-primary-500/20 rounded-full filter blur-3xl"></div>
        <div class="absolute -bottom-40 -left-40 w-80 h-80 bg-primary-700/20 rounded-full filter blur-3xl"></div>
      </div>

      <div class="w-full max-w-2xl space-y-8 relative">
        <!-- Logo et titre -->
        <div class="text-center">
          <div class="mx-auto h-16 w-16 relative animate-float">
            <div class="absolute inset-0 bg-primary-500/20 rounded-full filter blur-lg"></div>
            <div class="relative flex items-center justify-center h-full">
              <UserPlus class="h-8 w-8 text-white" />
            </div>
          </div>
          <h2 class="mt-6 text-3xl font-bold tracking-tight text-white">
            Créer un compte
          </h2>
          <p class="mt-2 text-sm text-primary-200">
            Rejoignez LocaMat et commencez à gérer vos équipements
          </p>
        </div>

        <!-- Formulaire -->
        <div class="backdrop-blur-lg bg-white/10 rounded-2xl p-8 shadow-2xl border border-white/20">
          <form class="space-y-6" @submit.prevent="handleSubmit">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <!-- Prénom -->
              <div>
                <label class="block text-sm font-medium text-primary-100">
                  Prénom
                </label>
                <div class="mt-1">
                  <input
                    v-model="form.first_name"
                    type="text"
                    required
                    class="block w-full rounded-xl border-0 bg-white/5 text-white shadow-sm ring-1 ring-inset ring-white/10 focus:ring-2 focus:ring-inset focus:ring-primary-500 sm:text-sm sm:leading-6"
                  />
                  <p v-if="errors.first_name" class="mt-1 text-sm text-red-400">{{ errors.first_name }}</p>
                </div>
              </div>

              <!-- Nom -->
              <div>
                <label class="block text-sm font-medium text-primary-100">
                  Nom
                </label>
                <div class="mt-1">
                  <input
                    v-model="form.last_name"
                    type="text"
                    required
                    class="block w-full rounded-xl border-0 bg-white/5 text-white shadow-sm ring-1 ring-inset ring-white/10 focus:ring-2 focus:ring-inset focus:ring-primary-500 sm:text-sm sm:leading-6"
                  />
                  <p v-if="errors.last_name" class="mt-1 text-sm text-red-400">{{ errors.last_name }}</p>
                </div>
              </div>

              <!-- Email -->
              <div>
                <label class="block text-sm font-medium text-primary-100">
                  Email
                </label>
                <div class="mt-1">
                  <input
                    v-model="form.email"
                    type="email"
                    required
                    class="block w-full rounded-xl border-0 bg-white/5 text-white shadow-sm ring-1 ring-inset ring-white/10 focus:ring-2 focus:ring-inset focus:ring-primary-500 sm:text-sm sm:leading-6"
                  />
                  <p v-if="errors.email" class="mt-1 text-sm text-red-400">{{ errors.email }}</p>
                </div>
              </div>

              <!-- Téléphone -->
              <div>
                <label class="block text-sm font-medium text-primary-100">
                  Téléphone
                </label>
                <div class="mt-1">
                  <input
                    v-model="form.phone"
                    type="tel"
                    required
                    placeholder="0612345678"
                    class="block w-full rounded-xl border-0 bg-white/5 text-white shadow-sm ring-1 ring-inset ring-white/10 focus:ring-2 focus:ring-inset focus:ring-primary-500 sm:text-sm sm:leading-6"
                  />
                  <p v-if="errors.phone" class="mt-1 text-sm text-red-400">{{ errors.phone }}</p>
                </div>
              </div>

              <!-- Matricule -->
              <div>
                <label class="block text-sm font-medium text-primary-100">
                  Matricule
                </label>
                <div class="mt-1">
                  <input
                    v-model="form.id_number"
                    type="text"
                    required
                    placeholder="ABC1234"
                    class="block w-full rounded-xl border-0 bg-white/5 text-white shadow-sm ring-1 ring-inset ring-white/10 focus:ring-2 focus:ring-inset focus:ring-primary-500 sm:text-sm sm:leading-6"
                  />
                  <p v-if="errors.id_number" class="mt-1 text-sm text-red-400">{{ errors.id_number }}</p>
                </div>
              </div>

              <!-- Adresse -->
              <div>
                <label class="block text-sm font-medium text-primary-100">
                  Adresse
                </label>
                <div class="mt-1">
                  <input
                    v-model="form.address"
                    type="text"
                    required
                    class="block w-full rounded-xl border-0 bg-white/5 text-white shadow-sm ring-1 ring-inset ring-white/10 focus:ring-2 focus:ring-inset focus:ring-primary-500 sm:text-sm sm:leading-6"
                  />
                  <p v-if="errors.address" class="mt-1 text-sm text-red-400">{{ errors.address }}</p>
                </div>
              </div>

              <!-- Code postal -->
              <div>
                <label class="block text-sm font-medium text-primary-100">
                  Code postal
                </label>
                <div class="mt-1">
                  <input
                    v-model="form.postal_code"
                    type="text"
                    required
                    placeholder="75000"
                    class="block w-full rounded-xl border-0 bg-white/5 text-white shadow-sm ring-1 ring-inset ring-white/10 focus:ring-2 focus:ring-inset focus:ring-primary-500 sm:text-sm sm:leading-6"
                  />
                  <p v-if="errors.postal_code" class="mt-1 text-sm text-red-400">{{ errors.postal_code }}</p>
                </div>
              </div>

              <!-- Ville -->
              <div>
                <label class="block text-sm font-medium text-primary-100">
                  Ville
                </label>
                <div class="mt-1">
                  <input
                    v-model="form.city"
                    type="text"
                    required
                    class="block w-full rounded-xl border-0 bg-white/5 text-white shadow-sm ring-1 ring-inset ring-white/10 focus:ring-2 focus:ring-inset focus:ring-primary-500 sm:text-sm sm:leading-6"
                  />
                  <p v-if="errors.city" class="mt-1 text-sm text-red-400">{{ errors.city }}</p>
                </div>
              </div>

              <!-- Mot de passe -->
              <div>
                <label class="block text-sm font-medium text-primary-100">
                  Mot de passe
                </label>
                <div class="mt-1">
                  <input
                    v-model="form.password"
                    type="password"
                    required
                    class="block w-full rounded-xl border-0 bg-white/5 text-white shadow-sm ring-1 ring-inset ring-white/10 focus:ring-2 focus:ring-inset focus:ring-primary-500 sm:text-sm sm:leading-6"
                  />
                  <p v-if="errors.password" class="mt-1 text-sm text-red-400">{{ errors.password }}</p>
                </div>
              </div>

              <!-- Confirmation mot de passe -->
              <div>
                <label class="block text-sm font-medium text-primary-100">
                  Confirmer le mot de passe
                </label>
                <div class="mt-1">
                  <input
                    v-model="form.passwordConfirm"
                    type="password"
                    required
                    class="block w-full rounded-xl border-0 bg-white/5 text-white shadow-sm ring-1 ring-inset ring-white/10 focus:ring-2 focus:ring-inset focus:ring-primary-500 sm:text-sm sm:leading-6"
                  />
                  <p v-if="errors.passwordConfirm" class="mt-1 text-sm text-red-400">{{ errors.passwordConfirm }}</p>
                </div>
              </div>
            </div>

            <div>
              <button
                type="submit"
                :disabled="isSubmitting"
                class="group relative flex w-full justify-center rounded-xl bg-primary-500 px-3 py-3 text-sm font-semibold text-white shadow-sm hover:bg-primary-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 ease-out hover:shadow-lg"
              >
                <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                  <UserPlus class="h-5 w-5 text-primary-300 group-hover:text-primary-200" aria-hidden="true" />
                </span>
                {{ isSubmitting ? 'Création du compte...' : 'Créer un compte' }}
              </button>
            </div>

            <div class="text-center mt-4">
              <p class="text-sm text-primary-200">
                Déjà un compte ?
                <router-link to="/login" class="font-medium text-primary-300 hover:text-primary-200">
                  Connectez-vous
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
import { UserPlus } from 'lucide-vue-next'
import { useRouter } from 'vue-router'
import { useToast } from 'vue-toastification'
import { z } from 'zod'
import { supabase } from '../lib/supabase'
import Navigation from '../components/Navigation.vue'

const router = useRouter()
const toast = useToast()
const isSubmitting = ref(false)
const errors = ref<Record<string, string>>({})

const form = ref({
  email: '',
  first_name: '',
  last_name: '',
  phone: '',
  id_number: '',
  address: '',
  postal_code: '',
  city: '',
  password: '',
  passwordConfirm: ''
})

const registerSchema = z.object({
  email: z.string().email('Adresse email invalide'),
  first_name: z.string().min(1, 'Le prénom est requis').max(30, 'Le prénom est trop long'),
  last_name: z.string().min(1, 'Le nom est requis').max(30, 'Le nom est trop long'),
  phone: z.string().regex(/^0[1-9][0-9]{8}$/, 'Numéro de téléphone invalide'),
  id_number: z.string().regex(/^[A-Z0-9]{7}$/, 'Le matricule doit contenir 7 caractères alphanumériques'),
  address: z.string().min(1, 'L\'adresse est requise'),
  postal_code: z.string().regex(/^[0-9]{5}$/, 'Code postal invalide'),
  city: z.string().min(1, 'La ville est requise'),
  password: z.string().min(6, 'Le mot de passe doit contenir au moins 6 caractères'),
  passwordConfirm: z.string()
}).refine((data) => data.password === data.passwordConfirm, {
  message: "Les mots de passe ne correspondent pas",
  path: ["passwordConfirm"],
})

const handleSubmit = async () => {
  errors.value = {}
  isSubmitting.value = true

  try {
    // Validation des données du formulaire
    const result = registerSchema.safeParse(form.value)
    if (!result.success) {
      errors.value = result.error.formErrors.fieldErrors
      isSubmitting.value = false
      return
    }

    // Vérifier si le matricule existe déjà
    const { data: existingUser } = await supabase
      .from('profiles')
      .select('id')
      .eq('id_number', form.value.id_number.toUpperCase())
      .maybeSingle()

    if (existingUser) {
      errors.value.id_number = 'Ce matricule est déjà utilisé'
      isSubmitting.value = false
      return
    }

    // Créer l'utilisateur avec Supabase Auth
    const { data: authData, error: authError } = await supabase.auth.signUp({
      email: form.value.email,
      password: form.value.password
    })

    if (authError) {
      if (authError.message === 'User already registered') {
        errors.value.email = 'Cette adresse email est déjà utilisée'
      } else {
        throw authError
      }
      isSubmitting.value = false
      return
    }

    if (!authData.user?.id) {
      throw new Error('Impossible de créer le compte')
    }

    // Créer le profil utilisateur
    const { error: profileError } = await supabase
      .from('profiles')
      .insert({
        id: authData.user.id,
        email: form.value.email,
        first_name: form.value.first_name,
        last_name: form.value.last_name,
        phone: form.value.phone,
        id_number: form.value.id_number.toUpperCase(),
        address: form.value.address,
        postal_code: form.value.postal_code,
        city: form.value.city,
        role: 'borrower'
      })

    if (profileError) {
      throw profileError
    }

    toast.success('Compte créé avec succès ! Vous pouvez maintenant vous connecter.')
    router.push('/login')
  } catch (error: any) {
    console.error('Erreur lors de la création du compte:', error)
    toast.error('Une erreur est survenue lors de la création du compte')
  } finally {
    isSubmitting.value = false
  }
}
</script>