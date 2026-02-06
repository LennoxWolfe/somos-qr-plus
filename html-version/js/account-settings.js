// Account Settings page
document.addEventListener('DOMContentLoaded', function() {
    initializeSearchableDropdown();
    initializeNavigation();
    initializeNotifications();
    initializeProfileOptions();
    initializeForms();
});

function initializeNavigation() {
    const menuBtn = document.querySelector('.nav-menu-btn');
    const profileBtn = document.querySelector('.profile-btn');
    const navDrawer = document.getElementById('navDrawer');
    const drawerOverlay = document.getElementById('drawerOverlay');

    if (menuBtn && navDrawer && drawerOverlay) {
        menuBtn.addEventListener('click', () => {
            navDrawer.classList.add('open');
            drawerOverlay.classList.add('active');
            document.body.style.overflow = 'hidden';
        });
        drawerOverlay.addEventListener('click', closeDrawer);
    }

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && navDrawer && navDrawer.classList.contains('open')) {
            closeDrawer();
        }
    });
}

function closeDrawer() {
    const navDrawer = document.getElementById('navDrawer');
    const drawerOverlay = document.getElementById('drawerOverlay');
    if (navDrawer) navDrawer.classList.remove('open');
    if (drawerOverlay) drawerOverlay.classList.remove('active');
    document.body.style.overflow = 'auto';
}

function initializeProfileOptions() {
    const profileBtn = document.querySelector('.profile-btn');
    const profileDropdown = document.getElementById('profileDropdown');

    if (profileBtn) {
        profileBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            profileDropdown.classList.toggle('show');
        });
    }

    document.addEventListener('click', (e) => {
        if (profileDropdown && !profileDropdown.contains(e.target) && profileBtn && !profileBtn.contains(e.target)) {
            profileDropdown.classList.remove('show');
        }
    });

    document.querySelectorAll('.profile-option').forEach(option => {
        option.addEventListener('click', () => {
            const action = option.getAttribute('data-action');
            profileDropdown.classList.remove('show');
            if (action === 'account-settings') {
                // Already on this page
            } else if (action === 'invitations') {
                window.location.href = 'invitation.html';
            } else if (action === 'logout') {
                showLogoutDialog();
            } else if (action === 'language') {
                // TODO: language modal or redirect
            }
        });
    });
}

function showLogoutDialog() {
    const dialog = document.getElementById('logoutDialog');
    if (dialog) {
        dialog.classList.add('show');
        document.body.style.overflow = 'hidden';
    }
}

function closeLogoutDialog() {
    const dialog = document.getElementById('logoutDialog');
    if (dialog) {
        dialog.classList.remove('show');
        document.body.style.overflow = 'auto';
    }
}

function confirmLogout() {
    window.location.href = 'login.html';
}

function initializeSearchableDropdown() {
    const trigger = document.getElementById('dropdownTrigger');
    const menu = document.getElementById('dropdownMenu');
    const searchInput = document.getElementById('searchInput');
    const selectedText = document.getElementById('selectedText');
    const options = document.querySelectorAll('.dropdown-option');
    if (!trigger || !menu) return;

    trigger.addEventListener('click', (e) => {
        e.stopPropagation();
        menu.classList.toggle('show');
        trigger.classList.toggle('active');
    });
    document.addEventListener('click', (e) => {
        if (!e.target.closest('.searchable-dropdown')) {
            menu.classList.remove('show');
            trigger.classList.remove('active');
        }
    });
    searchInput.addEventListener('input', () => {
        const term = searchInput.value.toLowerCase();
        options.forEach(opt => {
            const text = (opt.querySelector('.option-text') || {}).textContent || '';
            opt.classList.toggle('hidden', !text.toLowerCase().includes(term));
        });
    });
    options.forEach(opt => {
        opt.addEventListener('click', () => {
            const text = (opt.querySelector('.option-text') || {}).textContent || 'All';
            if (selectedText) selectedText.textContent = text;
            menu.classList.remove('show');
            trigger.classList.remove('active');
        });
    });
}

function initializeNotifications() {
    const btn = document.getElementById('notificationBtn');
    const dropdown = document.getElementById('notificationsDropdown');
    if (!btn || !dropdown) return;
    btn.addEventListener('click', (e) => {
        e.stopPropagation();
        dropdown.classList.toggle('show');
    });
    document.addEventListener('click', (e) => {
        if (!btn.contains(e.target) && !dropdown.contains(e.target)) {
            dropdown.classList.remove('show');
        }
    });
}

function showToast(message) {
    const el = document.createElement('div');
    el.className = 'account-settings-toast';
    el.textContent = message;
    el.style.cssText = 'position:fixed;bottom:24px;right:24px;background:#1976d2;color:#fff;padding:12px 20px;border-radius:8px;font-size:14px;z-index:9999;box-shadow:0 4px 12px rgba(0,0,0,0.15);';
    document.body.appendChild(el);
    setTimeout(() => el.remove(), 3000);
}

function initializeForms() {
    const profileForm = document.getElementById('profileForm');
    if (profileForm) {
        profileForm.addEventListener('submit', (e) => {
            e.preventDefault();
            showToast('Profile saved.');
        });
    }

    const passwordForm = document.getElementById('passwordForm');
    if (passwordForm) {
        passwordForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const newP = document.getElementById('newPassword').value;
            const confirm = document.getElementById('confirmPassword').value;
            if (newP && newP !== confirm) {
                showToast('Passwords do not match.');
                return;
            }
            showToast('Password updated.');
            passwordForm.reset();
        });
    }

    const languageForm = document.getElementById('languageForm');
    if (languageForm) {
        languageForm.addEventListener('submit', (e) => {
            e.preventDefault();
            showToast('Language saved.');
        });
    }

    const notificationsForm = document.getElementById('notificationsForm');
    if (notificationsForm) {
        notificationsForm.addEventListener('submit', (e) => {
            e.preventDefault();
            showToast('Notification preferences saved.');
        });
    }
}
