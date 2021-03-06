import Vue  from 'vue'
import Vuex from 'vuex'
import support from '@/store/modules/support'
import auth from '@/store/modules/auth'
import user from '@/store/modules/user'
import ban from '@/store/modules/ban'

import * as mutations from '@/store/general/mutations'
import * as actions   from '@/store/general/actions'
import * as getters   from '@/store/general/getters'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {},
  mutations,
  actions,
  getters,
  modules: {
    support,
    auth,
    user,
    ban
  }
})