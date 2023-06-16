document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("registration-form");
  const mandatoryInputs = form.getElementsByClassName("mandatory");
  const registerButton = document.getElementById("register-button");

  function checkMandatoryFields() {
    for (let i = 0; i < mandatoryInputs.length; i++) {
      if (mandatoryInputs[i].value === "") {
        registerButton.classList.remove("enabled");
        return;
      }
    }
    registerButton.classList.add("enabled");
  }

  for (let i = 0; i < mandatoryInputs.length; i++) {
    mandatoryInputs[i].addEventListener("input", checkMandatoryFields);
  }

  form.addEventListener("submit", function (event) {
    for (let i = 0; i < mandatoryInputs.length; i++) {
      if (mandatoryInputs[i].value === "") {
        event.preventDefault(); // Prevent form submission
        return;
      }
    }
  });
  checkMandatoryFields();
});
