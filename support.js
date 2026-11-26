// Copy-to-clipboard for the wallet addresses. Same-origin file, no inline
// script (CSP script-src 'self'). The page works without it: addresses are
// select-all text and the QR codes are native details blocks.
(function () {
  "use strict";

  function showFeedback(button, message, ok) {
    var card = button.closest(".coin");
    var feedback = card.querySelector(".copy-feedback");
    window.clearTimeout(button.copyTimer);
    feedback.textContent = message;
    button.classList.toggle("copied", ok);
    button.copyTimer = window.setTimeout(function () {
      feedback.textContent = "";
      button.classList.remove("copied");
    }, ok ? 2000 : 5000);
  }

  function report(button, text, viaClipboard) {
    var ok = viaClipboard || fallbackCopy(text);
    showFeedback(button, ok ? "Copied" : "Copy failed: select the address instead", ok);
  }

  // The nav list is a details block so it works without script. From 40rem up
  // the CSS shows it; where the browser lacks ::details-content, opening it
  // here keeps the links reachable. Narrow screens stay closed.
  var menu = document.querySelector(".nav-menu");
  if (menu && window.matchMedia) {
    var wide = window.matchMedia("(min-width: 40rem)");
    var sync = function () { menu.open = wide.matches; };
    sync();
    if (wide.addEventListener) { wide.addEventListener("change", sync); }
  }

  function fallbackCopy(text) {
    var area = document.createElement("textarea");
    area.value = text;
    area.setAttribute("readonly", "");
    area.className = "offscreen";
    document.body.appendChild(area);
    area.select();
    var ok = false;
    try {
      ok = document.execCommand("copy");
    } catch (e) {
      ok = false;
    }
    document.body.removeChild(area);
    return ok;
  }

  document.querySelectorAll(".copy-btn").forEach(function (button) {
    button.addEventListener("click", function () {
      var text = document.getElementById(button.dataset.copy).textContent;
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(
          function () { report(button, text, true); },
          function () { report(button, text, false); }
        );
      } else {
        report(button, text, false);
      }
    });
  });
})();
