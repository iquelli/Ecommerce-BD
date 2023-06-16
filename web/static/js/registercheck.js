document.addEventListener('DOMContentLoaded', function() {
  // Get the necessary elements
  const form = document.getElementById('registration-form');
  const mandatoryInputs = form.getElementsByClassName('mandatory');
  const registerButton = document.getElementById('register-button');

  // Function to check if all mandatory fields are completed
  function checkMandatoryFields() {
    for (let i = 0; i < mandatoryInputs.length; i++) {
      if (mandatoryInputs[i].value === '') {
        registerButton.classList.remove('enabled');
        return;
      }
    }
    registerButton.classList.add('enabled');
  }

  // Add event listeners to mandatory fields
  for (let i = 0; i < mandatoryInputs.length; i++) {
    mandatoryInputs[i].addEventListener('input', checkMandatoryFields);
  }

  // Add event listener to form submit event
  form.addEventListener('submit', function(event) {
    // Check if any mandatory fields are empty
    for (let i = 0; i < mandatoryInputs.length; i++) {
      if (mandatoryInputs[i].value === '') {
        event.preventDefault(); // Prevent form submission
        return;
      }
    }
    // All mandatory fields are completed, allow form submission
  });
  
  // Initially check if any mandatory fields are completed on page load
  checkMandatoryFields();
});