<template>
  <button
    @click="goBack"
    class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg text-white bg-primary-600/20 hover:bg-primary-600/30 backdrop-blur-lg transition-all duration-200"
  >
    <ArrowLeft class="w-4 h-4 mr-2" />
    Retour
  </button>
</template>

<script setup lang="ts">
import { ArrowLeft } from 'lucide-vue-next'
import { useRouter } from 'vue-router'

const router = useRouter()

const goBack = () => {
  router.back()
}
</script>