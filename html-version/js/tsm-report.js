document.addEventListener('DOMContentLoaded', function () {
    initializeNavigation();
    initializeTSMCollapse();
    initializeTSMExportModal();
    initializeTSMTableSorting();
    initializeTSMFilters();
});

function initializeNavigation() {
    const navDrawer = document.getElementById('navDrawer');
    const menuBtn = document.querySelector('.nav-menu-btn');
    const profileBtn = document.querySelector('.profile-btn');
    const drawerItems = document.querySelectorAll('.drawer-item[data-page]');

    if (menuBtn && navDrawer) {
        menuBtn.addEventListener('click', function () {
            navDrawer.classList.toggle('open');
            document.body.style.overflow = navDrawer.classList.contains('open') ? 'hidden' : '';
        });
    }

    document.addEventListener('click', function (e) {
        if (navDrawer && menuBtn && !navDrawer.contains(e.target) && !menuBtn.contains(e.target)) {
            navDrawer.classList.remove('open');
            document.body.style.overflow = '';
        }
    });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && navDrawer) {
            navDrawer.classList.remove('open');
            document.body.style.overflow = '';
        }
    });

    drawerItems.forEach(function (item) {
        item.addEventListener('click', function () {
            const page = this.getAttribute('data-page');
            navigateToPage(page);
        });
    });

    const profileDropdown = document.getElementById('profileDropdown');
    if (profileBtn && profileDropdown) {
        profileBtn.addEventListener('click', function (event) {
            event.stopPropagation();
            profileDropdown.classList.toggle('show');
        });

        document.addEventListener('click', function (event) {
            if (!profileBtn.contains(event.target) && !profileDropdown.contains(event.target)) {
                profileDropdown.classList.remove('show');
            }
        });

        document.querySelectorAll('.profile-option').forEach(function (option) {
            option.addEventListener('click', function () {
                const action = this.getAttribute('data-action');
                if (action === 'invitations') {
                    window.location.href = 'invitation.html';
                } else if (action === 'logout') {
                    showLogoutDialog();
                }
                profileDropdown.classList.remove('show');
            });
        });
    }
}

function navigateToPage(page) {
    switch (page) {
        case 'dashboard':
            window.location.href = 'dashboard.html';
            break;
        case 'patients':
            window.location.href = 'patients.html';
            break;
        case 'quality-scorecards':
            window.location.href = 'quality-scorecards.html';
            break;
        case 'reports':
            window.location.href = 'reports.html';
            break;
        case 'resources':
            window.location.href = 'resources.html';
            break;
        default:
            console.log('Page not implemented yet:', page);
    }
}

function initializeTSMCollapse() {
    const btn = document.getElementById('tsmCollapseBtn');
    const wrapper = document.getElementById('tsm-report-table');
    if (!btn || !wrapper) return;

    btn.addEventListener('click', function (e) {
        e.preventDefault();
        const collapsed = wrapper.classList.toggle('collapsed');
        wrapper.classList.toggle('expanded', !collapsed);
        btn.classList.toggle('collapsed', collapsed);
    });
}

function initializeTSMExportModal() {
    const exportModal = document.getElementById('tsmExportModal');
    const exportLink = document.getElementById('tsmExportLink');
    const closeBtn = document.getElementById('tsmCloseExportModal');
    const cancelBtn = document.getElementById('tsmCancelExport');
    const applyBtn = document.getElementById('tsmApplyExport');
    const selectAllCheckbox = document.getElementById('tsmSelectAll');
    const fieldCheckboxes = document.querySelectorAll('.tsm-field-cb');

    if (!exportModal || !exportLink) return;

    function showExportModal() {
        exportModal.classList.add('show');
        document.body.style.overflow = 'hidden';
    }

    function hideExportModal() {
        exportModal.classList.remove('show');
        document.body.style.overflow = '';
    }

    exportLink.addEventListener('click', function (e) {
        e.preventDefault();
        showExportModal();
    });

    if (closeBtn) closeBtn.addEventListener('click', hideExportModal);
    if (cancelBtn) cancelBtn.addEventListener('click', hideExportModal);

    exportModal.addEventListener('click', function (e) {
        if (e.target === exportModal) hideExportModal();
    });

    if (selectAllCheckbox) {
        selectAllCheckbox.addEventListener('change', function () {
            fieldCheckboxes.forEach(function (cb) {
                cb.checked = selectAllCheckbox.checked;
            });
        });
    }

    fieldCheckboxes.forEach(function (checkbox) {
        checkbox.addEventListener('change', function () {
            const allChecked = Array.from(fieldCheckboxes).every(function (cb) {
                return cb.checked;
            });
            const anyChecked = Array.from(fieldCheckboxes).some(function (cb) {
                return cb.checked;
            });
            selectAllCheckbox.checked = allChecked;
            selectAllCheckbox.indeterminate = anyChecked && !allChecked;
        });
    });

    if (applyBtn) {
        applyBtn.addEventListener('click', function () {
            const selected = Array.from(fieldCheckboxes)
                .filter(function (cb) {
                    return cb.checked;
                })
                .map(function (cb) {
                    return cb.id;
                });
            console.log('TSM export fields:', selected);
            alert('Export (demo): ' + selected.join(', '));
            hideExportModal();
        });
    }
}

function parseMMDDYYYY(str) {
    const p = str.split('-');
    if (p.length !== 3) return 0;
    return new Date(parseInt(p[2], 10), parseInt(p[0], 10) - 1, parseInt(p[1], 10)).getTime();
}

function sortTSMTable(column, ascending) {
    const table = document.getElementById('tsmReportsTable');
    if (!table) return;
    const tbody = table.querySelector('tbody');
    const rows = Array.from(tbody.querySelectorAll('tr'));

    rows.sort(function (a, b) {
        const av = a.children[column].textContent.trim();
        const bv = b.children[column].textContent.trim();
        let cmp = 0;
        if (column === 1) {
            cmp = parseMMDDYYYY(av) - parseMMDDYYYY(bv);
        } else if (column === 5) {
            const an = parseInt(av.replace(/\D/g, ''), 10) || 0;
            const bn = parseInt(bv.replace(/\D/g, ''), 10) || 0;
            cmp = an - bn;
        } else {
            cmp = av.localeCompare(bv, undefined, { sensitivity: 'base' });
        }
        return ascending ? cmp : -cmp;
    });

    rows.forEach(function (row) {
        tbody.appendChild(row);
    });
}

function initializeTSMTableSorting() {
    const table = document.getElementById('tsmReportsTable');
    if (!table) return;
    const sortableHeaders = table.querySelectorAll('thead tr:first-child th.sortable');

    sortableHeaders.forEach(function (header) {
        header.addEventListener('click', function () {
            const column = Array.from(this.parentElement.children).indexOf(this);
            const isAscending = !this.classList.contains('sort-asc');

            sortableHeaders.forEach(function (h) {
                h.classList.remove('sort-asc', 'sort-desc');
            });

            this.classList.add(isAscending ? 'sort-asc' : 'sort-desc');
            sortTSMTable(column, isAscending);
        });
    });
}

function inputDateToMDY(ymd) {
    if (!ymd) return '';
    var parts = ymd.split('-');
    if (parts.length !== 3) return '';
    var y = parts[0];
    var m = parts[1];
    var d = parts[2];
    return m + '-' + d + '-' + y;
}

function initializeTSMFilters() {
    var tbody = document.querySelector('#tsmReportsTable tbody');
    if (!tbody) return;

    var originalRows = [];

    function captureRows() {
        originalRows = Array.from(tbody.querySelectorAll('tr')).map(function (row) {
            var cells = row.querySelectorAll('td');
            return {
                name: cells[0] ? cells[0].textContent.trim() : '',
                dob: cells[1] ? cells[1].textContent.trim() : '',
                mco: cells[2] ? cells[2].textContent.trim() : '',
                status: cells[3] ? cells[3].textContent.trim() : '',
                measure: cells[4] ? cells[4].textContent.trim() : '',
                phone: cells[5] ? cells[5].textContent.trim() : '',
                element: row
            };
        });
    }

    function applyFilters() {
        var nameF = (document.getElementById('tsmNameFilter') && document.getElementById('tsmNameFilter').value.toLowerCase()) || '';
        var dobInput = document.getElementById('tsmDobFilter');
        var dobTarget = dobInput && dobInput.value ? inputDateToMDY(dobInput.value) : '';
        var mcoF = (document.getElementById('tsmMcoFilter') && document.getElementById('tsmMcoFilter').value) || '';
        var statusF = (document.getElementById('tsmStatusFilter') && document.getElementById('tsmStatusFilter').value) || '';
        var measureF = (document.getElementById('tsmMeasureFilter') && document.getElementById('tsmMeasureFilter').value) || '';
        var phoneF = (document.getElementById('tsmPhoneFilter') && document.getElementById('tsmPhoneFilter').value.replace(/\D/g, '')) || '';

        originalRows.forEach(function (item) {
            var show = true;
            if (nameF && item.name.toLowerCase().indexOf(nameF) === -1) show = false;
            if (dobTarget && item.dob !== dobTarget) show = false;
            if (mcoF && item.mco !== mcoF) show = false;
            if (statusF && item.status !== statusF) show = false;
            if (measureF && item.measure !== measureF) show = false;
            if (phoneF && item.phone.replace(/\D/g, '').indexOf(phoneF) === -1) show = false;
            item.element.style.display = show ? '' : 'none';
        });
    }

    captureRows();

    document.querySelectorAll('#tsmReportsTable .column-filter').forEach(function (el) {
        el.addEventListener('input', applyFilters);
        el.addEventListener('change', applyFilters);
    });
}

function logout() {
    showLogoutDialog();
}

function showLogoutDialog() {
    var logoutDialog = document.getElementById('logoutDialog');
    if (logoutDialog) {
        logoutDialog.classList.add('show');
        document.body.style.overflow = 'hidden';
    }
}

function closeLogoutDialog() {
    var logoutDialog = document.getElementById('logoutDialog');
    if (logoutDialog) {
        logoutDialog.classList.remove('show');
        document.body.style.overflow = '';
    }
}

function confirmLogout() {
    window.location.href = 'login.html';
}
