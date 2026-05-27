<#if (requestAttributes.externalLoginKey)?exists><#assign externalKeyParam = "?externalLoginKey=" + requestAttributes.externalLoginKey?if_exists></#if>
<#if (externalLoginKey)?exists><#assign externalKeyParam = "?externalLoginKey=" + requestAttributes.externalLoginKey?if_exists></#if>
<#assign ofbizServerName = application.getAttribute("_serverId")?default("default-server")>
<#assign contextPath = request.getContextPath()>
<#assign displayApps = Static["org.apache.ofbiz.webapp.WebAppCache"].getShared().getAppBarWebInfos(ofbizServerName, "main")>

<body>
<#include "component://common-theme/template/ImpersonateBanner.ftl"/>
<div class="page">
<header class="navbar navbar-expand-md d-print-none">
  <div class="container-xl">
    <a class="navbar-brand" href="<@ofbizUrl>main</@ofbizUrl>">${layoutSettings.companyName!"OFBiz"}</a>
    <div class="navbar-nav flex-row order-md-last">
      <#if userLogin?has_content><#include "component://tabler/template/includes/Avatar.ftl"/></#if>
    </div>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav">
      <#if displayApps??>
        <#list displayApps as display>
          <#assign thisApp = display.getContextRoot()>
          <#assign thisURL = (thisApp != "/" && thisApp != "/rest")?then(thisApp + "/control/main", thisApp)>
          <li class="nav-item <#if thisApp == contextPath || contextPath + "/" == thisApp>active</#if>">
            <a class="nav-link" href="${thisURL}${StringUtil.wrapString(externalKeyParam)}">
              <span class="nav-link-title"><#if uiLabelMap?exists>${uiLabelMap[display.title]}<#else>${display.title}</#if></span>
            </a>
          </li>
        </#list>
      </#if>
      </ul>
    </div>
  </div>
</header>
<div class="page-wrapper">
