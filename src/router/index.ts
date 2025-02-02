import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      component: () => import('../pages/Home.vue')
    },
    {
      path: '/about',
      component: () => import('../pages/About.vue')
    },
    {
      path: '/contact',
      component: () => import('../pages/Contact.vue')
    },
    {
      path: '/login',
      component: () => import('../pages/Login.vue'),
      meta: { requiresGuest: true }
    },
    {
      path: '/register',
      component: () => import('../pages/Register.vue'),
      meta: { requiresGuest: true }
    },
    {
      path: '/app',
      component: () => import('../layouts/Default.vue'),
      meta: { requiresAuth: true },
      children: [
        {
          path: '',
          component: () => import('../pages/Dashboard.vue')
        },
        {
          path: 'profile',
          component: () => import('../pages/Profile.vue')
        },
        {
          path: 'settings',
          component: () => import('../pages/Settings.vue')
        },
        {
          path: 'reservations',
          component: () => import('../pages/Reservations.vue')
        },
        {
          path: 'equipment',
          component: () => import('../pages/Equipment.vue')
        },
        {
          path: 'admin',
          component: () => import('../pages/Admin.vue'),
          meta: { requiresAdmin: true }
        }
      ]
    }
  ]
})

router.beforeEach(async (to) => {
  const authStore = useAuthStore()

  // Si la route nécessite un invité et que l'utilisateur est connecté
  if (to.meta.requiresGuest && authStore.user) {
    return '/app'
  }

  // Si la route nécessite l'authentification et que l'utilisateur n'est pas connecté
  if (to.meta.requiresAuth && !authStore.user) {
    return '/login'
  }

  // Si la route nécessite le rôle admin et que l'utilisateur n'est pas admin
  if (to.meta.requiresAdmin && authStore.profile?.role !== 'admin') {
    return '/app'
  }
})

export default router