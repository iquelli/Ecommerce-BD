function showPopUp(event, sku) {
  event.preventDefault();
  document.getElementById("popup-description").value = document.getElementById("curr-desc-" + sku).innerText;
  document.getElementById("popup-price").value = document.getElementById("curr-price-" + sku).innerText;
  document.getElementById("popup-sku").value = sku;
  document.getElementById("popupBackground").style.display = "flex";
}

function hidePopUp() {
  document.getElementById("popupBackground").style.display = "none";
}
