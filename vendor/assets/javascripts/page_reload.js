
var prefix = window.addEventListener ? "" : "on";
var eventName = window.addEventListener ? "addEventListener" : "attachEvent";
document.body[eventName](prefix + "load", init, false);


$(init);
