(() => {
  const toggle = document.querySelector('.menu-toggle');
  const nav = document.querySelector('#navigation');
  const main = document.querySelector('main');
  const footer = document.querySelector('footer');
  const closeMenu = () => {
    document.body.classList.remove('menu-open');
    toggle.setAttribute('aria-expanded', 'false');
    toggle.setAttribute('aria-label', 'Open Menu');
    main.inert = footer.inert = false;
  };
  toggle.addEventListener('click', () => {
    if (toggle.getAttribute('aria-expanded') === 'true') return closeMenu();
    document.body.classList.add('menu-open');
    toggle.setAttribute('aria-expanded', 'true');
    toggle.setAttribute('aria-label', 'Close Menu');
    main.inert = footer.inert = true;
  });
  document.addEventListener('keydown', event => {
    if (toggle.getAttribute('aria-expanded') !== 'true') return;
    if (event.key === 'Escape') { closeMenu(); toggle.focus(); }
    if (event.key === 'Tab') {
      const items = [document.querySelector('.brand'), toggle, ...nav.querySelectorAll('a')];
      const first = items[0], last = items[items.length - 1];
      if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last.focus(); }
      if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first.focus(); }
    }
  });
  matchMedia('(min-width: 768px)').addEventListener('change', event => { if (event.matches) closeMenu(); });
  const video = document.querySelector('#climbing-video');
  if (video) {
    const button = document.querySelector('.video-toggle');
    const update = () => { button.textContent = video.paused ? 'Play video' : 'Pause video'; };
    button.addEventListener('click', () => { if (video.paused) video.play().catch(update); else video.pause(); });
    video.addEventListener('play', update);
    video.addEventListener('pause', update);
    if (!matchMedia('(prefers-reduced-motion: reduce)').matches) video.play().catch(update);
  }
  const form = document.querySelector('#adventure-form');
  if (form) form.addEventListener('submit', event => {
    event.preventDefault();
    if (!form.reportValidity()) return;
    const data = new FormData(form);
    const body = `${data.get('message')}\n\n${data.get('first')} ${data.get('last')}\n${data.get('email')}`;
    const href = `mailto:chase@chasepopp.com?subject=${encodeURIComponent(data.get('subject'))}&body=${encodeURIComponent(body)}`;
    window.location.href = href;
    form.querySelector('.form-status').textContent = 'Your request is ready in your email app. Please review and send it there. If your email app did not open, email chase@chasepopp.com directly.';
  });
})();
