<template>
  <div class="space-y-8">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold text-gray-900">Mes Réservations</h1>
      <router-link
        to="/app/equipment"
        class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg text-white bg-primary-500 hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-all duration-200"
      >
        <Plus class="w-4 h-4 mr-2" />
        Nouvelle réservation
      </router-link>
    </div>

    <!-- Liste des réservations -->
    <div class="bg-white rounded-lg shadow overflow-hidden">
      <TransitionGroup
        name="list"
        tag="ul"
        class="divide-y divide-gray-200"
      >
        <li
          v-for="reservation in visibleReservations"
          :key="reservation.id"
          class="p-4 hover:bg-gray-50 transition-colors"
        >
          <div class="flex items-center justify-between">
            <div class="flex-1 min-w-0">
              <div class="flex items-center">
                <img
                  :src="reservation.equipment.photo_url || 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80'"
                  alt=""
                  class="h-12 w-12 rounded-lg object-cover"
                />
                <div class="ml-4">
                  <h2 class="text-sm font-medium text-gray-900">
                    {{ reservation.equipment.name }}
                    <span class="text-gray-500">({{ reservation.quantity }} unité{{ reservation.quantity > 1 ? 's' : '' }})</span>
                  </h2>
                  <p class="text-sm text-gray-500">
                    Du {{ formatDate(reservation.start_date) }} au {{ formatDate(reservation.end_date) }}
                  </p>
                </div>
              </div>
            </div>
            <div class="flex items-center space-x-4">
              <span
                :class="[
                  statusClasses[reservation.status],
                  'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium'
                ]"
              >
                {{ statusLabels[reservation.status] }}
              </span>
              <div class="flex items-center space-x-2">
                <button
                  v-if="reservation.status === 'pending'"
                  @click="openEditModal(reservation)"
                  class="p-2 text-gray-400 hover:text-primary-500"
                >
                  <Pencil class="w-5 h-5" />
                </button>
                <button
                  v-if="reservation.status === 'pending'"
                  @click="cancelReservation(reservation)"
                  class="p-2 text-gray-400 hover:text-red-500"
                >
                  <X class="w-5 h-5" />
                </button>
              </div>
            </div>
          </div>
        </li>
      </TransitionGroup>
    </div>

    <!-- Modal de modification -->
    <TransitionRoot appear :show="isEditModalOpen" as="template">
      <Dialog as="div" @close="closeEditModal" class="relative z-50">
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
                  Modifier la réservation
                </DialogTitle>

                <div class="mt-4 space-y-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700">Quantité</label>
                    <select
                      v-model="editForm.quantity"
                      class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                    >
                      <option v-for="n in maxQuantity" :key="n" :value="n">{{ n }}</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700">Date de début</label>
                    <input
                      type="date"
                      v-model="editForm.start_date"
                      class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                      :min="today"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700">Date de fin</label>
                    <input
                      type="date"
                      v-model="editForm.end_date"
                      class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                      :min="editForm.start_date || today"
                    />
                  </div>
                </div>

                <div class="mt-6 flex justify-end space-x-3">
                  <button
                    @click="closeEditModal"
                    class="px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 rounded-md"
                  >
                    Annuler
                  </button>
                  <button
                    @click="updateReservation"
                    :disabled="isSubmitting || !isFormValid"
                    class="px-4 py-2 text-sm font-medium text-white bg-primary-500 hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 rounded-md disabled:opacity-50"
                  >
                    {{ isSubmitting ? 'Modification...' : 'Modifier' }}
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
import { Plus, X, Pencil } from 'lucide-vue-next'
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue'
import { useToast } from 'vue-toastification'
import { supabase } from '../lib/supabase'
import { useAuthStore } from '../stores/auth'

const toast = useToast()
const authStore = useAuthStore()

const reservations = ref([])
const isEditModalOpen = ref(false)
const isSubmitting = ref(false)
const selectedReservation = ref(null)
const maxQuantity = ref(1)

const editForm = ref({
  quantity: 1,
  start_date: '',
  end_date: ''
})

const statusLabels = {
  pending: 'En attente',
  active: 'En cours',
  completed: 'Terminée',
  cancelled: 'Annulée'
}

const statusClasses = {
  pending: 'bg-yellow-100 text-yellow-800',
  active: 'bg-green-100 text-green-800',
  completed: 'bg-blue-100 text-blue-800',
  cancelled: 'bg-red-100 text-red-800'
}

const today = computed(() => {
  const date = new Date()
  return date.toISOString().split('T')[0]
})

const isFormValid = computed(() => {
  return (
    editForm.value.quantity > 0 &&
    editForm.value.start_date &&
    editForm.value.end_date &&
    editForm.value.start_date <= editForm.value.end_date
  )
})

// Filtrer les réservations pour exclure celles qui sont annulées
const visibleReservations = computed(() => {
  return reservations.value.filter(r => r.status !== 'cancelled')
})

const formatDate = (date: string) => {
  return new Date(date).toLocaleDateString('fr-FR')
}

const fetchReservations = async () => {
  const { data, error } = await supabase
    .from('reservations')
    .select(`
      *,
      equipment (
        name,
        photo_url,
        quantity
      )
    `)
    .eq('user_id', authStore.user?.id)
    .order('created_at', { ascending: false })

  if (error) {
    toast.error('Erreur lors du chargement des réservations')
    return
  }

  reservations.value = data
}

const openEditModal = (reservation) => {
  selectedReservation.value = reservation
  maxQuantity.value = reservation.equipment.quantity + reservation.quantity
  editForm.value = {
    quantity: reservation.quantity,
    start_date: reservation.start_date.split('T')[0],
    end_date: reservation.end_date.split('T')[0]
  }
  isEditModalOpen.value = true
}

const closeEditModal = () => {
  selectedReservation.value = null
  isEditModalOpen.value = false
  editForm.value = {
    quantity: 1,
    start_date: '',
    end_date: ''
  }
}

const updateReservation = async () => {
  if (!isFormValid.value || !selectedReservation.value) return

  isSubmitting.value = true

  try {
    // Vérifier la disponibilité
    const { data: isAvailable } = await supabase
      .rpc('check_equipment_availability', {
        p_equipment_id: selectedReservation.value.equipment_id,
        p_start_date: editForm.value.start_date,
        p_end_date: editForm.value.end_date
      })

    if (!isAvailable) {
      toast.error('L\'équipement n\'est pas disponible pour ces dates')
      return
    }

    // Mettre à jour la réservation
    const { error: updateError } = await supabase
      .from('reservations')
      .update({
        quantity: editForm.value.quantity,
        start_date: editForm.value.start_date,
        end_date: editForm.value.end_date
      })
      .eq('id', selectedReservation.value.id)

    if (updateError) throw updateError

    // Mettre à jour la quantité de l'équipement
    const quantityDiff = selectedReservation.value.quantity - editForm.value.quantity
    const { error: equipmentError } = await supabase
      .from('equipment')
      .update({ 
        quantity: selectedReservation.value.equipment.quantity + quantityDiff 
      })
      .eq('id', selectedReservation.value.equipment_id)

    if (equipmentError) throw equipmentError

    toast.success('Réservation modifiée avec succès')
    await fetchReservations()
    closeEditModal()
  } catch (error) {
    console.error('Erreur lors de la modification de la réservation:', error)
    toast.error('Erreur lors de la modification de la réservation')
  } finally {
    isSubmitting.value = false
  }
}

const cancelReservation = async (reservation) => {
  try {
    // Mettre à jour la quantité de l'équipement
    const { error: equipmentError } = await supabase
      .from('equipment')
      .update({ 
        quantity: reservation.equipment.quantity + reservation.quantity 
      })
      .eq('id', reservation.equipment_id)

    if (equipmentError) throw equipmentError

    // Annuler la réservation
    const { error: reservationError } = await supabase
      .from('reservations')
      .update({ status: 'cancelled' })
      .eq('id', reservation.id)

    if (reservationError) throw reservationError

    // Attendre 2 secondes avant de rafraîchir la liste
    setTimeout(async () => {
      await fetchReservations()
    }, 2000)

    toast.success('Réservation annulée avec succès')
  } catch (error) {
    console.error('Erreur lors de l\'annulation de la réservation:', error)
    toast.error('Erreur lors de l\'annulation de la réservation')
  }
}

// Charger les réservations au montage du composant
onMounted(() => {
  fetchReservations()
})
</script>

<style scoped>
.list-enter-active,
.list-leave-active {
  transition: all 0.5s ease;
}

.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateX(30px);
}
</style>