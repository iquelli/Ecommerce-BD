function incrementOffset() {
  const urlParams = new URLSearchParams(window.location.search);
  let offset = parseInt(urlParams.get("offset") || 0);
  offset += 10;
  urlParams.set("offset", offset);
  window.location.search = urlParams.toString();
}

function decrementOffset() {
  const urlParams = new URLSearchParams(window.location.search);
  let offset = parseInt(urlParams.get("offset") || 0);
  offset -= 10;
  if (offset < 0) {
    offset = 0; // set minimum offset value to 0
  }
  urlParams.set("offset", offset);
  window.location.search = urlParams.toString();
}
