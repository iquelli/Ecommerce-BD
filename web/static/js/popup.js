
function showPopUp(event) {
    event.preventDefault();

    curr_name=document.getElementById("curr-name");
    curr_price=document.getElementById("curr-price");
    curr_desc=document.getElementById("curr-desc");
    edit=document.getElementById("edit-button");

    new_name =document.getElementById("name");
    new_desc =document.getElementById("description");
    new_price=document.getElementById("price");
    finish=document.getElementById("finish-button");

    curr_name.style.display="none";
    curr_price.style.display="none";
    curr_desc.style.display="none";
    edit.style.display="none";

    new_name.style.display="block";
    new_price.style.display="block";
    new_desc.style.display="block";
    finish.style.display="block";
}