<template>
  <div class="container mt-5" style="max-width: 600px">
    <div v-if="alertMessage" :class="['alert', alertClass]" role="alert">
      {{ alertMessage }}
    </div>
    <div v-if="!isEditing" class="rating-component card p-3">
      <div class="progress mb-3">
        <div
          class="progress-bar progress-bar-striped progress-bar-animated bg-purple"
          role="progressbar"
          :style="{ width: showRating ? '100%' : '50%' }"
          aria-valuenow="50"
          aria-valuemin="0"
          aria-valuemax="100"
        ></div>
      </div>
      <h1 class="card-title text-left">
        How would you rate your satisfaction with our product?
      </h1>
      <div v-if="!showRating">
        <div class="form-group">
          <label for="fullName">Full Name</label>
          <input
            type="text"
            class="form-control"
            id="fullName"
            v-model="fullName"
            required
          />
        </div>
        <div class="form-group">
          <label for="email">Email</label>
          <input
            type="email"
            class="form-control"
            id="email"
            v-model="email"
            required
          />
        </div>
        <button class="btn btn-primary mt-3" @click="handleGiveRating">
          Give Rating
        </button>
      </div>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="ratingModal" tabindex="-1" aria-labelledby="ratingModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-body">
            <div v-if="alertMessage" :class="['alert', alertClass]" role="alert">
              {{ alertMessage }}
            </div>
            <div class="progress mb-3">
              <div
                class="progress-bar progress-bar-striped progress-bar-animated bg-purple"
                role="progressbar"
                style="width: 100%"
                aria-valuenow="100"
                aria-valuemin="0"
                aria-valuemax="100"
              ></div>
            </div>
            <h5 class="modal-title text-left" id="ratingModalLabel" style="font-size: 1.5rem; font-weight: bold;">
              How would you rate your satisfaction with our product?
            </h5>
            <div class="stars mt-3">
              <span v-for="star in 5" :key="star" @click="submitRating(star)">
                <i :class="star <= rating ? 'fas fa-star' : 'far fa-star'"></i>
                <span class="star-number">{{ star }}</span>
              </span>
            </div>
            <div class="labels d-flex justify-content-between mt-2" style="font-size: 0.8rem;">
              <span class="label-text">Very dissatisfied</span>
              <span class="label-text">Very satisfied</span>
            </div>
          </div>
          <div class="modal-footer">
            <button class="btn btn-primary me-lg-2" @click="submitFeedback" :disabled="isLoading">
              <span v-if="isLoading" class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
              <span v-if="isLoading">Loading...</span>
              <span v-else>Submit Feedback</span>
            </button>
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" @click="handleBack">
              Back
            </button>
          </div>
        </div>
      </div>
    </div>

    <div class="d-flex justify-content-center mt-5" v-if="!isEditing">
      <button
        class="btn toggle-btn"
        :class="showFeedback ? 'btn-success' : 'btn-secondary'"
        @click="toggleFeedback"
      >
        <i :class="showFeedback ? 'fas fa-eye-slash' : 'fas fa-eye'"></i>
        {{ showFeedback ? " Hide Latest Feedback" : " Show Latest Feedback" }}
      </button>
    </div>

    <div v-if="showFeedback && !isEditing" class="mt-5">
      <h2 class="text-center">Latest Feedback</h2>
      <div v-if="feedbackList.length === 0" class="text-center">
        No feedback available.
      </div>
      <div v-else class="feedback-list">
        <div
          v-for="feedback in feedbackList"
          :key="feedback.id"
          class="card mt-3"
        >
          <div class="card-body">
            <h5 class="card-title">{{ feedback.full_name }}</h5>
            <p class="card-text">
              Score:
              <span v-for="star in 5" :key="star">
                <i
                  :class="star <= feedback.score ? 'fas fa-star' : 'far fa-star'"
                ></i>
              </span>
            </p>
            <p class="card-text">Email: {{ feedback.email }}</p>
            <p class="card-text">
              Created At: {{ formatDate(feedback.created_at) }}
            </p>
            <p class="card-text">
              Updated At: {{ formatDate(feedback.updated_at) }}
            </p>
            <button class="btn btn-danger" @click="deleteFeedback(feedback.id)">
              Delete
            </button>
            <button class="btn btn-secondary" @click="editFeedback(feedback)">
              Edit
            </button>
          </div>
        </div>
      </div>
    </div>
    <div v-if="isEditing" class="container mt-5" style="max-width: 600px">
      <h2 class="text-center">Edit Feedback</h2>
      <div class="rating-component card p-3">
        <div class="form-group">
          <label for="editFullName">Full Name</label>
          <input
            type="text"
            class="form-control"
            id="editFullName"
            v-model="editFullName"
            required
          />
        </div>
        <div class="form-group">
          <label for="editEmail">Email</label>
          <input
            type="email"
            class="form-control"
            id="editEmail"
            v-model="editEmail"
            required
          />
        </div>
        <div class="stars">
          <span v-for="star in 5" :key="star" @click="editRating = star">
            <i :class="star <= editRating ? 'fas fa-star' : 'far fa-star'"></i>
            <span class="star-number">{{ star }}</span>
          </span>
        </div>
        <div class="labels d-flex justify-content-between mt-2">
          <span class="label-text">Very dissatisfied</span>
          <span class="label-text">Very satisfied</span>
        </div>
        <button class="btn btn-primary mt-3" @click="updateFeedback">
          Update Feedback
        </button>
        <button class="btn btn-secondary mt-3" @click="cancelEdit">
          Cancel
        </button>
      </div>
    </div>
    <footer class="text-center mt-5 mb-5">
      <h5>Developed by Dwi Didit Prasetiyo</h5>
    </footer>
  </div>
</template>

<script>
import axios from "axios";
import moment from "moment";
import * as bootstrap from "bootstrap";

export default {
  data() {
    return {
      rating: 0,
      fullName: "",
      email: "",
      alertMessage: null,
      alertClass: "alert-success",
      feedbackList: [],
      isEditing: false,
      editId: null,
      editRating: 0,
      editFullName: "",
      editEmail: "",
      showFeedback: false,
      showRating: false,
      isLoading: false,
    };
  },
  methods: {
    handleGiveRating() {
      if (!this.fullName || !this.email) {
        this.showAlert("Please fill in Full Name and Email", "alert-danger");
      } else if (!this.validateEmail(this.email)) {
        this.showAlert("Please enter a valid email address", "alert-danger");
      } else {
        this.showRating = true;
        const modal = new bootstrap.Modal(document.getElementById('ratingModal'), {
          backdrop: 'static',
          keyboard: false
        });
        modal.show();
      }
    },
    handleBack() {
      this.showRating = false;
      this.alertMessage = null;
    },
    validateEmail(email) {
      const re = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
      return re.test(email);
    },
    async submitRating(star) {
      this.rating = star;
    },
    async fetchFeedback() {
      try {
        const response = await axios.get(
          `${process.env.VUE_APP_BACKEND_URL}/feedback`
        );

        this.feedbackList = response.data.data
          .sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
          .slice(0, 4);
      } catch (error) {
        console.error("Error fetching feedback:", error);
      }
    },
    async submitFeedback() {
      if (this.rating === 0) {
        this.showAlert("Please rate your satisfaction first!", "alert-danger");
        return;
      }
      this.isLoading = true;
      try {
        const backendUrl = process.env.VUE_APP_BACKEND_URL;
        await axios.post(`${backendUrl}/feedback`, {
          score: this.rating,
          full_name: this.fullName,
          email: this.email,
        });
        this.showAlert("Feedback submitted successfully", "alert-success");
        this.resetForm();
        const modal = bootstrap.Modal.getInstance(document.getElementById('ratingModal'));
        modal.hide();
        await this.$router.push('/success');
      } catch (error) {
        console.error("Error submitting feedback:", error);
        this.showAlert("Error submitting feedback", "alert-danger");
        this.isLoading = false;
      }
    },
    async deleteFeedback(id) {
      console.log("Attempting to delete feedback with id:", id);
      try {
        await axios.delete(`${process.env.VUE_APP_BACKEND_URL}/feedback/${id}`);
        this.showAlert("Feedback deleted successfully", "alert-success");
        this.fetchFeedback();
      } catch (error) {
        console.error("Error deleting feedback:", error);
        this.showAlert("Error deleting feedback", "alert-danger");
      }
    },
    async editFeedback(feedback) {
      console.log("Attempting to edit feedback:", feedback);
      this.isEditing = true;
      this.editId = feedback.id;
      this.editRating = feedback.score;
      this.editFullName = feedback.full_name;
      this.editEmail = feedback.email;
    },
    async updateFeedback() {
      try {
        await axios.put(
          `${process.env.VUE_APP_BACKEND_URL}/feedback/${this.editId}`,
          {
            score: this.editRating,
            full_name: this.editFullName,
            email: this.editEmail,
          }
        );
        this.showAlert("Feedback updated successfully", "alert-success");
        this.fetchFeedback();
        this.isEditing = false;
        this.resetEditForm();
      } catch (error) {
        console.error("Error updating feedback:", error);
        this.showAlert("Error updating feedback", "alert-danger");
      }
    },
    cancelEdit() {
      this.isEditing = false;
      this.resetEditForm();
    },
    showAlert(message, alertClass) {
      this.alertMessage = message;
      this.alertClass = alertClass;
      setTimeout(() => {
        this.alertMessage = null;
      }, 3000);
    },
    resetForm() {
      this.rating = 0;
      this.fullName = "";
      this.email = "";
      this.showRating = false;
    },
    resetEditForm() {
      this.editId = null;
      this.editRating = 0;
      this.editFullName = "";
      this.editEmail = "";
    },
    toggleFeedback() {
      this.showFeedback = !this.showFeedback;
    },
    formatDate(date) {
      return moment(date).format("MMMM DD, YYYY, hh:mm A");
    },
  },
  mounted() {
    this.fetchFeedback();
  },
};
</script>

<style scoped>
.rating-component {
  background: white;
  padding: 20px;
  border-radius: 5px;
  text-align: center;
  font-family: Arial, sans-serif;
}

.card-title {
  font-size: 2rem;
  font-weight: bold;
}

.modal-title {
  font-size: 2rem;
  font-weight: bold;
  text-align: left;
}

.progress {
  height: 10px;
  margin-bottom: 20px;
}

.bg-purple {
  background-color: purple;
}

.stars {
  display: flex;
  justify-content: center;
  align-items: center;
  margin: 10px 0;
}

.stars span {
  cursor: pointer;
  font-size: 40px;
  margin: 0 10px;
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.star-number {
  font-size: 8px;
  color: grey;
}

.fas {
  color: gold;
}

.far {
  color: grey;
}

.labels {
  display: flex;
  justify-content: space-between;
  margin-top: 10px;
  width: 100%;
  padding: 0 15px;
  font-size: 0.8rem;
}

.label-text {
  font-size: 1.2rem;
  color: grey;
}

.d-flex {
  display: flex;
}

.justify-content-center {
  justify-content: center;
}

.mt-5 {
  margin-top: 3rem;
}

.btn-success {
  background-color: #28a745;
  border-color: #28a745;
  color: white;
}

.btn-success:hover {
  background-color: #218838;
  border-color: #1e7e34;
}

.btn-secondary {
  background-color: #6c757d;
  border-color: #6c757d;
  color: white;
}

.btn-secondary:hover {
  background-color: #5a6268;
  border-color: #545b62;
}

.toggle-btn {
  font-size: 1.2rem;
  font-weight: bold;
  padding: 10px 20px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.toggle-btn i {
  margin-right: 10px;
}

.feedback-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
  width: 100%;
}

.feedback-list .card {
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

footer {
  margin-bottom: 50px;
}
</style>
