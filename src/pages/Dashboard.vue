<template>
  <div class="space-y-8" v-motion-slide-visible-once>
    <!-- En-tête -->
    <div class="bg-white/70 backdrop-blur-lg rounded-2xl p-8 shadow-lg border border-gray-200">
      <h1 class="text-3xl font-bold text-gray-900">
        Bonjour, {{ authStore.profile?.first_name }} !
      </h1>
      <p class="mt-2 text-lg text-gray-600">
        Bienvenue sur votre tableau de bord LocaMat
      </p>
    </div>

    <!-- Statistiques -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <router-link
        v-for="(stat, index) in stats"
        :key="index"
        :to="stat.to"
        class="bg-white/70 backdrop-blur-lg rounded-2xl p-6 shadow-lg border border-gray-200 transition-all duration-300 hover:shadow-xl hover:scale-105 cursor-pointer"
        v-motion-slide-visible-once
        :delay="100 * index"
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
      </router-link>
    </div>

    <!-- Liste des équipements disponibles -->
    <div class="bg-white/70 backdrop-blur-lg rounded-2xl p-8 shadow-lg border border-gray-200">
      <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-semibold text-gray-900">
          Équipements disponibles
        </h2>
        <router-link
          to="/app/equipment"
          class="text-primary-600 hover:text-primary-700 font-medium flex items-center"
        >
          Voir tous
          <ArrowRight class="ml-1 w-4 h-4" />
        </router-link>
      </div>
      
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <div
          v-for="equipment in availableEquipment"
          :key="equipment.id"
          class="bg-white rounded-lg shadow-md overflow-hidden transition-all duration-300 hover:shadow-lg"
        >
          <div class="aspect-w-16 aspect-h-9">
            <img
              :src="equipment.photo_url || 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80'"
              :alt="equipment.name"
              class="object-cover"
            />
          </div>
          <div class="p-4">
            <h3 class="text-lg font-medium text-gray-900">{{ equipment.name }}</h3>
            <p class="mt-1 text-sm text-gray-500">{{ equipment.version }}</p>
            <div class="mt-4">
              <button
                @click="reserveEquipment(equipment.id)"
                class="w-full inline-flex justify-center items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg text-white bg-primary-500 hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-all duration-200"
              >
                <Calendar class="w-4 h-4 mr-2" />
                Réserver
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Dernières réservations -->
    <div class="bg-white/70 backdrop-blur-lg rounded-2xl p-8 shadow-lg border border-gray-200">
      <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-semibold text-gray-900">
          Dernières réservations
        </h2>
        <router-link
          to="/app/reservations"
          class="text-primary-600 hover:text-primary-700 font-medium flex items-center"
        >
          Voir toutes
          <ArrowRight class="ml-1 w-4 h-4" />
        </router-link>
      </div>
      <div class="overflow-hidden">
        <div class="flow-root">
          <ul role="list" class="-my-5 divide-y divide-gray-200">
            <li
              v-for="reservation in recentReservations"
              :key="reservation.id"
              class="py-5"
            >
              <div class="relative focus-within:ring-2 focus-within:ring-primary-500">
                <h3 class="text-sm font-semibold text-gray-800">
                  <router-link :to="`/app/reservations/${reservation.id}`" class="hover:underline focus:outline-none">
                    {{ reservation.equipment }}
                  </router-link>
                </h3>
                <p class="mt-1 text-sm text-gray-600 line-clamp-2">
                  {{ reservation.dates }}
                </p>
                <div class="mt-2">
                  <span
                    :class="[
                      reservation.status === 'active' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800',
                      'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium'
                    ]"
                  >
                    {{ reservation.status === 'active' ? 'En cours' : 'En attente' }}
                  </span>
                </div>
              </div>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Monitor, Calendar, ArrowRight } from 'lucide-vue-next'
import { useAuthStore } from '../stores/auth'
import { useMotion } from '@vueuse/motion'
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useToast } from 'vue-toastification'
import { supabase } from '../lib/supabase'

const router = useRouter()
const toast = useToast()
const authStore = useAuthStore()

const availableEquipment = ref([])
const recentReservations = ref([])
const pendingReservationsCount = ref(0)
const activeReservationsCount = ref(0)
const availableEquipmentCount = ref(0)

// Stats dynamiques
const stats = computed(() => [
  { 
    name: 'Équipements disponibles', 
    value: availableEquipmentCount.value, 
    icon: Monitor, 
    to: '/app/equipment' 
  },
  { 
    name: 'Réservations actives', 
    value: activeReservationsCount.value, 
    icon: Calendar, 
    to: '/app/reservations' 
  },
  { 
    name: 'Réservations en attente', 
    value: pendingReservationsCount.value, 
    icon: Calendar, 
    to: '/app/reservations' 
  }
])

onMounted(async () => {
  // Charger les équipements disponibles
  const { data: equipment, error: equipmentError } = await supabase
    .from('equipment')
    .select('*')
    .limit(6)

  if (!equipmentError && equipment) {
    availableEquipment.value = equipment
    availableEquipmentCount.value = equipment.length
  }

  // Charger les réservations
  const { data: reservations, error: reservationsError } = await supabase
    .from('reservations')
    .select(`
      id,
      start_date,
      end_date,
      status,
      equipment (
        name
      )
    `)
    .eq('user_id', authStore.user?.id)
    .order('created_at', { ascending: false })
    .limit(3)

  if (!reservationsError && reservations) {
    recentReservations.value = reservations.map(r => ({
      id: r.id,
      equipment: r.equipment.name,
      dates: `Du ${new Date(r.start_date).toLocaleDateString()} au ${new Date(r.end_date).toLocaleDateString()}`,
      status: r.status
    }))

    // Compter les réservations par statut
    const { data: reservationCounts, error: countError } = await supabase
      .from('reservations')
      .select('status', { count: 'exact' })
      .eq('user_id', authStore.user?.id)
      .in('status', ['active', 'pending'])

    if (!countError && reservationCounts) {
      activeReservationsCount.value = reservationCounts.filter(r => r.status === 'active').length
      pendingReservationsCount.value = reservationCounts.filter(r => r.status === 'pending').length
    }
  }
})

const reserveEquipment = (equipmentId: string) => {
  router.push(`/app/equipment?reserve=${equipmentId}`)
}
</script>