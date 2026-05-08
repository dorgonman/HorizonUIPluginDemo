(() => {
  function toggleGroup(header) {
    const body = header.nextElementSibling;
    const toggle = header.querySelector('.group-toggle');
    const isOpen = body.style.display !== 'none';
    body.style.display = isOpen ? 'none' : '';
    toggle.innerHTML = isOpen ? '&#9658;' : '&#9660;';
  }
  window.toggleGroup = toggleGroup;
  const search = document.getElementById('test-search');
  const status = document.getElementById('status-filter');
  const group = document.getElementById('group-filter');
  const count = document.getElementById('visible-count');
  const rows = Array.from(document.querySelectorAll('.test-row'));
  const detailRows = Array.from(document.querySelectorAll('.test-row-detail'));
  const groupHeaders = Array.from(document.querySelectorAll('.group-header'));
  for (const header of groupHeaders) {
    header.addEventListener('click', () => toggleGroup(header));
  }
  const update = () => {
    const q = (search.value || '').trim().toLowerCase();
    const s = status.value;
    const g = group.value;
    let visible = 0;
    for (const row of rows) {
      const matchSearch = !q || row.dataset.search.includes(q);
      const matchStatus = !s || row.dataset.status === s;
      const matchGroup = !g || row.dataset.group === g;
      const show = matchSearch && matchStatus && matchGroup;
      row.style.display = show ? '' : 'none';
      const detail = row.nextElementSibling;
      if (detail && detail.classList.contains('test-row-detail')) detail.style.display = show ? '' : 'none';
      if (show) visible += 1;
    }
    for (const detail of detailRows) {
      const previous = detail.previousElementSibling;
      if (!previous || !previous.classList.contains('test-row')) continue;
      detail.style.display = previous.style.display === 'none' ? 'none' : '';
    }
    for (const header of groupHeaders) {
      const body = header.nextElementSibling;
      const groupRows = body.querySelectorAll('.test-row');
      const anyVisible = Array.from(groupRows).some(r => r.style.display !== 'none');
      header.style.display = anyVisible ? '' : 'none';
      body.style.display = anyVisible ? '' : 'none';
    }
    count.textContent = `${visible} / ${rows.length} tests shown`;
  };
  search.addEventListener('input', update);
  status.addEventListener('change', update);
  group.addEventListener('change', update);
for (const container of document.querySelectorAll('.blend-container')) {
    const slider = container.querySelector('.blend-slider');
    const pct = container.querySelector('.blend-pct');
    const incoming = container.querySelector('.blend-layer-incoming');
    const updateBlend = () => {
      const value = Number(slider.value || 0);
      pct.textContent = value + '%';
      // Set opacity directly via inline style — no CSS !important conflicts since
      // all CSS rules that set .blend-layer-incoming opacity have been removed.
      incoming.style.opacity = String(value / 100);
    };
    slider.addEventListener('input', updateBlend);
    updateBlend();
  }
  update();
})();
