<template>
  <div>
    <v-card class="elevation-1" outlined>
      <div class="px-4 custom-border">
        <v-row>
          <v-col class="mt-auto">
            <h2 class="font-weight-bold">Pending Psychologists</h2>
          </v-col>
          <v-col>
            <v-text-field
              class="pt-0 pr-5"
              hide-details
              :placeholder="$t('search')"
              v-model="search"
              @keyup="(search.length >= 3 || search.length == 0) && retrieveAllUsersBySearch()"
              @click="changeSearchColor('primary')"
              @blur="changeSearchColor('grey')"
            >
              <v-icon slot="append" :color="searchColor">mdi-magnify</v-icon>
            </v-text-field>
          </v-col>
        </v-row>
      </div>
      <v-divider></v-divider>
      <div>
        <div>
          <div class="custom-border" v-for="user of users" :key="user._id">
            <v-row class="px-2 elevation-0">
              <v-col class="col-lg-2 col-md-4 col-sm-6 col-12">
                <div class="caption text--secondary">Username</div>
                <div class="text-subtitle-2">{{ user.username }}</div>
              </v-col>

              <v-col class="col-lg-2 col-md-4 col-sm-6 col-12">
                <div class="caption text--secondary">Email</div>
                <div class="text-subtitle-2">{{ user.email }}</div>
              </v-col>

              <v-col class="col-lg-2 col-md-4 col-sm-6 col-12">
                <div class="caption text--secondary">Phone</div>
                <div class="text-subtitle-2">{{ user.phone }}</div>
              </v-col>

              <v-col class="col-lg-2 col-md-4 col-sm-6 col-12">
                <div class="caption text--secondary">Verified</div>
                <div>
                  <v-btn @click="verifyUser(user)" class="elevation-0" 
                      :color="user.isAccountVerified ? 'success' : 'error'" fab x-small>
                    <v-icon small> mdi-swap-horizontal-bold </v-icon>
                  </v-btn>
                </div>
              </v-col>

              <v-col class="col-lg-2 col-md-4 col-sm-6 col-12">
                <div class="caption text--secondary">Download CV/Transcript</div>
                <div>
                  <v-btn class="elevation-0" :href="user.cv" color="primary" x-small>
                     CV
                  </v-btn>
                  <v-btn class="elevation-0 mx-1" :href="user.transcript" color="primary" x-small>
                     Transcript
                  </v-btn>
                </div>
              </v-col>

              <v-col class="col-lg-2 col-md-4 col-sm-6 col-12">
                <div class="caption text--secondary">Accept/Deny</div>
                <div>
                  <v-btn @click="verifyPsychologist(user)" x-small class="elevation-0 mx-1" color="success" dark fab>
                    <v-icon>mdi-check-bold</v-icon>
                  </v-btn>
                  <v-btn @click="deleteUser(user)" x-small class="elevation-0 mx-1" color="error" dark fab>
                    <v-icon>mdi-close-thick</v-icon>
                  </v-btn>
                </div>
              </v-col>
            </v-row>
            <v-divider></v-divider>
          </div>
        </div>
      </div>
      <v-card-actions class="pa-0 custom-border">
        <v-container class="max-width">
          <v-pagination
            circle
            v-model="page"
            :length="totalPageCount"
          ></v-pagination>
        </v-container>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  created() {
    this.page = 1;
    this.retrieveAllUsers();
  },
  data() {
    return {
      page: 1,
      search: "",
      searchColor: "grey",
    };
  },
  methods: {
    changeSearchColor(color) {
      this.searchColor = color;
    },
    retrieveAllUsersBySearch() {
      this.page = 1
      this.retrieveAllUsers()
    },
    retrieveAllUsers() {
      this.$store.dispatch("retrieveAllUnverifiedPsychologists", {
        page: this.page,
        search: this.search,
      });
    },
    deleteUser(user) {
      this.$store.dispatch("deleteUser", {
        userId: user._id
      })
      .then(response => {
        this.$toast.success(response.message);
        this.refreshUsers()
      }) 
      .catch(error => {
        this.$toast.error(error)
      })
    },
    refreshUsers() {
      if (this.users.length == 1) { 
        this.page--
      }
      this.retrieveAllUsers()
    }, 
    verifyPsychologist(user) {
      this.$store.dispatch("updateUser", {
        userId: user._id,
        isPsychologistVerified: true
      })
      .then(response => {
        this.$toast.success(response.message);
        this.refreshUsers()
      }) 
      .catch(error => {
        this.$toast.error(error)
      })
    },
    verifyUser(user) {
      this.$store.dispatch('verifyUser', {
        isAccountVerified: !user.isAccountVerified,
        userId: user._id 
      })
      .then(response => {
        this.$toast.success(response.message)
        user.isAccountVerified = !user.isAccountVerified 
      })
      .catch(error => {
        this.$toast.error(error)
      })
    }
  },
  computed: {
    ...mapGetters({
      users: "getAllUsers",
      totalPageCount: "getAllUsersTotalPage",
      currentUser: "getCurrentUser",
    }),
  },
  watch : {
    page() {
      this.retrieveAllUsers()
    }
  }
};
</script>

<style>
.custom-border {
  border-left: solid 5px #3F51B5;
  border-radius: 1%;
}
</style>