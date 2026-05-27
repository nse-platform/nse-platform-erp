<div class="nav-item dropdown">
  <a href="#" class="nav-link d-flex lh-1 text-reset p-0" data-bs-toggle="dropdown" aria-label="Open user menu">
    <span class="avatar avatar-sm" <#if avatarDetail?has_content>style="background-image: url(${avatarDetail.infoString!})"</#if>></span>
    <div class="d-none d-xl-block ps-2">
      <div>${userLogin.userLoginId!}</div>
    </div>
  </a>
  <div class="dropdown-menu dropdown-menu-end dropdown-menu-arrow">
    <a href="<@ofbizUrl>logout</@ofbizUrl>" class="dropdown-item">${uiLabelMap.CommonLogout!"Logout"}</a>
  </div>
</div>
