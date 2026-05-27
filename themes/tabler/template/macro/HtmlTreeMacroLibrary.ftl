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
     renderNodeBegin
     树节点开始标签。
     style 有值时渲染为 Tabler .nav 树形列表的父 <ul>，
     随后输出当前节点的 <li class="nav-item">。
     ============================================================ -->
<#macro renderNodeBegin style="">
    <#if style?has_content>
<ul class="nav nav-tree ${style}">
    </#if>
    <li class="nav-item"><#rt/>
        </#macro>

        <#-- ============================================================
             renderLastElement
             渲染子节点列表容器（紧跟在节点内容之后，包裹子节点）。
             对应 Tabler 树形导航的嵌套 <ul class="nav nav-tree">。
             ============================================================ -->
        <#macro renderLastElement style="">
        <ul class="nav nav-tree<#if style?has_content> ${style}</#if>">
            <#rt/>
            </#macro>

            <#-- ============================================================
                 renderNodeEnd
                 树节点结束标签。
                 - processChildren=true  → 关闭子节点 </ul>
                 - isRootNode=true       → 关闭根节点 </ul>
                 ============================================================ -->
            <#macro renderNodeEnd processChildren="" isRootNode="">
            <#if processChildren?has_content && processChildren>
        </ul><#lt/>
        </#if>
    </li><#rt/>
    <#if isRootNode?has_content && isRootNode>
</ul><#lt/>
    </#if>
</#macro>

<#-- ============================================================
     renderLabel
     节点文本标签 → Tabler .nav-link 风格的 <span>。
     保留 id / style 透传，labelText 追加调试后缀已移除。
     ============================================================ -->
<#macro renderLabel id="" style="" labelText="">
    <span class="nav-link-title<#if style?has_content> ${style}</#if>"<#if id?has_content> id="${id}"</#if>><#rt/>
        <#if labelText?has_content>${labelText}</#if><#rt/>
  </span>
</#macro>

<#-- ============================================================
     formatBoundaryComment
     调试用边界注释，保持原有行为不变。
     ============================================================ -->
<#macro formatBoundaryComment boundaryType widgetType widgetName>
    <!-- ${boundaryType} ${widgetType} ${widgetName} -->
</#macro>

<#-- ============================================================
     renderLink
     树节点链接 → Tabler .nav-link。
     - linkUrl 有值 → href="${linkUrl}"
     - linkUrl 为空 → href="javascript:void(0);"
     - imgStr 优先于 linkText 渲染
     - targetWindow 引号闭合 bug 已修复（原模板缺少闭合引号）
     ============================================================ -->
<#macro renderLink id="" style="" name="" title="" targetWindow="" linkUrl="" linkText="" imgStr="">
    <a class="nav-link<#if style?has_content> ${style}</#if>"<#rt/>
    <#if id?has_content> id="${id}"</#if><#rt/>
    <#if name?has_content> name="${name}"</#if><#rt/>
    <#if title?has_content> title="${title}"</#if><#rt/>
    <#if targetWindow?has_content> target="${targetWindow}"</#if><#rt/>
<#if linkUrl?has_content> href="${linkUrl}"<#else> href="javascript:void(0);"</#if>><#rt/>
    <#if imgStr?has_content>
        ${imgStr}
    <#elseif linkText?has_content>
        <span class="nav-link-title">${linkText}</span>
    <#else>
        &nbsp;
    </#if>
    </a><#rt/>
</#macro>

<#-- ============================================================
     renderImage
     节点图标/图片 → 保持 <img>，补充 img-fluid 响应式类。
     border 参数改为 inline style，避免 HTML5 废弃属性警告。
     ============================================================ -->
<#macro renderImage src="" id="" style="" wid="" hgt="" border="" alt="" urlString="">
    <#if src?has_content>
        <img
        <#if id?has_content>id="${id}"</#if>
        class="img-fluid<#if style?has_content> ${style}</#if>"
        <#if wid?has_content>width="${wid}"</#if>
        <#if hgt?has_content>height="${hgt}"</#if>
        <#if border?has_content>style="border:${border}px solid transparent"</#if>
        alt="<#if alt?has_content>${alt}</#if>"
        src="${urlString}"/><#rt/>
    </#if>
</#macro>
