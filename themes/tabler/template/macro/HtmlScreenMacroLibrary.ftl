<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.

Theme: Tabler UI (https://tabler.io)
-->

<#-- ============================================================
     renderBegin / renderEnd
     对应 Tabler 文档结构的 HTML 骨架
     ============================================================ -->
<#macro renderBegin>
  <!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover"/>
  <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
<#--  <link rel="stylesheet" href="/tabler/dist/css/tabler.min.css"/>-->
<#--  <link rel="stylesheet" href="/tabler/dist/css/tabler-flags.min.css"/>-->
<#--  <link rel="stylesheet" href="/tabler/dist/css/tabler-socials.min.css"/>-->
<#--  <link rel="stylesheet" href="/tabler/dist/css/tabler-payments.min.css"/>-->
<#--  <link rel="stylesheet" href="/tabler/dist/css/tabler-vendors.min.css"/>-->
</head>
<body class="antialiased">
<div class="wrapper">
  </#macro>

  <#macro renderEnd>
</div><!-- /.wrapper -->
<#--<script src="/tabler/dist/js/tabler.min.js"></script>-->
</body>
</html>
</#macro>

<#-- ============================================================
     renderScreenBegin / renderScreenEnd
     对应页面主内容区 .page-wrapper
     ============================================================ -->
<#macro renderScreenBegin>
<div class="page-wrapper">
  </#macro>

  <#macro renderScreenEnd>
</div><!-- /.page-wrapper -->
</#macro>

<#-- ============================================================
     renderSectionBegin / renderSectionEnd
     保留 HTML 注释边界标记，便于调试
     ============================================================ -->
<#macro renderSectionBegin boundaryComment>
  <#if boundaryComment?has_content>
    <!-- ${boundaryComment} -->
  </#if>
</#macro>

<#macro renderSectionEnd boundaryComment>
  <#if boundaryComment?has_content>
    <!-- /${boundaryComment} -->
  </#if>
</#macro>

<#-- ============================================================
     renderContainerBegin / renderContainerEnd
     通用容器，支持自动刷新（AJAX）
     type 参数映射到 Tabler 容器类：
       - "div"（默认）→ 普通 div
       - "card"       → .card
       - "section"    → .page-body 内的 section
     ============================================================ -->
<#macro renderContainerBegin id autoUpdateInterval type="" style="" autoUpdateLink="">
  <#if autoUpdateLink?has_content>
    <script>
      ajaxUpdateAreaPeriodic('${id}', '${autoUpdateLink}', '', '${autoUpdateInterval}');
    </script>
  </#if>
  <#if type == "card">
<div<#if id?has_content> id="${id}"</#if> class="card<#if style?has_content> ${style}</#if>">
  <#elseif type == "section">
  <section<#if id?has_content> id="${id}"</#if><#if style?has_content> class="${style}"</#if>>
    <#else>
    <div<#if id?has_content> id="${id}"</#if><#if style?has_content> class="${style}"</#if>>
      </#if>
      </#macro>

      <#macro renderContainerEnd type="">
      <#if type == "section">
  </section>
  <#else>
</div>
  </#if>
</#macro>

<#-- ============================================================
     renderContentBegin / renderContentEnd
     内联编辑容器（confMode 下显示编辑按钮）
     ============================================================ -->
<#macro renderContentBegin enableEditValue editContainerStyle editRequest="">
  <#if editRequest?has_content && "true" == enableEditValue>
<div class="${editContainerStyle}">
  </#if>
  </#macro>

  <#macro renderContentBody></#macro>

  <#macro renderContentEnd editMode editContainerStyle enableEditValue editRequest="" urlString="">
  <#if editRequest?? && "true" == enableEditValue>
  <#if urlString??>
    <a href="${urlString}" class="btn btn-sm btn-ghost-secondary">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
           stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
        <path d="M7 7h-1a2 2 0 0 0 -2 2v9a2 2 0 0 0 2 2h9a2 2 0 0 0 2 -2v-1"/>
        <path d="M20.385 6.585a2.1 2.1 0 0 0 -2.97 -2.97l-8.415 8.385v3h3l8.385 -8.415z"/>
      </svg>
      ${editMode}
    </a>
  </#if>
  <#if editContainerStyle??>
</div>
  </#if>
  </#if>
</#macro>

<#-- ============================================================
     renderSubContentBegin / renderSubContentEnd
     子内容区域的编辑容器
     ============================================================ -->
<#macro renderSubContentBegin editContainerStyle enableEditValue editRequest="">
  <#if editRequest?? && "true" == enableEditValue>
<div class="${editContainerStyle}">
  </#if>
  </#macro>

  <#macro renderSubContentBody></#macro>

  <#macro renderSubContentEnd editMode editContainerStyle enableEditValue editRequest="" urlString="">
  <#if editRequest?? && "true" == enableEditValue>
  <#if urlString??>
    <a href="${urlString}" class="btn btn-sm btn-ghost-secondary">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
           stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
        <path d="M7 7h-1a2 2 0 0 0 -2 2v9a2 2 0 0 0 2 2h9a2 2 0 0 0 2 -2v-1"/>
        <path d="M20.385 6.585a2.1 2.1 0 0 0 -2.97 -2.97l-8.415 8.385v3h3l8.385 -8.415z"/>
      </svg>
      ${editMode}
    </a>
  </#if>
  <#if editContainerStyle??>
</div>
  </#if>
  </#if>
</#macro>

<#-- ============================================================
     renderHorizontalSeparator
     → Tabler 分割线 <hr class="my-2">
     ============================================================ -->
<#macro renderHorizontalSeparator id="" style="">
  <hr<#if id?has_content> id="${id}"</#if> class="my-2<#if style?has_content> ${style}</#if>"/>
</#macro>

<#-- ============================================================
     renderLabel
     h1–h6 → Tabler 标题类
     其余样式 → <span class="...">
     ============================================================ -->
<#macro renderLabel text id="" style="">
  <#if text?has_content>
    <#local idAttr = ""/>
    <#if id?has_content><#local idAttr = " id=\"${id}\""/></#if>
    <#if style?has_content>
      <#if style == "h1"><h1${idAttr} class="page-title">${text}</h1>
      <#elseif style == "h2"><h2${idAttr} class="card-title">${text}</h2>
      <#elseif style == "h3"><h3${idAttr} class="subheader">${text}</h3>
      <#elseif style == "h4"><h4${idAttr}>${text}</h4>
      <#elseif style == "h5"><h5${idAttr}>${text}</h5>
      <#elseif style == "h6"><h6${idAttr}>${text}</h6>
      <#else><span${idAttr} class="${style}">${text}</span>
      </#if>
    <#else>
      <span${idAttr}>${text}</span>
    </#if>
  </#if>
</#macro>

<#-- ============================================================
     renderLink
     linkType 映射：
       hidden-form   → POST 表单提交链接
       update-area   → AJAX 局部刷新链接
       layered-modal → Tabler modal 弹窗
       (默认)        → 普通 <a> 链接
     ============================================================ -->
<#macro renderLink parameterList target uniqueItemName linkType actionUrl linkUrl targetWindow="" id="" style="" name="" text="" imgStr="" height="600" width="800">
  <#if "layered-modal" == linkType>
  <#-- Tabler Modal 触发链接 -->
    <#local params = "{&quot;presentation&quot;:&quot;layer&quot;">
    <#if parameterList?has_content>
      <#list parameterList as parameter>
        <#local params += ",&quot;${parameter.name}&quot;:&quot;${parameter.value?html}&quot;">
      </#list>
    </#if>
    <#local params += "}">
    <a href="#modal-${uniqueItemName}"
       data-bs-toggle="modal"
       id="${uniqueItemName}_link"
       data-dialog-params='${params}'
       data-dialog-width="${width}"
       data-dialog-height="${height}"
       data-dialog-url="${target}"
       <#if text?has_content>data-dialog-title="${text}"</#if>
       class="btn btn-sm<#if style?has_content> ${style}</#if>">
      <#if imgStr?has_content>${imgStr}</#if>
      <#if text?has_content>${text}</#if>
    </a>
  <#-- Modal 结构（Tabler 标准） -->
    <div class="modal modal-blur fade" id="modal-${uniqueItemName}" tabindex="-1" role="dialog" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered" style="max-width:${width}px;" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <#if text?has_content><h5 class="modal-title">${text}</h5></#if>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <iframe src="${target}" width="100%" height="${height}" frameborder="0"></iframe>
          </div>
        </div>
      </div>
    </div>
  <#else>
    <#if "hidden-form" == linkType>
      <form method="post" action="${actionUrl}"
            <#if targetWindow?has_content>target="${targetWindow}"</#if>
            onsubmit="javascript:submitFormDisableSubmits(this)"
            name="${uniqueItemName}" class="d-none">
        <#list parameterList as parameter>
          <input name="${parameter.name}" value="${parameter.value?html}" type="hidden"/>
        </#list>
      </form>
    </#if>
    <a
            <#if id?has_content>id="${id}"</#if>
            class="<#if style?has_content>${style}<#else>btn btn-sm btn-ghost-secondary</#if>"
            <#if name?has_content>name="${name}"</#if>
            <#if targetWindow?has_content && "update-area" != linkType>target="${targetWindow}"</#if>
            href="<#if "hidden-form" == linkType>javascript:document.${uniqueItemName}.submit()<#elseif "update-area" == linkType>javascript:ajaxUpdateAreas('${linkUrl}')<#else>${linkUrl}</#if>">
      <#if imgStr?has_content>${imgStr}</#if>
      <#if text?has_content>${text}</#if>
    </a>
  </#if>
</#macro>

<#-- ============================================================
     renderImage
     保持原有语义，加 img-fluid 以适配响应式
     ============================================================ -->
<#macro renderImage src id style wid hgt border alt urlString>
  <#if src?has_content>
    <img
            <#if id?has_content>id="${id}"</#if>
            class="img-fluid<#if style?has_content> ${style}</#if>"
            <#if wid?has_content>width="${wid}"</#if>
            <#if hgt?has_content>height="${hgt}"</#if>
            <#if border?has_content>style="border:${border}px solid transparent"</#if>
            alt="<#if alt?has_content>${alt}</#if>"
            src="${urlString}"/>
  </#if>
</#macro>

<#-- ============================================================
     renderContentFrame
     嵌入 iframe，添加 border-0 以符合 Tabler 风格
     ============================================================ -->
<#macro renderContentFrame fullUrl width height border="">
  <iframe src="${fullUrl}" width="${width}" height="${height}"
          class="border-0<#if border?has_content> border border-${border}</#if>"
          allowfullscreen></iframe>
</#macro>

<#-- ============================================================
     renderScreenletBegin / renderScreenletEnd
     OFBiz Screenlet → Tabler .card
     支持折叠（collapse）、标题、菜单工具栏
     ============================================================ -->
<#macro renderScreenletBegin collapsible saveCollapsed collapsibleAreaId expandToolTip collapseToolTip fullUrlString padded menuString showMore collapsed javaScriptEnabled id="" title="">
<div class="card mb-3<#if id?has_content>" id="${id}</#if>">
  <#if showMore>
    <div class="card-header">
      <#if title?has_content>
        <h3 class="card-title">${title}</h3>
      </#if>
      <div class="card-options">
        <#if menuString?has_content>${menuString}</#if>
        <#if collapsible>
          <a href="#${collapsibleAreaId}"
             class="btn btn-sm btn-ghost-secondary card-options-collapse"
             data-bs-toggle="collapse"
                  <#if javaScriptEnabled>
                    onclick="javascript:toggleScreenlet(this,'${collapsibleAreaId}','${saveCollapsed?string}','${expandToolTip}','${collapseToolTip}');"
                  <#else>
                    href="${fullUrlString}"
                  </#if>
             title="<#if collapsed>${expandToolTip}<#else>${collapseToolTip}</#if>">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
              <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <polyline points="6 9 12 15 18 9"/>
            </svg>
          </a>
        </#if>
      </div>
    </div>
  </#if>
  <div id="${collapsibleAreaId}"
       class="collapse<#if !collapsed> show</#if>">
    <div class="<#if padded>card-body<#else>card-body p-0</#if>">
      </#macro>

      <#macro renderScreenletSubWidget></#macro>

      <#macro renderScreenletEnd>
    </div><!-- /.card-body -->
  </div><!-- /.collapse -->
</div><!-- /.card -->
</#macro>

<#-- ============================================================
     renderScreenletPaginateMenu
     OFBiz 分页导航 → Tabler .pagination
     ============================================================ -->
<#macro renderScreenletPaginateMenu lowIndex actualPageSize ofLabel listSize
paginateLastStyle paginateLastLabel
paginateNextStyle paginateNextLabel
paginatePreviousLabel paginateFirstLabel
firstLinkUrl="" lastLinkUrl="" nextLinkUrl="" previousLinkUrl=""
paginatePreviousStyle="" paginateFirstStyle="">
  <nav aria-label="pagination">
    <ul class="pagination m-0">
      <#-- 首页 -->
      <li class="page-item<#if !firstLinkUrl?has_content> disabled</#if>">
        <#if firstLinkUrl?has_content>
          <a class="page-link" href="${firstLinkUrl}" title="${paginateFirstLabel}">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
              <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <polyline points="11 7 6 12 11 17"/>
              <polyline points="17 7 12 12 17 17"/>
            </svg>
            <span class="visually-hidden">${paginateFirstLabel}</span>
          </a>
        <#else>
          <span class="page-link">
        <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
             stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
          <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
          <polyline points="11 7 6 12 11 17"/>
          <polyline points="17 7 12 12 17 17"/>
        </svg>
      </span>
        </#if>
      </li>
      <#-- 上一页 -->
      <li class="page-item<#if !previousLinkUrl?has_content> disabled</#if>">
        <#if previousLinkUrl?has_content>
          <a class="page-link" href="${previousLinkUrl}" title="${paginatePreviousLabel}">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
              <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <polyline points="15 6 9 12 15 18"/>
            </svg>
            <span class="visually-hidden">${paginatePreviousLabel}</span>
          </a>
        <#else>
          <span class="page-link">
        <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
             stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
          <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
          <polyline points="15 6 9 12 15 18"/>
        </svg>
      </span>
        </#if>
      </li>
      <#-- 页码信息 -->
      <#if (listSize?number > 0)>
        <li class="page-item disabled">
      <span class="page-link text-muted">
        ${lowIndex?number + 1}–${lowIndex?number + actualPageSize?number} ${ofLabel} ${listSize}
      </span>
        </li>
      </#if>
      <#-- 下一页 -->
      <li class="page-item<#if !nextLinkUrl?has_content> disabled</#if>">
        <#if nextLinkUrl?has_content>
          <a class="page-link" href="${nextLinkUrl}" title="${paginateNextLabel}">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
              <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <polyline points="9 6 15 12 9 18"/>
            </svg>
            <span class="visually-hidden">${paginateNextLabel}</span>
          </a>
        <#else>
          <span class="page-link">
        <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
             stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
          <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
          <polyline points="9 6 15 12 9 18"/>
        </svg>
      </span>
        </#if>
      </li>
      <#-- 末页 -->
      <li class="page-item<#if !lastLinkUrl?has_content> disabled</#if>">
        <#if lastLinkUrl?has_content>
          <a class="page-link" href="${lastLinkUrl}" title="${paginateLastLabel}">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
              <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <polyline points="7 7 12 12 7 17"/>
              <polyline points="13 7 18 12 13 17"/>
            </svg>
            <span class="visually-hidden">${paginateLastLabel}</span>
          </a>
        <#else>
          <span class="page-link">
        <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
             stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
          <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
          <polyline points="7 7 12 12 7 17"/>
          <polyline points="13 7 18 12 13 17"/>
        </svg>
      </span>
        </#if>
      </li>
    </ul>
  </nav>
</#macro>

<#-- ============================================================
     renderPortalPageBegin / renderPortalPageEnd
     Portal 页面外层：Tabler .row 替代原来的 <table>
     ============================================================ -->
<#macro renderPortalPageBegin originalPortalPageId portalPageId confMode="false" addColumnLabel="Add column" addColumnHint="Add a new column to this portal">
  <#if "true" == confMode>
    <div class="mb-2 d-flex align-items-center gap-2">
      <a class="btn btn-sm btn-outline-primary"
         href="javascript:document.addColumn_${portalPageId}.submit()"
         title="${addColumnHint}">
        <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-sm" width="16" height="16" viewBox="0 0 24 24"
             stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
          <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
          <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
        </svg>
        ${addColumnLabel}
      </a>
      <span class="badge bg-blue-lt">Portal ID: ${portalPageId}</span>
      <form method="post" action="addPortalPageColumn" name="addColumn_${portalPageId}" class="d-none">
        <input name="portalPageId" value="${portalPageId}" type="hidden"/>
      </form>
    </div>
  </#if>
<div class="row g-3" id="portalPage_${portalPageId}">
  </#macro>

  <#macro renderPortalPageEnd>
</div><!-- /.row (portal page) -->
</#macro>

<#-- ============================================================
     renderPortalPageColumnBegin / renderPortalPageColumnEnd
     Portal 列 → Tabler .col（宽度由 width 参数控制）
     confMode 下显示列管理工具栏
     ============================================================ -->
<#macro renderPortalPageColumnBegin originalPortalPageId portalPageId columnSeqId confMode="false" width="auto"
delColumnLabel="Delete column" delColumnHint="Delete this column"
addPortletLabel="Add portlet" addPortletHint="Add a new portlet to this column"
colWidthLabel="Col. width:" setColumnSizeHint="Set column size">
<#local columnKey = portalPageId + columnSeqId>
  <#local columnKeyFields>
    <input name="portalPageId" value="${portalPageId}" type="hidden"/>
    <input name="columnSeqId" value="${columnSeqId}" type="hidden"/>
  </#local>
  <script>
    if (typeof SORTABLE_COLUMN_LIST != "undefined") {
      SORTABLE_COLUMN_LIST = SORTABLE_COLUMN_LIST
              ? SORTABLE_COLUMN_LIST + ", #portalColumn_${columnSeqId}"
              : "#portalColumn_${columnSeqId}";
    }
  </script>
<div class="col connectedSortable"
     id="portalColumn_${columnSeqId}"
     <#if width?has_content && width != "auto">style="width:${width}; flex: none;"</#if>>
  <#if "true" == confMode>
    <div class="card card-sm mb-2">
      <div class="card-body p-2">
        <div class="d-flex flex-wrap gap-1">
          <form method="post" action="deletePortalPageColumn" name="delColumn_${columnKey}" class="d-none">
            ${columnKeyFields}
          </form>
          <a class="btn btn-sm btn-ghost-danger"
             href="javascript:document.delColumn_${columnKey}.submit()"
             title="${delColumnHint}">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-sm" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
              <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <line x1="4" y1="7" x2="20" y2="7"/><line x1="10" y1="11" x2="10" y2="17"/>
              <line x1="14" y1="11" x2="14" y2="17"/>
              <path d="M5 7l1 12a2 2 0 0 0 2 2h8a2 2 0 0 0 2 -2l1 -12"/>
              <path d="M9 7v-3a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v3"/>
            </svg>
            ${delColumnLabel}
          </a>
          <form method="post" action="addPortlet" name="addPortlet_${columnKey}" class="d-none">
            ${columnKeyFields}
          </form>
          <a class="btn btn-sm btn-ghost-primary"
             href="javascript:document.addPortlet_${columnKey}.submit()"
             title="${addPortletHint}">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-sm" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
              <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            ${addPortletLabel}
          </a>
          <form method="post" action="editPortalPageColumnWidth" name="setColumnSize_${columnKey}" class="d-none">
            ${columnKeyFields}
          </form>
          <a class="btn btn-sm btn-ghost-secondary"
             href="javascript:document.setColumnSize_${columnKey}.submit()"
             title="${setColumnSizeHint}">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-sm" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
              <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <path d="M3 12l18 0"/><path d="M7 16l-4 -4 4 -4"/><path d="M17 8l4 4 -4 4"/>
            </svg>
            ${colWidthLabel} ${width}
          </a>
        </div>
      </div>
    </div>
  </#if>
  </#macro>

  <#macro renderPortalPageColumnEnd>
</div><!-- /.col (portal column) -->
</#macro>

<#-- ============================================================
     renderPortalPagePortletBegin / renderPortalPagePortletEnd
     Portlet → Tabler .card，confMode 显示拖拽/移动控件
     ============================================================ -->
<#macro renderPortalPagePortletBegin originalPortalPageId portalPageId portalPortletId portletSeqId
prevPortletId="" prevPortletSeqId="" nextPortletId="" nextPortletSeqId=""
columnSeqId="" prevColumnSeqId="" nextColumnSeqId=""
confMode="false"
delPortletHint="Remove this portlet"
editAttribute="false"
editAttributeHint="Edit portlet parameters">
<#local portletKey = portalPageId + portalPortletId + portletSeqId>
  <#local portletKeyFields>
    <input name="portalPageId" value="${portalPageId}" type="hidden"/>
    <input name="portalPortletId" value="${portalPortletId}" type="hidden"/>
    <input name="portletSeqId" value="${portletSeqId}" type="hidden"/>
  </#local>
<div id="PP_${portletKey}" name="portalPortlet" class="card mb-3"
     portalPageId="${portalPageId}" portalPortletId="${portalPortletId}"
     columnSeqId="${columnSeqId}" portletSeqId="${portletSeqId}">
  <#if "true" == confMode>
    <div class="card-header py-1 bg-blue-lt" id="PPCFG_${portletKey}">
      <span class="card-title text-muted small me-auto">[${portalPortletId}]</span>
      <div class="card-options gap-1">
        <#-- 删除 Portlet -->
        <form method="post" action="deletePortalPagePortlet" name="delPortlet_${portletKey}" class="d-none">
          ${portletKeyFields}
        </form>
        <a href="javascript:document.delPortlet_${portletKey}.submit()"
           class="btn btn-sm btn-ghost-danger card-options-remove"
           title="${delPortletHint}" aria-label="${delPortletHint}">
          <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-sm" width="16" height="16" viewBox="0 0 24 24"
               stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
            <path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="18" y1="6" x2="6" y2="18"/>
            <line x1="6" y1="6" x2="18" y2="18"/>
          </svg>
        </a>
        <#-- 编辑属性 -->
        <#if "true" == editAttribute>
          <form method="post" action="editPortalPortletAttributes" name="editPortlet_${portletKey}" class="d-none">
            ${portletKeyFields}
          </form>
          <a href="javascript:document.editPortlet_${portletKey}.submit()"
             class="btn btn-sm btn-ghost-secondary"
             title="${editAttributeHint}" aria-label="${editAttributeHint}">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-sm" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
              <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <path d="M9 7h-3a2 2 0 0 0 -2 2v9a2 2 0 0 0 2 2h9a2 2 0 0 0 2 -2v-3"/>
              <path d="M9 15h3l8.5 -8.5a1.5 1.5 0 0 0 -3 -3l-8.5 8.5v3"/>
            </svg>
          </a>
        </#if>
        <#-- 左移（跨列） -->
        <#if prevColumnSeqId?has_content>
          <form method="post" action="updatePortletSeqDragDrop" name="movePortletLeft_${portletKey}" class="d-none">
            <input name="o_portalPageId" value="${portalPageId}" type="hidden"/>
            <input name="o_portalPortletId" value="${portalPortletId}" type="hidden"/>
            <input name="o_portletSeqId" value="${portletSeqId}" type="hidden"/>
            <input name="destinationColumn" value="${prevColumnSeqId}" type="hidden"/>
            <input name="mode" value="DRAGDROPBOTTOM" type="hidden"/>
          </form>
          <a href="javascript:document.movePortletLeft_${portletKey}.submit()"
             class="btn btn-sm btn-ghost-secondary" aria-label="Move left">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-sm" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
              <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <polyline points="15 6 9 12 15 18"/>
            </svg>
          </a>
        </#if>
        <#-- 右移（跨列） -->
        <#if nextColumnSeqId?has_content>
          <form method="post" action="updatePortletSeqDragDrop" name="movePortletRight_${portletKey}" class="d-none">
            <input name="o_portalPageId" value="${portalPageId}" type="hidden"/>
            <input name="o_portalPortletId" value="${portalPortletId}" type="hidden"/>
            <input name="o_portletSeqId" value="${portletSeqId}" type="hidden"/>
            <input name="destinationColumn" value="${nextColumnSeqId}" type="hidden"/>
            <input name="mode" value="DRAGDROPBOTTOM" type="hidden"/>
          </form>
          <a href="javascript:document.movePortletRight_${portletKey}.submit()"
             class="btn btn-sm btn-ghost-secondary" aria-label="Move right">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-sm" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
              <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <polyline points="9 6 15 12 9 18"/>
            </svg>
          </a>
        </#if>
        <#-- 上移（同列） -->
        <#if prevPortletId?has_content>
          <form method="post" action="updatePortletSeqDragDrop" name="movePortletUp_${portletKey}" class="d-none">
            <input name="o_portalPageId" value="${portalPageId}" type="hidden"/>
            <input name="o_portalPortletId" value="${portalPortletId}" type="hidden"/>
            <input name="o_portletSeqId" value="${portletSeqId}" type="hidden"/>
            <input name="d_portalPageId" value="${portalPageId}" type="hidden"/>
            <input name="d_portalPortletId" value="${prevPortletId}" type="hidden"/>
            <input name="d_portletSeqId" value="${prevPortletSeqId}" type="hidden"/>
            <input name="mode" value="DRAGDROPBEFORE" type="hidden"/>
          </form>
          <a href="javascript:document.movePortletUp_${portletKey}.submit()"
             class="btn btn-sm btn-ghost-secondary" aria-label="Move up">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-sm" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
              <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <polyline points="6 15 12 9 18 15"/>
            </svg>
          </a>
        </#if>
        <#-- 下移（同列） -->
        <#if nextPortletId?has_content>
          <form method="post" action="updatePortletSeqDragDrop" name="movePortletDown_${portletKey}" class="d-none">
            <input name="o_portalPageId" value="${portalPageId}" type="hidden"/>
            <input name="o_portalPortletId" value="${portalPortletId}" type="hidden"/>
            <input name="o_portletSeqId" value="${portletSeqId}" type="hidden"/>
            <input name="d_portalPageId" value="${portalPageId}" type="hidden"/>
            <input name="d_portalPortletId" value="${nextPortletId}" type="hidden"/>
            <input name="d_portletSeqId" value="${nextPortletSeqId}" type="hidden"/>
            <input name="mode" value="DRAGDROPAFTER" type="hidden"/>
          </form>
          <a href="javascript:document.movePortletDown_${portletKey}.submit()"
             class="btn btn-sm btn-ghost-secondary" aria-label="Move down">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-sm" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
              <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <polyline points="6 9 12 15 18 9"/>
            </svg>
          </a>
        </#if>
      </div>
    </div><!-- /.card-header (confMode) -->
  </#if>
  </#macro>

  <#macro renderPortalPagePortletEnd confMode="false">
</div><!-- /.card (portlet) -->
</#macro>

<#-- ============================================================
     renderColumnContainerBegin / renderColumnContainerEnd
     原来的 <table> 多列布局 → Tabler .row
     ============================================================ -->
<#macro renderColumnContainerBegin id="" style="">
<div class="row<#if style?has_content> ${style}</#if>"<#if id?has_content> id="${id}"</#if>>
  </#macro>

  <#macro renderColumnContainerEnd>
</div><!-- /.row -->
</#macro>

<#-- ============================================================
     renderColumnBegin / renderColumnEnd
     原来的 <td> → Tabler .col
     ============================================================ -->
<#macro renderColumnBegin id="" style="">
<div class="col<#if style?has_content> ${style}</#if>"<#if id?has_content> id="${id}"</#if>>
  </#macro>

  <#macro renderColumnEnd>
</div><!-- /.col -->
</#macro>
