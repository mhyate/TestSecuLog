import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '../lib/supabase'
import type { User } from '@supabase/supabase-js'
import type { Database } from '../lib/database.types'
import { useToast } from 'vue-toastification'

type Profile = Database['public']['Tables']['profiles']['Row']

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const profile = ref<Profile | null>(null)
  const loading = ref(true)
  const toast = useToast()

  async function initialize() {
    try {
      loading.value = true
      const { data: { session } } = await supabase.auth.getSession()
      
      if (session?.user) {
        user.value = session.user
        await fetchProfile(session.user.id)
      } else {
        user.value = null
        profile.value = null
      }
    } catch (error) {
      console.error('Error initializing auth:', error)
      user.value = null
      profile.value = null
    } finally {
      loading.value = false
    }

    supabase.auth.onAuthStateChange(async (_event, session) => {
      user.value = session?.user ?? null
      if (session?.user) {
        await fetchProfile(session.user.id)
      } else {
        profile.value = null
      }
    })
  }

  async function fetchProfile(userId: string) {
    try {
      const { data, error } = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle() // Use maybeSingle() instead of single() to handle missing profiles without error

      if (error) throw error

      profile.value = data
      return data
    } catch (error) {
      console.error('Error in fetchProfile:', error)
      profile.value = null
      return null
    }
  }

  async function signIn(email: string, password: string) {
    const { error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) throw error
  }

  async function signOut() {
    const { error } = await supabase.auth.signOut()
    if (error) throw error
    user.value = null
    profile.value = null
  }

  async function updateProfile(data: Partial<Profile>) {
    if (!user.value) return null

    try {
      const { error } = await supabase
        .from('profiles')
        .update(data)
        .eq('id', user.value.id)

      if (error) throw error

      return await fetchProfile(user.value.id)
    } catch (error) {
      console.error('Error updating profile:', error)
      toast.error('Erreur lors de la mise à jour du profil')
      return null
    }
  }

  async function updatePassword(newPassword: string) {
    try {
      const { error } = await supabase.auth.updateUser({
        password: newPassword
      })

      if (error) throw error
    } catch (error) {
      console.error('Error updating password:', error)
      toast.error('Erreur lors de la mise à jour du mot de passe')
      throw error
    }
  }

  return {
    user,
    profile,
    loading,
    initialize,
    fetchProfile,
    signIn,
    signOut,
    updateProfile,
    updatePassword
  }
})