// Copy-to-clipboard for the wallet addresses. Same-origin file, no inline
// script (CSP script-src 'self'). The page works without it: addresses are
// select-all text and the QR codes are native details blocks.
(function () {
  "use strict";

  function showFeedback(button, message) {
    var card = button.closest(".coin");
    var feedback = card.querySelector(".copy-feedback");
    feedback.textContent = message;
    button.classList.add("copied");
    window.setTimeout(function () {
      feedback.textContent = "";
      button.classList.remove("copied");
    }, 2000);
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
          function () { showFeedback(button, "Copied"); },
          function () {
            showFeedback(button, fallbackCopy(text) ? "Copied" : "Copy failed: select the address instead");
          }
        );
      } else {
        showFeedback(button, fallbackCopy(text) ? "Copied" : "Copy failed: select the address instead");
      }
    });
  });
})();
