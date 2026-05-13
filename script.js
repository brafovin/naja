const teddy = document.getElementById("teddy");
const message = document.getElementById("message");
const armRight = document.getElementById("arm-right");
const title = document.querySelector("h1");

const messages = {
  wave: ["Huhu! 👋", "Hallo da drüben!", "Schön, dich zu sehen!"],
  blink: ["*blinzel*", "Bin ich müde…", "Sandmännchen war hier."],
  dance: ["Lalala 🎵", "Tanz mit mir!", "Disco-Teddy!"],
  hug: ["Komm her, du!", "Eine dicke Umarmung!", "Du bist toll."],
  ear: ["Hihi, das kitzelt!", "Meine Ohren!"],
  nose: ["Schnüff schnüff", "Beep!"],
  belly: ["Hihi, Bauch-Kitzeln!", "Magst du mich?"],
  body: ["Sanfter Streichler.", "Mhhh, gemütlich."],
};

function pick(list) {
  return list[Math.floor(Math.random() * list.length)];
}

function say(key) {
  if (!messages[key]) return;
  message.textContent = pick(messages[key]);
}

function runAnimation(className, duration = 1500) {
  teddy.classList.remove(className);
  // Reflow erzwingen, damit die Animation neu startet
  void teddy.offsetWidth;
  teddy.classList.add(className);
  setTimeout(() => teddy.classList.remove(className), duration);
}

// Buttons
document.querySelectorAll(".controls button").forEach((btn) => {
  btn.addEventListener("click", () => {
    const action = btn.dataset.action;
    say(action);
    switch (action) {
      case "wave":
        armRight.classList.remove("waving");
        void armRight.offsetWidth;
        armRight.classList.add("waving");
        setTimeout(() => armRight.classList.remove("waving"), 1900);
        break;
      case "blink":
        runAnimation("blinking", 2900);
        break;
      case "dance":
        runAnimation("dancing", 2500);
        break;
      case "hug":
        runAnimation("hugging", 1100);
        break;
    }
  });
});

// Klicks auf Körperteile
const hotspots = [
  { id: "ear-left", key: "ear" },
  { id: "ear-right", key: "ear" },
  { id: "head", key: "nose" },
  { id: "body", key: "belly" },
];

hotspots.forEach(({ id, key }) => {
  const el = document.getElementById(id);
  if (!el) return;
  el.style.cursor = "pointer";
  el.addEventListener("click", (e) => {
    e.stopPropagation();
    say(key);
    if (key === "ear") {
      el.style.transition = "transform 0.3s ease";
      el.style.transform = "scale(1.15)";
      setTimeout(() => (el.style.transform = ""), 300);
    }
  });
});

// Allgemeiner Klick auf den Teddy → blinzeln
teddy.addEventListener("click", () => {
  say("body");
});

// Titel umschalten: invertierte Farben
title.style.cursor = "pointer";
title.addEventListener("click", () => {
  document.body.classList.toggle("inverted");
});

// Automatisches Blinzeln alle paar Sekunden
function autoBlink() {
  const delay = 3000 + Math.random() * 4000;
  setTimeout(() => {
    runAnimation("blinking", 1500);
    autoBlink();
  }, delay);
}
autoBlink();
