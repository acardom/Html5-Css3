function mostrar (encima){
    if (encima == 'yes'){
        document.getElementById("fondo_footer").style.display = "block";
        document.location.href = "#fondo_footer";
    }else{
        document.getElementById("fondo_footer").style.display = "none";
    }
}


window.addEventListener("scroll", () => {
  if (window.pageYOffset > 400) {
    document.getElementById("to-top").style.opacity = 1;
  } else {
    document.getElementById("to-top").style.opacity = 0;
  }
})