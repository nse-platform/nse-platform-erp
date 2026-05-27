<#if requestAttributes.uiLabelMap??><#assign uiLabelMap = requestAttributes.uiLabelMap></#if>
<#assign useMultitenant = Static["org.apache.ofbiz.base.util.UtilProperties"].getPropertyValue("general.properties", "multitenant")>
<#assign username = requestParameters.USERNAME?default((sessionAttributes.autoUserLogin.userLoginId)?default(""))>
<#assign focusName = username == "">

<div class="page page-center">
  <div class="container container-tight py-4">
    <div class="text-center mb-4">
      <a href="<@ofbizUrl>main</@ofbizUrl>" class="navbar-brand navbar-brand-autodark">
        <span class="h2 mb-0">${layoutSettings.companyName!"OFBiz"}</span>
      </a>
    </div>
    <form class="card card-md" method="post" action="<@ofbizUrl>login</@ofbizUrl>" name="loginform" autocomplete="off">
      <div class="card-body">
        <h2 class="card-title text-center mb-4">${uiLabelMap.CommonRegistered}</h2>
        <div class="mb-3">
          <label class="form-label">${uiLabelMap.CommonUsername}</label>
          <input type="text" name="USERNAME" value="${username}" class="form-control" required />
        </div>
        <div class="mb-2">
          <label class="form-label">${uiLabelMap.CommonPassword}</label>
          <input type="password" name="PASSWORD" class="form-control" autocomplete="off" required />
        </div>
        <#if ("Y" == useMultitenant)>
          <#if !requestAttributes.userTenantId??>
            <div class="mb-3">
              <label class="form-label">${uiLabelMap.CommonTenantId}</label>
              <input type="text" name="userTenantId" value="${parameters.userTenantId!}" class="form-control" />
            </div>
          <#else>
            <input type="hidden" name="userTenantId" value="${requestAttributes.userTenantId!}"/>
          </#if>
        </#if>
        <div class="form-footer">
          <button type="submit" class="btn btn-primary w-100">${uiLabelMap.CommonLogin}</button>
        </div>
      </div>
      <input type="hidden" name="JavaScriptEnabled" value="N"/>
    </form>
    <div class="text-center text-secondary mt-3">
      <a href="<@ofbizUrl>forgotPassword</@ofbizUrl>">${uiLabelMap.CommonForgotYourPassword}?</a>
    </div>
  </div>
</div>
<script>
  document.loginform.JavaScriptEnabled.value = "Y";
  <#if focusName>
  document.loginform.USERNAME.focus();
  <#else>
  document.loginform.PASSWORD.focus();
  </#if>
</script>
