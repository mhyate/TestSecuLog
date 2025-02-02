<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { Users, Package, CalendarCheck, Plus, UserPlus, Trash2 } from 'lucide-vue-next'
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue'
import { useToast } from 'vue-toastification'
import { supabase } from '../lib/supabase'
import { z } from 'zod'

const toast = useToast()
const users = ref([])
const equipments = ref([])
const isSubmitting = ref(false)
const isEquipmentModalOpen = ref(false)
const isUserModalOpen = ref(false)

const filters = ref({
  idNumber: '',
  phone: '',
  name: ''
})

const stats = ref([
  { name: 'Utilisateurs', value: 0, icon: Users },
  { name: 'Équipements', value: 0, icon: Package },
  { name: 'Réservations', value: 0, icon: CalendarCheck }
])

const userForm = ref({
  email: '',
  password: '',
  first_name: '',
  last_name: '',
  phone: '',
  id_number: '',
  address: '',
  postal_code: '',
  city: '',
  role: 'borrower'
})

const userSchema = z.object({
  email: z.string().email('Email invalide'),
  password: z.string().min(6, 'Le mot de passe doit contenir au moins 6 caractères'),
  first_name: z.string().min(1, 'Le prénom est requis'),
  last_name: z.string().min(1, 'Le nom est requis'),
  phone: z.string().regex(/^0[1-9][0-9]{8}$/, 'Numéro de téléphone invalide'),
  id_number: z.string().regex(/^[A-Z0-9]{7}$/, 'Le matricule doit contenir 7 caractères alphanumériques'),
  address: z.string().min(1, 'L\'adresse est requise'),
  postal_code: z.string().regex(/^[0-9]{5}$/, 'Code postal invalide'),
  city: z.string().min(1, 'La ville est requise'),
  role: z.enum(['admin', 'borrower'])
})

const equipmentForm = ref({
  name: '',
  version: '',
  reference: '',
  photo_url: ''
})

const equipmentSchema = z.object({
  name: z.string().min(1, 'Le nom est requis').max(30, 'Le nom est trop long'),
  version: z.string().min(3, 'La version est requise').max(15, 'La version est trop longue'),
  reference: z.string().regex(/^(AN|AP|XX)\d{3}$/, 'La référence doit être au format AN000, AP000 ou XX000'),
  photo_url: z.string().url('L\'URL de la photo est invalide').optional().nullable()
})

const filteredUsers = computed(() => {
  return users.value.filter(user => {
    const matchIdNumber = user.id_number.toLowerCase().includes(filters.value.idNumber.toLowerCase())
    const matchPhone = user.phone?.toLowerCase().includes(filters.value.phone.toLowerCase())
    const matchName = (user.first_name + ' ' + user.last_name)
      .toLowerCase()
      .includes(filters.value.name.toLowerCase())

    return (
      (!filters.value.idNumber || matchIdNumber) &&
      (!filters.value.phone || matchPhone) &&
      (!filters.value.name || matchName)
    )
  })
})

const openUserModal = () => {
  userForm.value = {
    email: '',
    password: '',
    first_name: '',
    last_name: '',
    phone: '',
    id_number: '',
    address: '',
    postal_code: '',
    city: '',
    role: 'borrower'
  }
  isUserModalOpen.value = true
}

const closeUserModal = () => {
  isUserModalOpen.value = false
}

const openEquipmentModal = () => {
  equipmentForm.value = {
    name: '',
    version: '',
    reference: '',
    photo_url: ''
  }
  isEquipmentModalOpen.value = true
}

const closeEquipmentModal = () => {
  isEquipmentModalOpen.value = false
}

const createUser = async () => {
  isSubmitting.value = true

  try {
    // Validation des données
    const validatedData = userSchema.parse(userForm.value)

    // Vérifier si le matricule existe déjà
    const { data: existingUser } = await supabase
      .from('profiles')
      .select('id')
      .eq('id_number', validatedData.id_number.toUpperCase())
      .maybeSingle()

    if (existingUser) {
      toast.error('Ce matricule est déjà utilisé')
      return
    }

    // Créer l'utilisateur avec Supabase Auth
    const { data: authData, error: authError } = await supabase.auth.signUp({
      email: validatedData.email,
      password: validatedData.password
    })

    if (authError) throw authError

    if (!authData.user?.id) {
      throw new Error('Impossible de créer le compte')
    }

    // Créer le profil utilisateur
    const { error: profileError } = await supabase
      .from('profiles')
      .insert({
        id: authData.user.id,
        email: validatedData.email,
        first_name: validatedData.first_name,
        last_name: validatedData.last_name,
        phone: validatedData.phone,
        id_number: validatedData.id_number.toUpperCase(),
        address: validatedData.address,
        postal_code: validatedData.postal_code,
        city: validatedData.city,
        role: validatedData.role
      })

    if (profileError) throw profileError

    toast.success('Utilisateur créé avec succès')
    closeUserModal()
    fetchUsers()
  } catch (error) {
    console.error('Erreur lors de la création de l\'utilisateur:', error)
    toast.error('Erreur lors de la création de l\'utilisateur')
  } finally {
    isSubmitting.value = false
  }
}

const createEquipment = async () => {
  isSubmitting.value = true

  try {
    const validatedData = equipmentSchema.parse(equipmentForm.value)

    const { error } = await supabase
      .from('equipment')
      .insert(validatedData)

    if (error) throw error

    toast.success('Équipement ajouté avec succès')
    closeEquipmentModal()
    fetchEquipments()
  } catch (error) {
    console.error('Erreur lors de la création de l\'équipement:', error)
    toast.error('Erreur lors de la création de l\'équipement')
  } finally {
    isSubmitting.value = false
  }
}

const deleteEquipment = async (id: string) => {
  if (!confirm('Êtes-vous sûr de vouloir supprimer cet équipement ?')) {
    return
  }

  try {
    const { error } = await supabase
      .from('equipment')
      .delete()
      .eq('id', id)

    if (error) throw error

    toast.success('Équipement supprimé avec succès')
    fetchEquipments()
  } catch (error) {
    console.error('Erreur lors de la suppression de l\'équipement:', error)
    toast.error('Erreur lors de la suppression de l\'équipement')
  }
}

const fetchUsers = async () => {
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .order('created_at', { ascending: false })

    if (error) throw error

    users.value = data || []
    stats.value[0].value = data?.length || 0
  } catch (error) {
    console.error('Erreur lors du chargement des utilisateurs:', error)
    toast.error('Erreur lors du chargement des utilisateurs')
  }
}

const fetchEquipments = async () => {
  try {
    const { data, error } = await supabase
      .from('equipment')
      .select('*')
      .order('name')

    if (error) throw error

    equipments.value = data || []
    stats.value[1].value = data?.length || 0
  } catch (error) {
    console.error('Erreur lors du chargement des équipements:', error)
    toast.error('Erreur lors du chargement des équipements')
  }
}

const fetchStats = async () => {
  try {
    const { count, error } = await supabase
      .from('reservations')
      .select('*', { count: 'exact' })
    
    if (error) throw error
    
    stats.value[2].value = count || 0
  } catch (error) {
    console.error('Erreur lors du chargement des statistiques:', error)
    toast.error('Erreur lors du chargement des statistiques')
  }
}

onMounted(() => {
  fetchUsers()
  fetchEquipments()
  fetchStats()
})
</script>

<template>
  <div class="space-y-8">
    <!-- En-tête -->
    <div class="bg-white/70 backdrop-blur-lg rounded-2xl p-8 shadow-lg border border-gray-200">
      <h1 class="text-3xl font-bold text-gray-900">Administration</h1>
      <p class="mt-2 text-lg text-gray-600">
        Gérez les utilisateurs et les équipements
      </p>
    </div>

    <!-- Statistiques -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div
        v-for="(stat, index) in stats"
        :key="index"
        class="bg-white/70 backdrop-blur-lg rounded-2xl p-6 shadow-lg border border-gray-200"
      >
        <div class="flex items-center">
          <div class="flex-shrink-0">
            <component
              :is="stat.icon"
              class="h-8 w-8 text-primary-500"
              aria-hidden="true"
            />
          </div>
          <div class="ml-4">
            <h3 class="text-lg font-medium text-gray-900">{{ stat.name }}</h3>
            <p class="mt-1">
              <span class="text-2xl font-semibold text-primary-600">
                {{ stat.value }}
              </span>
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- Liste des utilisateurs -->
    <div class="bg-white/70 backdrop-blur-lg rounded-2xl p-8 shadow-lg border border-gray-200">
      <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-semibold text-gray-900">Utilisateurs</h2>
        <button
          @click="openUserModal()"
          class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg text-white bg-primary-500 hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
        >
          <UserPlus class="h-4 w-4 mr-2" />
          Ajouter un utilisateur
        </button>
      </div>

      <!-- Filtres -->
      <div class="mb-4 grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div>
          <label class="block text-sm font-medium text-gray-700">Recherche par matricule</label>
          <input
            v-model="filters.idNumber"
            type="text"
            placeholder="ABC1234"
            class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700">Recherche par téléphone</label>
          <input
            v-model="filters.phone"
            type="text"
            placeholder="0612345678"
            class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700">Recherche par nom/prénom</label>
          <input
            v-model="filters.name"
            type="text"
            placeholder="Rechercher..."
            class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
          />
        </div>
      </div>
      
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead>
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Utilisateur
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Contact
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Adresse
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Matricule
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Rôle
              </th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="user in filteredUsers" :key="user.id">
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="flex items-center">
                  <div>
                    <div class="text-sm font-medium text-gray-900">
                      {{ user.first_name }} {{ user.last_name }}
                    </div>
                    <div class="text-sm text-gray-500">{{ user.email }}</div>
                  </div>
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-gray-900">{{ user.phone }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-gray-900">{{ user.address }}</div>
                <div class="text-sm text-gray-500">{{ user.postal_code }} {{ user.city }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-gray-900">{{ user.id_number }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span
                  class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full"
                  :class="user.role === 'admin' ? 'bg-purple-100 text-purple-800' : 'bg-green-100 text-green-800'"
                >
                  {{ user.role }}
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Liste des équipements -->
    <div class="bg-white/70 backdrop-blur-lg rounded-2xl p-8 shadow-lg border border-gray-200">
      <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-semibold text-gray-900">Équipements</h2>
        <button
          @click="openEquipmentModal()"
          class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg text-white bg-primary-500 hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
        >
          <Plus class="h-4 w-4 mr-2" />
          Ajouter un équipement
        </button>
      </div>

      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <div
          v-for="equipment in equipments"
          :key="equipment.id"
          class="bg-white rounded-lg shadow overflow-hidden"
        >
          <div class="aspect-w-16 aspect-h-9">
            <img
              :src="equipment.photo_url || 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80'"
              :alt="equipment.name"
              class="object-cover"
            />
          </div>
          <div class="p-4">
            <div class="flex justify-between items-start">
              <div>
                <h3 class="text-lg font-medium text-gray-900">{{ equipment.name }}</h3>
                <p class="mt-1 text-sm text-gray-500">{{ equipment.version }}</p>
              </div>
              <button
                @click="deleteEquipment(equipment.id)"
                class="text-red-500 hover:text-red-700 transition-colors"
              >
                <Trash2 class="w-5 h-5" />
              </button>
            </div>
            <p class="mt-2 text-sm text-gray-600">{{ equipment.reference }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal d'ajout d'utilisateur -->
    <TransitionRoot appear :show="isUserModalOpen" as="template">
      <Dialog as="div" @close="closeUserModal" class="relative z-50">
        <TransitionChild
          enter="duration-300 ease-out"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="duration-200 ease-in"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
          <div class="fixed inset-0 bg-black/25" />
        </TransitionChild>

        <div class="fixed inset-0 overflow-y-auto">
          <div class="flex min-h-full items-center justify-center p-4">
            <TransitionChild
              enter="duration-300 ease-out"
              enter-from="opacity-0 scale-95"
              enter-to="opacity-100 scale-100"
              leave="duration-200 ease-in"
              leave-from="opacity-100 scale-100"
              leave-to="opacity-0 scale-95"
            >
              <DialogPanel class="w-full max-w-2xl transform overflow-hidden rounded-2xl bg-white p-6 text-left align-middle shadow-xl transition-all">
                <DialogTitle as="h3" class="text-lg font-medium leading-6 text-gray-900">
                  Ajouter un utilisateur
                </DialogTitle>

                <form @submit.prevent="createUser" class="mt-4">
                  <div class="grid grid-cols-2 gap-4">
                    <div>
                      <label class="block text-sm font-medium text-gray-700">Prénom</label>
                      <input
                        v-model="userForm.first_name"
                        type="text"
                        required
                        class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                      />
                    </div>

                    <div>
                      <label class="block text-sm font-medium text-gray-700">Nom</label>
                      <input
                        v-model="userForm.last_name"
                        type="text"
                        required
                        class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                      />
                    </div>

                    <div>
                      <label class="block text-sm font-medium text-gray-700">Email</label>
                      <input
                        v-model="userForm.email"
                        type="email"
                        required
                        class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                      />
                    </div>

                    <div>
                      <label class="block text-sm font-medium text-gray-700">Téléphone</label>
                      <input
                        v-model="userForm.phone"
                        type="tel"
                        required
                        placeholder="0612345678"
                        class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                      />
                    </div>

                    <div>
                      <label class="block text-sm font-medium text-gray-700">Matricule</label>
                      <input
                        v-model="userForm.id_number"
                        type="text"
                        required
                        placeholder="ABC1234"
                        class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                      />
                    </div>

                    <div>
                      <label class="block text-sm font-medium text-gray-700">Mot de passe provisoire</label>
                      <input
                        v-model="userForm.password"
                        type="text"
                        required
                        class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                      />
                    </div>

                    <div>
                      <label class="block text-sm font-medium text-gray-700">Adresse</label>
                      <input
                        v-model="userForm.address"
                        type="text"
                        required
                        class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                      />
                    </div>

                    <div>
                      <label class="block text-sm font-medium text-gray-700">Code postal</label>
                      <input
                        v-model="userForm.postal_code"
                        type="text"
                        required
                        placeholder="75000"
                        class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                      />
                    </div>

                    <div>
                      <label class="block text-sm font-medium text-gray-700">Ville</label>
                      <input
                        v-model="userForm.city"
                        type="text"
                        required
                        class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                      />
                    </div>

                    <div>
                      <label class="block text-sm font-medium text-gray-700">Rôle</label>
                      <select
                        v-model="userForm.role"
                        class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                      >
                        <option value="borrower">Utilisateur</option>
                        <option value="admin">Administrateur</option>
                      </select>
                    </div>
                  </div>

                  <div class="mt-6 flex justify-end space-x-3">
                    <button
                      type="button"
                      @click="closeUserModal"
                      class="px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 rounded-md"
                    >
                      Annuler
                    </button>
                    <button
                      type="submit"
                      :disabled="isSubmitting"
                      class="px-4 py-2 text-sm font-medium text-white bg-primary-500 hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 rounded-md disabled:opacity-50"
                    >
                      {{ isSubmitting ? 'Création...' : 'Créer' }}
                    </button>
                  </div>
                </form>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>

    <!-- Modal d'ajout d'équipement -->
    <TransitionRoot appear :show="isEquipmentModalOpen" as="template">
      <Dialog as="div" @close="closeEquipmentModal" class="relative z-50">
        <TransitionChild
          enter="duration-300 ease-out"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="duration-200 ease-in"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
          <div class="fixed inset-0 bg-black/25" />
        </TransitionChild>

        <div class="fixed inset-0 overflow-y-auto">
          <div class="flex min-h-full items-center justify-center p-4">
            <TransitionChild
              enter="duration-300 ease-out"
              enter-from="opacity-0 scale-95"
              enter-to="opacity-100 scale-100"
              leave="duration-200 ease-in"
              leave-from="opacity-100 scale-100"
              leave-to="opacity-0 scale-95"
            >
              <DialogPanel class="w-full max-w-md transform overflow-hidden rounded-2xl bg-white p-6 text-left align-middle shadow-xl transition-all">
                <DialogTitle as="h3" class="text-lg font-medium leading-6 text-gray-900">
                  Ajouter un équipement
                </DialogTitle>

                <form @submit.prevent="createEquipment" class="mt-4 space-y-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700">Nom</label>
                    <input
                      v-model="equipmentForm.name"
                      type="text"
                      required
                      class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                    />
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700">Version</label>
                    <input
                      v-model="equipmentForm.version"
                      type="text"
                      required
                      class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                    />
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700">Référence</label>
                    <input
                      v-model="equipmentForm.reference"
                      type="text"
                      required
                      placeholder="AN001"
                      class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                    />
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700">URL de la photo</label>
                    <input
                      v-model="equipmentForm.photo_url"
                      type="url"
                      class="mt-1 block w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                    />
                  </div>

                  <div class="mt-6 flex justify-end space-x-3">
                    <button
                      type="button"
                      @click="closeEquipmentModal"
                      class="px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 rounded-md"
                    >
                      Annuler
                    </button>
                    <button
                      type="submit"
                      :disabled="isSubmitting"
                      class="px-4 py-2 text-sm font-medium text-white bg-primary-500 hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 rounded-md disabled:opacity-50"
                    >
                      {{ isSubmitting ? 'Création...' : 'Créer' }}
                    </button>
                  </div>
                </form>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>
  </div>
</template>