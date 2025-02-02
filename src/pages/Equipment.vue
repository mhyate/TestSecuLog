<template>
  <div class="space-y-8">
    <!-- En-tête -->
    <div class="bg-white/70 backdrop-blur-lg rounded-2xl p-6 border border-gray-200 shadow-lg">
      <h1 class="text-3xl font-bold text-gray-900">Équipements disponibles</h1>
      <p class="mt-2 text-lg text-gray-600">
        Découvrez tous nos équipements et réservez-les facilement
      </p>

      <!-- Filtres et recherche -->
      <div class="mt-6 flex flex-wrap gap-4">
        <div class="flex-1 min-w-[200px]">
          <input
            type="text"
            v-model="searchQuery"
            placeholder="Rechercher un équipement..."
            class="w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
          />
        </div>
        <div class="flex gap-4">
          <select
            v-model="availabilityFilter"
            class="rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
          >
            <option value="all">Tous les équipements</option>
            <option value="available">Disponibles uniquement</option>
            <option value="unavailable">Indisponibles uniquement</option>
          </select>
          <select
            v-model="sortBy"
            class="rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
          >
            <option value="name">Nom (A-Z)</option>
            <option value="nameDesc">Nom (Z-A)</option>
            <option value="quantityAsc">Quantité (croissant)</option>
            <option value="quantityDesc">Quantité (décroissant)</option>
          </select>
        </div>
      </div>
    </div>

    <!-- Liste des équipements -->
    <div v-if="loading" class="flex justify-center items-center py-12">
      <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-500"></div>
    </div>

    <div v-else-if="filteredEquipments.length === 0" class="bg-white/70 backdrop-blur-lg rounded-2xl p-8 shadow-lg border border-gray-200 text-center">
      <div class="max-w-md mx-auto">
        <PackageSearch class="w-12 h-12 text-gray-400 mx-auto" />
        <h3 class="mt-4 text-lg font-medium text-gray-900">Aucun équipement trouvé</h3>
        <p class="mt-2 text-gray-500">
          {{ searchQuery ? 'Essayez de modifier vos critères de recherche.' : 'Aucun équipement n\'est disponible pour le moment.' }}
        </p>
      </div>
    </div>

    <div v-else>
      <TransitionGroup
        name="equipment-list"
        tag="div"
        class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3"
      >
        <div
          v-for="equipment in filteredEquipments"
          :key="equipment.id"
          class="group bg-white/70 backdrop-blur-lg rounded-2xl border border-gray-200 shadow-lg overflow-hidden transition-all duration-300 hover:shadow-xl"
        >
          <div class="aspect-w-16 aspect-h-9 overflow-hidden">
            <img
              :src="equipment.photo_url || 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80'"
              :alt="equipment.name"
              class="object-cover transform transition-transform duration-300 group-hover:scale-105"
            />
          </div>
          <div class="p-6">
            <div class="flex items-center justify-between">
              <h3 class="text-lg font-semibold text-gray-900">{{ equipment.name }}</h3>
              <span 
                class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                :class="equipment.quantity > 0 ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'"
              >
                {{ equipment.quantity > 0 ? `${equipment.quantity} disponible${equipment.quantity > 1 ? 's' : ''}` : 'Indisponible' }}
              </span>
            </div>
            <div class="mt-2 space-y-2">
              <p class="text-sm text-gray-600">
                <span class="font-medium">Version:</span> {{ equipment.version }}
              </p>
              <p class="text-sm text-gray-500">
                <span class="font-medium">Ref:</span> {{ equipment.reference }}
              </p>
            </div>
            
            <div class="mt-4">
              <button
                @click="handleReservation(equipment)"
                :disabled="equipment.quantity === 0"
                class="w-full inline-flex justify-center items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg text-white bg-primary-500 hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <Calendar class="w-4 h-4 mr-2" />
                {{ equipment.quantity > 0 ? 'Réserver' : 'Indisponible' }}
              </button>
            </div>
          </div>
        </div>
      </TransitionGroup>
    </div>

    <!-- Modal de réservation -->
    <TransitionRoot appear :show="isReservationModalOpen" as="template">
      <Dialog as="div" @close="closeReservationModal" class="relative z-50">
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
                  Réserver {{ selectedEquipment?.name }}
                </DialogTitle>

                <div class="mt-4 space-y-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700">Quantité</label>
                    <select
                      v-model="reservationForm.quantity"
                      class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                    >
                      <option v-for="n in maxQuantity" :key="n" :value="n">{{ n }}</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700">Date de début</label>
                    <input
                      type="date"
                      v-model="reservationForm.start_date"
                      class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                      :min="today"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700">Date de fin</label>
                    <input
                      type="date"
                      v-model="reservationForm.end_date"
                      class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                      :min="reservationForm.start_date || today"
                    />
                  </div>
                </div>

                <div class="mt-6 flex justify-end space-x-3">
                  <button
                    @click="closeReservationModal"
                    class="px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 rounded-md"
                  >
                    Annuler
                  </button>
                  <button
                    @click="createReservation"
                    :disabled="isSubmitting || !isFormValid"
                    class="px-4 py-2 text-sm font-medium text-white bg-primary-500 hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 rounded-md disabled:opacity-50"
                  >
                    {{ isSubmitting ? 'Réservation...' : 'Confirmer la réservation' }}
                  </button>
                </div>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { Calendar, PackageSearch } from 'lucide-vue-next'
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue'
import { useToast } from 'vue-toastification'
import { useRouter } from 'vue-router'
import { supabase } from '../lib/supabase'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const toast = useToast()
const authStore = useAuthStore()

const loading = ref(true)
const equipments = ref([])
const selectedEquipment = ref(null)
const isSubmitting = ref(false)
const isReservationModalOpen = ref(false)
const maxQuantity = ref(1)
const searchQuery = ref('')
const availabilityFilter = ref('all')
const sortBy = ref('name')

const reservationForm = ref({
  quantity: 1,
  start_date: '',
  end_date: ''
})

const today = computed(() => {
  const date = new Date()
  return date.toISOString().split('T')[0]
})

const isFormValid = computed(() => {
  return (
    reservationForm.value.quantity > 0 &&
    reservationForm.value.start_date &&
    reservationForm.value.end_date &&
    reservationForm.value.start_date <= reservationForm.value.end_date
  )
})

const filteredEquipments = computed(() => {
  let filtered = [...equipments.value]

  // Filtre par recherche
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(e => 
      e.name.toLowerCase().includes(query) ||
      e.version.toLowerCase().includes(query) ||
      e.reference.toLowerCase().includes(query)
    )
  }

  // Filtre par disponibilité
  if (availabilityFilter.value === 'available') {
    filtered = filtered.filter(e => e.quantity > 0)
  } else if (availabilityFilter.value === 'unavailable') {
    filtered = filtered.filter(e => e.quantity === 0)
  }

  // Tri
  filtered.sort((a, b) => {
    switch (sortBy.value) {
      case 'name':
        return a.name.localeCompare(b.name)
      case 'nameDesc':
        return b.name.localeCompare(a.name)
      case 'quantityAsc':
        return a.quantity - b.quantity
      case 'quantityDesc':
        return b.quantity - a.quantity
      default:
        return 0
    }
  })

  return filtered
})

const fetchEquipments = async () => {
  try {
    loading.value = true
    const { data, error } = await supabase
      .from('equipment')
      .select('*')
      .order('name')

    if (error) throw error

    equipments.value = data
  } catch (error) {
    console.error('Erreur lors du chargement des équipements:', error)
    toast.error('Erreur lors du chargement des équipements')
  } finally {
    loading.value = false
  }
}

const handleReservation = async (equipment) => {
  if (!authStore.user) {
    router.push('/login')
    return
  }

  // Vérifier que le profil existe
  const { data: profile } = await supabase
    .from('profiles')
    .select('id')
    .eq('id', authStore.user.id)
    .maybeSingle()

  if (!profile) {
    toast.error('Profil utilisateur non trouvé')
    return
  }

  selectedEquipment.value = equipment
  maxQuantity.value = equipment.quantity
  reservationForm.value = {
    quantity: 1,
    start_date: '',
    end_date: ''
  }
  isReservationModalOpen.value = true
}

const closeReservationModal = () => {
  selectedEquipment.value = null
  isReservationModalOpen.value = false
  reservationForm.value = {
    quantity: 1,
    start_date: '',
    end_date: ''
  }
}

const createReservation = async () => {
  if (!isFormValid.value) {
    toast.error('Veuillez remplir tous les champs correctement')
    return
  }

  isSubmitting.value = true

  try {
    // Vérifier la disponibilité
    const { data: isAvailable } = await supabase
      .rpc('check_equipment_availability', {
        p_equipment_id: selectedEquipment.value.id,
        p_start_date: reservationForm.value.start_date,
        p_end_date: reservationForm.value.end_date
      })

    if (!isAvailable) {
      toast.error('L\'équipement n\'est pas disponible pour ces dates')
      return
    }

    // Créer la réservation
    const { error: reservationError } = await supabase
      .from('reservations')
      .insert({
        equipment_id: selectedEquipment.value.id,
        user_id: authStore.user?.id,
        start_date: reservationForm.value.start_date,
        end_date: reservationForm.value.end_date,
        quantity: reservationForm.value.quantity,
        status: 'pending'
      })

    if (reservationError) throw reservationError

    // Mettre à jour la quantité de l'équipement
    const { error: updateError } = await supabase
      .from('equipment')
      .update({ 
        quantity: selectedEquipment.value.quantity - reservationForm.value.quantity 
      })
      .eq('id', selectedEquipment.value.id)

    if (updateError) throw updateError

    // Mettre à jour l'équipement dans la liste locale
    const index = equipments.value.findIndex(e => e.id === selectedEquipment.value.id)
    if (index !== -1) {
      equipments.value[index] = {
        ...equipments.value[index],
        quantity: equipments.value[index].quantity - reservationForm.value.quantity
      }
    }

    toast.success('Réservation créée avec succès')
    closeReservationModal()
    router.push('/app/reservations')
  } catch (error) {
    console.error('Erreur lors de la création de la réservation:', error)
    toast.error('Une erreur est survenue lors de la création de la réservation')
  } finally {
    isSubmitting.value = false
  }
}

// Charger les équipements au montage du composant
onMounted(() => {
  fetchEquipments()
})
</script>

<style scoped>
.equipment-list-enter-active,
.equipment-list-leave-active {
  transition: all 0.5s ease;
}

.equipment-list-enter-from,
.equipment-list-leave-to {
  opacity: 0;
  transform: translateY(30px);
}

.equipment-list-move {
  transition: transform 0.5s ease;
}
</style>